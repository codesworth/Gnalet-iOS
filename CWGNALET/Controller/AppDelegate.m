//
//  AppDelegate.m
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/22/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "AppDelegate.h"
#import "AuthVC.h"
@import Firebase;


@interface AppDelegate()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FIRApp configure];
    [GMSServices provideAPIKey:@"AIzaSyCJvBRpT48C6sMWaaepPTIRWNVBoOLCTw8"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyCJvBRpT48C6sMWaaepPTIRWNVBoOLCTw8"];
    
    //[GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    //[GIDSignIn sharedInstance].delegate = self;
    //[_window setRootViewController:[self rootViewController]];
    // Override point for customization after application launch.
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];

}

-(UIViewController*)rootViewController
{
    NSString* storyboardName = @"Main";
    UIStoryboard* s = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:CS.C.DID_LOG_IN_]) {
        return [s instantiateViewControllerWithIdentifier:@"Nav"];
    }
    return [s instantiateViewControllerWithIdentifier:NSStringFromClass([AuthVC class])];
}



- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    if (error) {}
    else{
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken accessToken:authentication.accessToken];
        [[FIRAuth auth]signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            if(error){}
            else{
                [[DBService service]saveUser:user.uid username:user.displayName imgLnk:user.photoURL.absoluteString];
                [[NSUserDefaults standardUserDefaults]setObject:user.uid forKey:CS.C.USER_UID__];
                [[NSUserDefaults standardUserDefaults]setBool:true forKey:CS.C.DID_LOG_IN_];
                [_window.rootViewController performSegueWithIdentifier:@"LoggedIn" sender:nil];
            }
        }];
    }
}

@end
