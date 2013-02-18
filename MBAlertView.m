//
//  MBAlertView.m
//  MBAlertDemo
//
//  Created by Matthias Bauch on 2/18/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import "MBAlertView.h"
#import <QuartzCore/QuartzCore.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
#error This project uses code that is only available in iOS 5 or later
// e.g. UIKeyboardWillChangeFrameNotification
#endif

static NSString * const MBAnimationType = @"MBAnimationType";
static NSString * const MBAlertViewAnimationDismiss = @"MBAlertViewAnimationDismiss";
static NSString * const MBAlertViewAnimationShow = @"MBAlertViewAnimationShow";


@interface MBAlertButton : NSObject
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) NSString *buttonTitle;
@property (copy, nonatomic) void (^actionBlock)(void);
@property (copy, nonatomic) BOOL (^enableButtonBlock)(void);
@end

@implementation MBAlertButton
@end



@interface MBAlertView ()

@property (strong, nonatomic) UIView *alertView;
@property (strong, nonatomic) UIScrollView *textScrollView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@property (strong, nonatomic) UIScrollView *buttonScrollView;

@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) MBAlertButton *cancelButton;
@property (strong, nonatomic) MBAlertButton *destructiveButton;
@end

@implementation MBAlertView {
    CGRect _originalAlertFrame;
}

- (id)initWithFrame:(CGRect)frame {
    return [self init];
}

