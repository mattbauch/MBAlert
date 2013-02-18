//
//  MBBlockButton.m
//  MBAlertDemo
//
//  Created by Matthias Bauch on 2/18/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import "MBBlockButton.h"

@implementation MBBlockButton

+ (instancetype)buttonWithTitle:(NSString *)title action:(void (^)(void))actionBlock enable:(BOOL (^)(UIButton *button))enableBlock {
    return [[self alloc] initWithTitle:title action:actionBlock enable:enableBlock];
}

- (id)initWithTitle:(NSString *)title action:(void (^)(void))actionBlock enable:(BOOL (^)(UIButton *button))enableBlock {
    self = [super init];
    if (self) {
        _buttonTitle = [title copy];
        _actionBlock = [actionBlock copy];
        _enableButtonBlock = [enableBlock copy];
    }
    return self;
}

@end
