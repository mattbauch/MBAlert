//
//  MBActionSheet.m
//  MBAlertDemo
//
//  Created by Matthias Bauch on 2/18/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import "MBActionSheet.h"
#import "MBBlockButton.h"
#import <QuartzCore/QuartzCore.h>

@interface MBActionSheet ()

@property (strong, nonatomic) UIView *actionSheet;
@property (strong, nonatomic) UIScrollView *textScrollView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIScrollView *buttonScrollView;

@property (strong, nonatomic) NSMutableArray *buttons;
@end

@implementation MBActionSheet

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

- (id)initWithTitle:(NSString *)title {
    if (self) {
        _title = [title copy];
    }
    return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title action:(void (^)(void))actionBlock {
    MBBlockButton *button = [MBBlockButton buttonWithTitle:title action:actionBlock enable:nil];
    [_buttons addObject:button];
    return [_buttons count] - 1;
}

- (void)show {
    
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    
}

@end
