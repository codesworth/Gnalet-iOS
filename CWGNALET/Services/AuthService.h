//
//  AuthService.h
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/23/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Predefs.h"
#import "TypeDefs.h"

@import Firebase;
@import FirebaseAuth;



@interface AuthService : NSObject

+(_Nonnull id)auth;

-(void)logIn:( NSString* _Nonnull )email password:(NSString* _Nonnull)password view:(UIViewController* _Nullable)controller onComplete:(ExecuteAfterFinish _Nullable)onComplete  stop:(nullable Execute)animationBlock ;

-(void)signUp:(NSString* _Nonnull)email password:(NSString* _Nonnull)passsword username:(NSString*_Nonnull)name onComplete:(ExecuteAfterFinish _Nullable)onComplete view:(UIViewController* _Nullable)controller  stop:(nullable Execute)animationBlock;

-(void)fb_signOut:(nullable Execute)onComplete;
-(void)signInAnonymously:(ExecuteAfterFinish _Nullable )onComplete errorCompletion:(Execute _Nullable )completion;

//-(void)fb_Auth_Password_Reset:(NSString* _Nonnull)email c:(UIViewController* _Nonnull)controller e:(nullable Execute)onComplete;

//-(void)fb_Auth_Change_Email:(NSString* _Nonnull)email p:(NSString* _Nonnull)password new:(NSString* _Nonnull)newEmail c:(UIViewController* _Nonnull)controller e:(Execute _Nullable)onComplete;

//-(void)fb_Auth_DeleteUserAccount:(NSString* _Nonnull)email p:(NSString* _Nonnull)password c:(UIViewController* _Nonnull)controller e:(nullable Execute)onComplete;


@end
