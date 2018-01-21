//
//  AuthService.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/23/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "AuthService.h"
#import <CWGNALET-Swift.h>

@implementation AuthService

+(id)auth

{
    static AuthService *auth = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        auth = [[self alloc] init];
    });
    return auth;
}

-(void)logIn:(NSString*)email password:(NSString*)password view:(UIViewController* _Nullable)controller onComplete:(ExecuteAfterFinish _Nullable)onComplete stop:(Execute)animationBlock
{
    [[FIRAuth auth]signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error != nil){
            animationBlock();
            [controller presentViewController:[self fireBaseErrorHandling:error] animated:YES completion:nil];
            //NSLog(@"An Error occurred with signature: %@", error.debugDescription);
            
        }else{

            [[NSUserDefaults standardUserDefaults]setObject:user.uid forKey:CS.C.USER_UID__];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:CS.C.DID_LOG_IN_];
            onComplete();
            
        }
    }];
}
-(void)signUp:(NSString* _Nonnull)email password:(NSString* _Nonnull)passsword username:(NSString*)name onComplete:(ExecuteAfterFinish _Nullable)onComplete view:(UIViewController* _Nullable)controller stop:(Execute)animationBlock
{
    [[FIRAuth auth] createUserWithEmail:email password:passsword completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error != nil){
            //handle error
            animationBlock();
            [controller presentViewController:[self fireBaseErrorHandling:error ] animated:YES completion:nil];
            //NSLog(@"Error occured with Signature: %@", error);
            
        }else{
            if (user.uid != nil){

                [[NSUserDefaults standardUserDefaults] setObject:user.uid forKey:CS.C.USER_UID__];
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:CS.C.DID_LOG_IN_];
                [[DBService service] saveUser:user.uid username:name imgLnk:@""];
                onComplete();
                
                //optional sign in
            }
        }//
    }];
}


-(void)fb_signOut:(Execute)onComplete
{
    [[FIRAuth auth] signOut:nil];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:CS.C.USER_UID__];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:CS.C.DID_LOG_IN_];
    onComplete();
}


/*-(void)fb_Auth_Password_Reset:(NSString *)email c:(UIViewController*)controller e:(Execute)onComplete
{
    [[FIRAuth auth] sendPasswordResetWithEmail:email completion:^(NSError * _Nullable error) {
        if (error){
            UIAlertController* alert = [Constants createDefaultAlert:@"Error" title:@"Please enter the email used to create the account" message:@"Dismiss"];
            [controller presentViewController:alert animated:YES completion:^{}];
        }else{
            UIAlertController* alert = [Constants createDefaultAlert:@"Password Reset" title:@"Please check your mail for password reset link." message:@"Dismiss"];
            [controller presentViewController:alert animated:YES completion:^{}];
            onComplete();
        }
    }];
}

-(void)fb_Auth_DeleteUserAccount:(NSString*)email p:(NSString*)password c:(UIViewController*)controller e:(Execute)onComplete
{
    FIRUser* user = [FIRAuth auth].currentUser;
    FIRAuthCredential* credentials = [FIREmailPasswordAuthProvider credentialWithEmail:email password:password];
    [user reauthenticateWithCredential:credentials completion:^(NSError * _Nullable error) {
        if (error){
            UIAlertController* alert = [Constants createDefaultAlert:@"Authentication Error" title:@"There was an error authenticating credentials, please enter correct email/password or check your internet connection" message:@"Dismiss"];
            [controller presentViewController:alert animated:YES completion:^{}];
        }else{
            [[DatabaseService main] deleteUserAccount:user.uid];
            [user deleteWithCompletion:^(NSError * _Nullable error) {
                if (error){
                    UIAlertController* alert = [Constants createDefaultAlert:@"Error" title:@"Unable to delete user account. Please check internet connection" message:@"Dismiss"];
                    [controller presentViewController:alert animated:YES completion:^{}];
                }else{
                    
                    onComplete();
                }
            }];
        }
    }];
}

-(void)fb_Auth_Change_Email:(NSString *)email p:(NSString *)password new:(NSString*)newEmail c:(UIViewController*)controller e:(Execute)onComplete
{
    FIRUser* user = [FIRAuth auth].currentUser;
    FIRAuthCredential* credentials = [FIREmailPasswordAuthProvider credentialWithEmail:email password:password];
    [user reauthenticateWithCredential:credentials completion:^(NSError * _Nullable error) {
        if(error){
            UIAlertController* alert = [Constants createDefaultAlert:@"Authentication Error" title:@"There was an error authenticating credentials, please enter correct email/password or check your internet connection" message:@"Dismiss"];
            [controller presentViewController:alert animated:YES completion:^{}];
        }else{
            [user updateEmail:newEmail completion:^(NSError * _Nullable updateerror) {
                if(updateerror){
                    UIAlertController* alert = [Constants createDefaultAlert:@"Error" title:@"Unable to update Email. Email is already registered to an account or unavailable. Please check internet connection" message:@"Dismiss"];
                    [controller presentViewController:alert animated:YES completion:^{}];
                }else{
                    [self fb_signOut:^{}];
                    onComplete();
                }
            }];
        }
    }];
}*/

-(UIAlertController*)fireBaseErrorHandling:(NSError*)error
{

    switch (error.code) {
        case FIRAuthErrorCodeInvalidEmail:

            return [CS createDefaultAlertWithTitle:@"Invalid Email" message:@"Please enter a valid email address" actionTitle:@"OK"];
            break;
        case FIRAuthErrorCodeEmailAlreadyInUse:
            return [CS createDefaultAlertWithTitle:@"Email Already In Use" message:@"Please enter another valid email address" actionTitle:@"OK"];
            break;
        case FIRAuthErrorCodeNetworkError:
            return [CS createDefaultAlertWithTitle:@"Network Error" message:@"Network error interrupted authentication" actionTitle:@"OK" ];
            break;
        case FIRAuthErrorCodeWrongPassword:
            return [CS createDefaultAlertWithTitle:@"Wrong Password" message:@"Please enter the correct pasword" actionTitle:@"OK" ];
            break;
        case FIRAuthErrorCodeUserNotFound:
            return [CS createDefaultAlertWithTitle:@"User Not Found" message:@"This account could not be found" actionTitle:@"OK"];
            break;
        default:
            return [CS createDefaultAlertWithTitle:@"Problem Signing In" message:@"A problem was encontered whiles signing in" actionTitle:@"OK"];
            break;
    }
}
@end

