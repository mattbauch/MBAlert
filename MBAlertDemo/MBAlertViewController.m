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
        [alert addButtonWithTitle:@"Cancel"];
        [alert addButtonWithTitle:@"Set"];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    else if (sender == self.uiAlertSecretTextFieldButton) {
        [alert addButtonWithTitle:@"Cancel"];
        [alert addButtonWithTitle:@"Change Password"];
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    }
    else if (sender == self.uiLoginTextFieldButton) {
        [alert addButtonWithTitle:@"Cancel"];
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
        NSInteger destructiveIndex = [alert addButtonWithTitle:@"Delete" action:^{
            NSLog(@"Delete");
        }];
        alert.destructiveButtonIndex = destructiveIndex;
        [alert addButtonWithTitle:@"Normal Button" action:^{
            NSLog(@"Normal Button");
        }];
        [alert addButtonWithTitle:@"Cancel" action:^{
            NSLog(@"Cancel");
        }];
    }
    else if (sender == self.mbAlertPlainTextFieldButton) {
        __weak MBAlertView *weakAlert = alert;
        [alert addButtonWithTitle:@"Clear" action:^{
            NSString *text = [weakAlert.textField0.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([text length] == 0) {
                NSLog(@"Clear text");
            }
            else {
                NSLog(@"Set %@", weakAlert.textField0.text);
            }
        } enable:^BOOL(UIButton *button) {
            NSString *text = [weakAlert.textField0.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([text length] == 0) {
                [button setTitle:@"Clear" forState:UIControlStateNormal];                
            }
            else {
                [button setTitle:@"Set" forState:UIControlStateNormal];
            }
            return YES;
        }];
        [alert addButtonWithTitle:@"Cancel" action:^{
            NSLog(@"Cancel");
        }];
        alert.alertStyle = MBAlertViewStylePlainTextInput;
    }
    else if (sender == self.mbAlertSecretTextFieldButton) {
        __weak MBAlertView *weakAlert = alert;
        [alert addButtonWithTitle:@"Change Password" action:^{
            NSLog(@"Set %@", weakAlert.textField0.text);
        } enable:^BOOL(UIButton *button) {
            NSString *password = [weakAlert.textField0.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([password length] == 0) {
                return NO;
            }
            return YES;
        }];
        [alert addButtonWithTitle:@"Cancel" action:^{
            NSLog(@"Cancel");
        }];
        alert.alertStyle = MBAlertViewStyleSecureTextInput;
    }
    else if (sender == self.mbLoginTextFieldButton) {
        __weak MBAlertView *weakAlert = alert;
        [alert addButtonWithTitle:@"Set" action:^{
            NSLog(@"Set \"%@\" - \"%@\"", weakAlert.textField0.text, weakAlert.textField1.text);
        } enable:^BOOL(UIButton *button) {
            NSString *username = [weakAlert.textField0.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *password = [weakAlert.textField1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([username length] == 0 || [password length] == 0) {
                return NO;
            }
            return YES;
        }];
        [alert addButtonWithTitle:@"Cancel" action:^{
            NSLog(@"Cancel");
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
