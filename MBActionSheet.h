//
//  MBActionSheet.h
//  MBAlertDemo
//
//  Created by Matthias Bauch on 2/18/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBActionSheet : UIView
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger cancelButtonIndex;
@property (assign, nonatomic) NSInteger destructiveButtonIndex;

@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *messageFont;
@property (strong, nonatomic) UIFont *buttonFont;

- (id)initWithTitle:(NSString *)title;

- (NSInteger)addButtonWithTitle:(NSString *)title action:(void (^)(void))actionBlock;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
@end
