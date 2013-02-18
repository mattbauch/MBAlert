//
//  MBBlockButton.h
//  MBAlertDemo
//
//  Created by Matthias Bauch on 2/18/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBBlockButton : UIView
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) NSString *buttonTitle;
@property (copy, nonatomic) void (^actionBlock)(void);
@property (copy, nonatomic) BOOL (^enableButtonBlock)(UIButton *);
@end
