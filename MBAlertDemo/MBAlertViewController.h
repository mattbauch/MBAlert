//
//  MBViewController.h
//  MBAlertDemo
//
//  Created by Matthias Bauch on 2/18/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBAlertViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *uiAlertNoButton;
@property (weak, nonatomic) IBOutlet UIButton *uiAlert1Button;
@property (weak, nonatomic) IBOutlet UIButton *uiAlert2Button;
@property (weak, nonatomic) IBOutlet UIButton *uiAlert3Button;
@property (weak, nonatomic) IBOutlet UIButton *uiAlertPlainTextFieldButton;
@property (weak, nonatomic) IBOutlet UIButton *uiAlertSecretTextFieldButton;
@property (weak, nonatomic) IBOutlet UIButton *uiLoginTextFieldButton;

@property (weak, nonatomic) IBOutlet UIButton *mbAlertNoButton;
@property (weak, nonatomic) IBOutlet UIButton *mbAlert1Button;
@property (weak, nonatomic) IBOutlet UIButton *mbAlert2Button;
@property (weak, nonatomic) IBOutlet UIButton *mbAlert3Button;
@property (weak, nonatomic) IBOutlet UIButton *mbAlertPlainTextFieldButton;
@property (weak, nonatomic) IBOutlet UIButton *mbAlertSecretTextFieldButton;
@property (weak, nonatomic) IBOutlet UIButton *mbLoginTextFieldButton;

- (IBAction)uiButtonPressed:(UIButton *)sender;
- (IBAction)mbButtonPressed:(UIButton *)sender;


@end
