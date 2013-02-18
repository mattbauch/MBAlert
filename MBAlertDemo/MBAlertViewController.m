//
//  MBViewController.m
//  MBAlertDemo
//
//  Created by Matthias Bauch on 2/18/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import "MBAlertViewController.h"
#import "MBAlertView.h"

@interface MBAlertViewController ()

@end

@implementation MBAlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uiButtonPressed:(UIButton *)sender {
    NSString *title = @"This is a title";
    NSString *message = @"This is a message";
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    if (sender == self.uiAlertNoButton) {
        alert.title = title;
        alert.message = message;
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
        });
    }
    else if (sender == self.uiAlert1Button) {
        alert.title = title;
        alert.message = message;
        NSInteger index = [alert addButtonWithTitle:@"Cancel"];
        alert.cancelButtonIndex = index;
    }
    else if (sender == self.uiAlert2Button) {
        alert.title = title;
        alert.message = message;
        [alert addButtonWithTitle:@"Normal Button"];
        [alert addButtonWithTitle:@"Cancel"];
        alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Normal Button", nil];
    }
    else if (sender == self.uiAlert3Button) {
        alert.title = title;
        alert.message = message;
        [alert addButtonWithTitle:@"Normal Button 1"];
        [alert addButtonWithTitle:@"Normal Button 2"];
        [alert addButtonWithTitle:@"Cancel"];
    }
    else {
        abort();
    }
    [alert show];
}

- (IBAction)mbButtonPressed:(UIButton *)sender {
    NSString *title = @"This is a title";
    NSString *message = @"This is a message";
    
    MBAlertView *alert = [[MBAlertView alloc] init];
    if (sender == self.mbAlertNoButton) {
        alert.title = title;
        alert.message = message;
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
        });
    }
    else if (sender == self.mbAlert1Button) {
        alert.title = title;
        alert.message = message;
        NSInteger index = [alert addButtonWithTitle:@"Cancel" action:^{
            NSLog(@"Cancel");
        }];
        alert.cancelButtonIndex = index;
    }
    else if (sender == self.mbAlert2Button) {
        alert.title = title;
        alert.message = message;
        [alert addButtonWithTitle:@"Normal Button" action:^{
            NSLog(@"Normal Button");
        }];
        [alert addButtonWithTitle:@"Cancel" action:^{
            NSLog(@"Cancel");
        }];
    }
    else if (sender == self.mbAlert3Button) {
        alert.title = title;
        alert.message = message;
        [alert addButtonWithTitle:@"Normal Button 1" action:^{
            NSLog(@"Normal Button 1");
        }];
        [alert addButtonWithTitle:@"Normal Button 2" action:^{
            NSLog(@"Normal Button 2");
        }];
        [alert addButtonWithTitle:@"Cancel" action:^{
            NSLog(@"Cancel");
        }];
    }
    else {
        abort();
    }
    [alert show];
}

@end
