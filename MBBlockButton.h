//
//  MBBlockButton.h
//  MBAlertDemo
//
//  Created by Matthias Bauch on 2/18/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBBlockButton : NSObject
@property (strong, nonatomic) UIButton *button;
@property (readonly, nonatomic) NSString *buttonTitle;
@property (readonly, nonatomic) void (^actionBlock)(void);
@property (readonly, nonatomic) BOOL (^enableButtonBlock)(UIButton *);

+ (instancetype)buttonWithTitle:(NSString *)title action:(void (^)(void))actionBlock enable:(BOOL (^)(UIButton *button))enableBlock;
- (id)initWithTitle:(NSString *)title action:(void (^)(void))actionBlock enable:(BOOL (^)(UIButton *button))enableBlock;

@end
