//
//  MBAlertView.h
//  MBAlertDemo
//
//  Created by Matthias Bauch on 2/18/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MBAlertViewStyle) {
    MBAlertViewStyleDefault,
    MBAlertViewStyleSecureTextInput,
    MBAlertViewStylePlainTextInput,
    MBAlertViewStyleLoginAndPasswordInput
};

@interface MBAlertView : UIView
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *message;

@property (assign, nonatomic) MBAlertViewStyle alertStyle;

@property (assign, nonatomic) NSInteger cancelButtonIndex;
@property (assign, nonatomic) NSInteger destructiveButtonIndex;

// appearance

@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *messageFont;
@property (strong, nonatomic) UIFont *buttonFont;


// views

@property (readonly, nonatomic) UITextField *textField0;
@property (readonly, nonatomic) UITextField *textField1;



- (NSInteger)addButtonWithTitle:(NSString *)title action:(void (^)(void))actionBlock;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;
- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
@end
