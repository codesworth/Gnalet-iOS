//
//  AuthVC.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/22/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Predefs.h"
@import Firebase;
@import GoogleSignIn;


@interface AuthVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernametextfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTXF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTXF;

@end