- (id)init {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSCParameterAssert(window);
    self = [super initWithFrame:window.bounds];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        self.layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0].CGColor;
        
        _cancelButtonIndex = -1;                // = last button
        _destructiveButtonIndex = NSNotFound;   // = no button
        
        _buttons = [NSMutableArray arrayWithCapacity:5];
        
        
        // Create UITextFields here because we want to be able to manipulate them from the caller
        _textField0 = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField0.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _textField0.borderStyle = UITextBorderStyleRoundedRect;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangedText:) name:UITextFieldTextDidChangeNotification object:_textField0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangedText:) name:UITextFieldTextDidBeginEditingNotification object:_textField0];
        
        
        _textField1 = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField1.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _textField1.borderStyle = UITextBorderStyleRoundedRect;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangedText:) name:UITextFieldTextDidChangeNotification object:_textField1];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangedText:) name:UITextFieldTextDidBeginEditingNotification object:_textField1];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_textField0];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:_textField0];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_textField1];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:_textField1];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message {
    if (self) {
        _title = [title copy];
        _message = [message copy];
    }
    return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title action:(void (^)(void))actionBlock {
    return [self addButtonWithTitle:title action:actionBlock enable:nil];
}

- (NSInteger)addButtonWithTitle:(NSString *)title action:(void (^)(void))actionBlock enable:(BOOL (^)(void))enableBlock {
    MBAlertButton *button = [[MBAlertButton alloc] init];
    button.buttonTitle = title;
    button.actionBlock = actionBlock;
    button.enableButtonBlock = enableBlock;
    [_buttons addObject:button];
    NSInteger index = [_buttons count] - 1;
    return index;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSCParameterAssert(window);
    [window addSubview:self];
        
    UIImage *regularButtonBackgroundNormal = [[UIImage imageNamed:@"alertRegularButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 18)];
    UIImage *regularButtonBackgroundPressed = [[UIImage imageNamed:@"alertRegularButtonPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 18)];;
    UIImage *cancelButtonBackgroundNormal = [[UIImage imageNamed:@"alertCancelButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 18)];
    UIImage *cancelButtonBackgroundPressed = [[UIImage imageNamed:@"alertCancelPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 18)];
    UIImage *destructiveButtonBackgroundNormal = [[UIImage imageNamed:@"alertDestructiveButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 18)];
    UIImage *destructiveButtonBackgroundPressed = [[UIImage imageNamed:@"alertDestructiveButtonPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 18)];

    CGFloat windowHeight = window.bounds.size.height;
    CGFloat windowWidth = window.bounds.size.width;

    CGFloat alertWidth = 280.0f;
    CGFloat alertHeight = 0;
    CGFloat edgeInset = 10.0f;
    
    CGFloat usableAlertWidth = alertWidth - 2 * edgeInset;
    
    UIFont *titleFont = self.titleFont ? : [UIFont boldSystemFontOfSize:18.0f];
    UIFont *messageFont = self.messageFont ? : [UIFont systemFontOfSize:16.0f];
    UIFont *buttonFont = self.buttonFont ? : [UIFont boldSystemFontOfSize:18.0f];
    
    CGSize titleSize = [self.title sizeWithFont:titleFont constrainedToSize:CGSizeMake(usableAlertWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize messageSize = [self.message sizeWithFont:messageFont constrainedToSize:CGSizeMake(usableAlertWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect titleRect = CGRectMake(edgeInset, edgeInset/2, usableAlertWidth, titleSize.height);
    CGRect messageRect = CGRectMake(edgeInset, titleRect.origin.y + edgeInset + titleRect.size.height, usableAlertWidth, messageSize.height);
    
    CGRect textRect = CGRectMake(0, edgeInset/2, alertWidth, edgeInset/2 + titleRect.size.height + edgeInset + messageRect.size.height);

    alertHeight = textRect.origin.y + textRect.size.height;

    CGRect textFieldRect = CGRectMake(edgeInset, textRect.origin.y + edgeInset + textRect.size.height, 0, 0);
    if (self.alertStyle != MBAlertViewStyleDefault) {
        CGFloat textFieldHeight = 0;
        if (self.alertStyle == MBAlertViewStyleLoginAndPasswordInput) {
            textFieldHeight = 30.0f + edgeInset/2 + 30.0f;
        }
        else {
            textFieldHeight = 30.0f;
        }
        textFieldRect.size = CGSizeMake(usableAlertWidth, textFieldHeight + edgeInset);
    }
    
    alertHeight += textFieldRect.size.height;
    
    CGFloat cancelButtonOffset = 0;
    NSInteger numberOfButtonRows = [self.buttons count];
    if (numberOfButtonRows == 2) {
        // 2 buttons are placed next to each other
        numberOfButtonRows = 1;
    }
    else if (numberOfButtonRows > 2 && self.cancelButtonIndex != NSNotFound) {
        // make more space between normal button and cancel button
        cancelButtonOffset = edgeInset * 2;
    }
    CGFloat singleButtonHeight = 46.0f;
    
    if (regularButtonBackgroundNormal) {
        singleButtonHeight = regularButtonBackgroundNormal.size.height;
    }
    CGFloat buttonsHeight = numberOfButtonRows * singleButtonHeight + (numberOfButtonRows-1) * edgeInset + cancelButtonOffset;
    CGRect buttonsRect = CGRectMake(edgeInset, textFieldRect.origin.y + textFieldRect.size.height, usableAlertWidth, buttonsHeight);
    
    
    alertHeight += edgeInset + buttonsRect.size.height;
    
    
    // bottom edge
    alertHeight += edgeInset;
    
    _alertView = [[UIView alloc] initWithFrame:CGRectMake(windowWidth/2 - alertWidth/2, windowHeight/2 - alertHeight/2, alertWidth, alertHeight)];
    _alertView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    _alertView.layer.shadowColor = [UIColor blackColor].CGColor;
    _alertView.layer.shadowOpacity = 0.7;
    _alertView.layer.shadowOffset = CGSizeMake(0, 3);

    [self addSubview:_alertView];
    
    UIImage *background = [[UIImage imageNamed:@"alertBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(38, 0, 12, 0)];
    if (background) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
        imageView.frame = _alertView.bounds;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_alertView addSubview:imageView];
    }
    else {
        _alertView.backgroundColor = [UIColor colorWithRed:45/255.0f green:59/255.0f blue:99/255.0f alpha:0.9];
        _alertView.layer.cornerRadius = 10.0f;
        _alertView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
        _alertView.layer.borderWidth = 2.0f;
    }

    _textScrollView = [[UIScrollView alloc] initWithFrame:textRect];
    _textScrollView.contentSize = textRect.size;
    [_alertView addSubview:_textScrollView];

    _titleLabel = [[UILabel alloc] initWithFrame:titleRect];
    _titleLabel.font = titleFont;
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.shadowColor = [UIColor blackColor];
    _titleLabel.shadowOffset = CGSizeMake(0, -1);
    [_textScrollView addSubview:_titleLabel];
    _titleLabel.text = self.title;

    _messageLabel = [[UILabel alloc] initWithFrame:messageRect];
    _messageLabel.font = messageFont;
    _messageLabel.numberOfLines = 0;
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.shadowColor = [UIColor blackColor];
    _messageLabel.shadowOffset = CGSizeMake(0, -1);
    [_textScrollView addSubview:_messageLabel];
    _messageLabel.text = self.message;

    
    if (self.alertStyle != MBAlertViewStyleDefault) {
        CGRect textField0Frame = CGRectMake(edgeInset, textFieldRect.origin.y, usableAlertWidth, 30.0f);
        _textField0.frame = textField0Frame;
        [_alertView addSubview:_textField0];
        
        if (self.alertStyle == MBAlertViewStyleLoginAndPasswordInput) {
            CGRect textField1Frame = CGRectMake(edgeInset, textFieldRect.origin.y + 30 + edgeInset/2, usableAlertWidth, 30.0f);
            _textField1.frame = textField1Frame;
            [_alertView addSubview:_textField1];

            _textField1.secureTextEntry = YES;
            _textField0.placeholder = @"Login";
            _textField1.placeholder = @"Password";
        }
        else {
            [_textField1 removeFromSuperview];
            _textField0.placeholder = nil;
            _textField1.placeholder = nil;
        }

        if (self.alertStyle == MBAlertViewStyleSecureTextInput) {
            _textField0.secureTextEntry = YES;
        }
        else {
            _textField0.secureTextEntry = NO;
        }
    }
    else {
        [_textField0 removeFromSuperview];
        [_textField1 removeFromSuperview];
    }
    
    _buttonScrollView = [[UIScrollView alloc] initWithFrame:buttonsRect];
    _buttonScrollView.contentSize = buttonsRect.size;
    [_alertView addSubview:_buttonScrollView];
        
    const NSInteger buttonCount = [self.buttons count];
    for (NSInteger i = 0; i < buttonCount; i++) {
        MBAlertButton *alertButton = self.buttons[i];
        NSString *buttonTitle = alertButton.buttonTitle;
        UIButton *button = alertButton.button;
        if (!button) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        if (i == _destructiveButtonIndex) {
            if (destructiveButtonBackgroundNormal) {
                [button setBackgroundImage:destructiveButtonBackgroundNormal forState:UIControlStateNormal];
                [button setBackgroundImage:destructiveButtonBackgroundPressed forState:UIControlStateHighlighted];
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
                button.titleLabel.shadowOffset = CGSizeMake(0, -1);
            }
            else {
                button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            }
        }
        else if (i == _cancelButtonIndex || (_cancelButtonIndex == -1 && i == buttonCount-1)) {
            if (cancelButtonBackgroundNormal) {
                [button setBackgroundImage:cancelButtonBackgroundNormal forState:UIControlStateNormal];
                [button setBackgroundImage:cancelButtonBackgroundPressed forState:UIControlStateHighlighted];
                button.titleLabel.shadowOffset = CGSizeMake(0, -1);
            }
            else {
                button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            }
        }
        else {
            if (regularButtonBackgroundNormal) {
                [button setBackgroundImage:regularButtonBackgroundNormal forState:UIControlStateNormal];
                [button setBackgroundImage:regularButtonBackgroundPressed forState:UIControlStateHighlighted];
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
                button.titleLabel.shadowOffset = CGSizeMake(0, -1);
            }
            else {
                button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            }
        }
        
        button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        alertButton.button = button;
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        button.titleLabel.font = buttonFont;
        if ([button.titleLabel respondsToSelector:@selector(setMinimumScaleFactor:)]) {
            [button.titleLabel setMinimumScaleFactor:0.5];
        }
        else {
            button.titleLabel.minimumFontSize = buttonFont.pointSize / 2;
        }
        [button addTarget:self action:@selector(alertButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonScrollView addSubview:button];
        
        CGFloat buttonY = 0;
        
        CGRect buttonFrame = CGRectZero;
        if (buttonCount == 2) {
            CGFloat buttonWidth = (usableAlertWidth/2) - (edgeInset/2);
            if ((i == _cancelButtonIndex || (_cancelButtonIndex == -1 && i == buttonCount-1))) {
                buttonFrame = CGRectMake(0, buttonY, buttonWidth, singleButtonHeight);
            }
            else {
                buttonFrame = CGRectMake((usableAlertWidth/2) + edgeInset/2, buttonY, buttonWidth, singleButtonHeight);
            }
        }
        else {
            CGFloat y = (singleButtonHeight + edgeInset) * i;
            if ((i == _cancelButtonIndex) || (_cancelButtonIndex == -1 && (i == buttonCount-1))) {
                y += cancelButtonOffset;
            }
            buttonFrame = CGRectMake(0, y, usableAlertWidth, singleButtonHeight);
        }
        button.frame = buttonFrame;
    }
    
    
    _originalAlertFrame = _alertView.frame;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.delegate = self;
    [scaleAnimation setValue:MBAlertViewAnimationShow forKey:MBAnimationType];
    [self.alertView.layer addAnimation:scaleAnimation forKey:@"scale"];
    
    CABasicAnimation *backgroundColor = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColor.fromValue = (__bridge id)([[UIColor blackColor] colorWithAlphaComponent:0.0].CGColor);
    backgroundColor.toValue = (__bridge id)([[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor);
    self.layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    [self.layer addAnimation:backgroundColor forKey:@"color"];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [self dismissView:animated];
}

#pragma mark - IBAction

- (IBAction)alertButtonPressed:(UIButton *)sender {
    MBAlertButton *alertButton = [self alertButtonForUIButton:sender];
    if (alertButton.actionBlock) {
        alertButton.actionBlock();
    }
    [self dismissView:YES];
}

- (MBAlertButton *)alertButtonForUIButton:(UIButton *)button {
    NSIndexSet *indexes = [self.buttons indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        MBAlertButton *alertButton = obj;
        if (alertButton.button == button) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    NSArray *objects = [self.buttons objectsAtIndexes:indexes];
    return [objects lastObject];
}

- (void)dismissView:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.textField0 resignFirstResponder];
    [self.textField1 resignFirstResponder];

    if (animated) {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)];
        scaleAnimation.delegate = self;
        [scaleAnimation setValue:MBAlertViewAnimationDismiss forKey:MBAnimationType];
        [self.alertView.layer addAnimation:scaleAnimation forKey:@"scale"];
        self.alertView.layer.transform = CATransform3DMakeScale(0, 0, 0);
        
        CABasicAnimation *backgroundColor = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        backgroundColor.fromValue = (__bridge id)([[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor);
        backgroundColor.toValue = (__bridge id)([[UIColor blackColor] colorWithAlphaComponent:0.0].CGColor);
        self.layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0].CGColor;
        [self.layer addAnimation:backgroundColor forKey:@"color"];
    }
    else {
        [self removeFromSuperview];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *type = [anim valueForKey:MBAnimationType];
    if ([type isEqualToString:MBAlertViewAnimationDismiss]) {
        // animation did dismiss alert
        [self removeFromSuperview];
    }
    else if ([type isEqualToString:MBAlertViewAnimationShow]) {
        if (self.alertStyle != MBAlertViewStyleDefault) {
            [self.textField0 becomeFirstResponder];
        }
    }
    else {
        NSLog(@"Unknown Animation %@", type ? : anim);
    }
}


- (void)keyboardFrameDidChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect keyboardEndFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardEndFrame = [self convertRect:keyboardEndFrame fromView:self.window];
    
    UIViewAnimationOptions options = 0;
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            options |= UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            options |= UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            options |= UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            options |= UIViewAnimationOptionCurveLinear;
            break;
    }
    
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        BOOL showKeyboard = YES;
        CGRect frame = self.alertView.frame;
        if (!CGRectIntersectsRect(keyboardEndFrame, self.frame)) {
            showKeyboard = NO;
        }
        
        if (showKeyboard) {
            CGFloat newHeight = MIN(self.frame.size.height - keyboardEndFrame.size.height, _originalAlertFrame.size.height);
            CGFloat newY = MAX(0, self.frame.size.height - keyboardEndFrame.size.height - newHeight - 10.0f);
            frame = CGRectMake(frame.origin.x, newY, frame.size.width, newHeight);
        }
        else {
            frame = _originalAlertFrame;
        }
        self.alertView.frame = frame;
    } completion:^(BOOL finished) {
        if (CGRectIntersectsRect(keyboardEndFrame, self.frame) && finished) {
            [self.textScrollView flashScrollIndicators];
        }
    }];
}

- (void)evaluateButtonEnabledStates {
    for (MBAlertButton *button in self.buttons) {
        BOOL enable = YES;
        if (button.enableButtonBlock) {
            enable = button.enableButtonBlock();
        }
        button.button.enabled = enable;
    }
}

- (void)textFieldChangedText:(NSNotification *)notification {
    [self evaluateButtonEnabledStates];
}

@end
