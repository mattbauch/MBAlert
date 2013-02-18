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

@property (weak, nonatomic) IBOutlet UIButton *mbAlertNoButton;
@property (weak, nonatomic) IBOutlet UIButton *mbAlert1Button;
@property (weak, nonatomic) IBOutlet UIButton *mbAlert2Button;
@property (weak, nonatomic) IBOutlet UIButton *mbAlert3Button;

- (IBAction)uiButtonPressed:(UIButton *)sender;
- (IBAction)mbButtonPressed:(UIButton *)sender;


@end
