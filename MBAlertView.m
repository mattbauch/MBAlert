//
//  MBAlertView.m
//  MBAlertDemo
//
//  Created by Matthias Bauch on 2/18/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import "MBAlertView.h"
#import <QuartzCore/QuartzCore.h>

NSString * const MBAnimationType = @"MBAnimationType";
NSString * const MBAlertViewAnimationDismiss = @"MBAlertViewAnimationDismiss";

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

@implementation MBAlertView

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
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message {
    if (self) {
        _title = [title copy];
        _message = [message copy];
    }
    return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title action:(void (^)(void))actionBlock {
    MBAlertButton *button = [[MBAlertButton alloc] init];
    button.buttonTitle = title;
    button.actionBlock = actionBlock;
    [_buttons addObject:button];
    NSInteger index = [_buttons count] - 1;
    return index;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSCParameterAssert(window);
    [window addSubview:self];
    
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
    
    CGFloat textFieldHeight = 0;
    CGRect textFieldRect = CGRectMake(edgeInset, textRect.origin.y + edgeInset + textRect.size.height, usableAlertWidth, textFieldHeight);
    
    alertHeight = textRect.origin.y + textRect.size.height;
    
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
    
    UIImage *background = [[UIImage imageNamed:@"alert-window"] resizableImageWithCapInsets:UIEdgeInsetsMake(38, 0, 12, 0)];
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

    
    _buttonScrollView = [[UIScrollView alloc] initWithFrame:buttonsRect];
    _buttonScrollView.contentSize = buttonsRect.size;
    [_alertView addSubview:_buttonScrollView];
    
    _buttonScrollView.backgroundColor = [UIColor blueColor];
    
    UIImage *regularButtonBackgroundNormal = [[UIImage imageNamed:@"ButtonRegular"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)];
    UIImage *regularButtonBackgroundPressed = [[UIImage imageNamed:@"ButtonRegularPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)];
    UIImage *cancelButtonBackgroundNormal = [[UIImage imageNamed:@"ButtonCancel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)];
    UIImage *cancelButtonBackgroundPressed = [[UIImage imageNamed:@"ButtonRegularPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)];
    UIImage *destructiveButtonBackgroundNormal = [[UIImage imageNamed:@"ButtonDestructive"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)];
    UIImage *destructiveButtonBackgroundPressed = [[UIImage imageNamed:@"ButtonDestructivePressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)];

    
    const NSInteger buttonCount = [self.buttons count];
    for (NSInteger i = 0; i < buttonCount; i++) {
        MBAlertButton *alertButton = self.buttons[i];
        NSString *buttonTitle = alertButton.buttonTitle;
        UIButton *button = alertButton.button;
        if (!button) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        if (alertButton == self.destructiveButton) {
            if (!destructiveButtonBackgroundNormal) {
                // if no images replace custom button with round button
                button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            }
            [button setBackgroundImage:destructiveButtonBackgroundNormal forState:UIControlStateNormal];
            [button setBackgroundImage:destructiveButtonBackgroundPressed forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        }
        else if (alertButton == self.cancelButton) {
            if (!cancelButtonBackgroundNormal) {
                // if no images replace custom button with round button
                button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            }
            [button setBackgroundImage:cancelButtonBackgroundNormal forState:UIControlStateNormal];
            [button setBackgroundImage:cancelButtonBackgroundPressed forState:UIControlStateHighlighted];
        }
        else {
            if (!regularButtonBackgroundNormal) {
                // if no images replace custom button with round button
                button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            }
            [button setBackgroundImage:regularButtonBackgroundNormal forState:UIControlStateNormal];
            //            [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [button setBackgroundImage:regularButtonBackgroundPressed forState:UIControlStateHighlighted];
            //            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        }
        
        button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        alertButton.button = button;
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        button.titleLabel.font = buttonFont;
        button.titleLabel.shadowOffset = CGSizeMake(0, -1);
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
            NSInteger leftButtonIndex = self.cancelButton ? 1 : 0; // Cancel should be left button
            if (i == leftButtonIndex) {
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
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
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
    [self dismissView:YES];
}

- (void)dismissView:(BOOL)animated {
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
}

@end
