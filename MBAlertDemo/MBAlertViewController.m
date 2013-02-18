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
    alert.title = title;
    alert.message = message;
    if (sender == self.uiAlertNoButton) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
        });
    }
    else if (sender == self.uiAlert1Button) {
        NSInteger index = [alert addButtonWithTitle:@"Cancel"];
        alert.cancelButtonIndex = index;
    }
    else if (sender == self.uiAlert2Button) {
        [alert addButtonWithTitle:@"Normal Button"];
        [alert addButtonWithTitle:@"Cancel"];
        alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Normal Button", nil];
    }
    else if (sender == self.uiAlert3Button) {
        [alert addButtonWithTitle:@"Normal Button 1"];
        [alert addButtonWithTitle:@"Normal Button 2"];
        [alert addButtonWithTitle:@"Cancel"];
    }
    else if (sender == self.uiAlertPlainTextFieldButton) {
        [alert addButtonWithTitle:@"Set"];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    else if (sender == self.uiAlertSecretTextFieldButton) {
        [alert addButtonWithTitle:@"Set"];
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    }
    else if (sender == self.uiLoginTextFieldButton) {
        [alert addButtonWithTitle:@"Set"];
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
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
    alert.title = title;
    alert.message = message;
    if (sender == self.mbAlertNoButton) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
        });
    }
    else if (sender == self.mbAlert1Button) {
        NSInteger index = [alert addButtonWithTitle:@"Cancel" action:^{
            NSLog(@"Cancel");
        }];
        alert.cancelButtonIndex = index;
    }
    else if (sender == self.mbAlert2Button) {
        [alert addButtonWithTitle:@"Normal Button" action:^{
            NSLog(@"Normal Button");
        }];
        [alert addButtonWithTitle:@"Cancel" action:^{
            NSLog(@"Cancel");
        }];
    }
    else if (sender == self.mbAlert3Button) {
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
    else if (sender == self.mbAlertPlainTextFieldButton) {
        __weak MBAlertView *weakAlert = alert;
        [alert addButtonWithTitle:@"Set" action:^{
            NSLog(@"Set %@", weakAlert.textField0.text);
        }];
        alert.alertStyle = MBAlertViewStylePlainTextInput;
    }
    else if (sender == self.mbAlertSecretTextFieldButton) {
        __weak MBAlertView *weakAlert = alert;
        [alert addButtonWithTitle:@"Set" action:^{
            NSLog(@"Set %@", weakAlert.textField0.text);
        }];
        alert.alertStyle = MBAlertViewStyleSecureTextInput;
    }
    else if (sender == self.mbLoginTextFieldButton) {
        __weak MBAlertView *weakAlert = alert;
        [alert addButtonWithTitle:@"Set" action:^{
            NSLog(@"Set \"%@\" - \"%@\"", weakAlert.textField0.text, weakAlert.textField1.text);
        }];
        alert.alertStyle = MBAlertViewStyleLoginAndPasswordInput;
    }
    else {
        abort();
    }
    [alert show];
}

- (void)viewDidUnload {
    [self setUiAlertPlainTextFieldButton:nil];
    [self setMbAlertPlainTextFieldButton:nil];
    [self setUiAlertSecretTextFieldButton:nil];
    [self setMbAlertSecretTextFieldButton:nil];
    [self setUiLoginTextFieldButton:nil];
    [self setMbLoginTextFieldButton:nil];
    [super viewDidUnload];
}
@end
