//
//  AuthVC.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/22/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "AuthVC.h"


@interface AuthVC ()<GIDSignInUIDelegate>
@property (weak, nonatomic) IBOutlet GIDSignInButton *GDsignInButton;


@end

@implementation AuthVC


-(void)viewDidLoad
{
    [super viewDidLoad];
    [GIDSignIn sharedInstance].uiDelegate = self;
    
}



- (IBAction)gidPressed:(id)sender {
    
}


- (IBAction)gmailSignIn:(id)sender {
}

- (IBAction)signInButtonPressed:(id)sender {
    
    if (![_usernametextfield.text isEqualToString:@""] && ![_passwordTXF.text isEqualToString:@""] && [_emailTXF.text containsString:@"@"] && _passwordTXF.text.length > 5 ){
        [[AuthService auth]signUp:_emailTXF.text password:_passwordTXF.text username:self.usernametextfield.text onComplete:^{
            [self performSegueWithIdentifier:@"LoggedIn" sender:nil];
        } view:self stop:^{
            //
        }];
    }
}


@end
