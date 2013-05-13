//
//  AppDelegate.m
//  egg
//
//  Created by Applicasa on 10/29/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
#import "IAP.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"
#import "LiSession.h"
#import <FacebookSDK/FBSession.h>
#import "MainViewController.h"
#import "LiObjPushNotification.h"
#import "LiLog.m"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    return YES;
}

- (void) applicationDidEnterBackground:(UIApplication *)application{
    [LiSession sessionPause];
}

- (void) applicationWillEnterForeground:(UIApplication *)application{
//    [LiKitIAP refreshStore];
    [LiSession sessionResume];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [LiSession sessionEnd];
    // Logout users if they've logged in. Not doing anything else here cos we don't have special processing
    // needs in the sample app.
    BOOL userIsRegistered = [[User getCurrentUser] userIsRegistered];
    BOOL userIsRegisteredFacebook = [[User getCurrentUser] userIsRegisteredFacebook];
    if (userIsRegisteredFacebook){
        [User facebookLogoutWithBlock:^(NSError *error, NSString *itemID, Actions action) {
            LiLogSampleApp(@"Logged out Facebook user");
        }];
    } else if (userIsRegistered){
        [User logoutWithBlock:^(NSError *error, NSString *itemID, Actions action) {
            LiLogSampleApp(@"Logged Out User");
        }];
    }
    
}

#pragma mark -
#pragma mark AppDelegate helper methods
#pragma mark -

- (void) refreshViewControllers{
    // If user has store loaded before Applicasa IAP has finished loading,
    // ensures we refresh the store view with items when IAP is loaded.
    UIViewController *currentViewController = self.window.rootViewController;
    if ([currentViewController isKindOfClass:[MainViewController class]])
        [(MainViewController *)currentViewController dismissLoadingScreen];
}

#pragma mark -
#pragma mark LiCore delegate methods
#pragma mark -

- (void)finishedInitializeLiCoreFrameworkWithUser:(User*)user isFirstLoad:(BOOL)isFirst {
    // Lets us know that the Applicasa core framework has finished loading
    LiLogSampleApp(@"We initialized Applicasa ... wahooo");
    [LiKitFacebook setPermissions:[NSArray arrayWithObject:@"publish_stream"] AllowLoginUI:YES];
    
}

- (void)liCoreHasNewUser:(User *)user {
    // This delegate method can be implemented if you wish to know when a new user exists
    LiLogSampleApp(@"New User!!!");
}

#pragma mark -
#pragma mark LiKitIAP delegate methods
#pragma mark -

- (void)finishedIntializedLiKitIAPWithVirtualCurrencies:(NSArray *)virtualCurrencies VirtualGoods:(NSArray *)virtualGoods {
    
    LiLogSampleApp(@"############  FROM DELEGATE METHOD ##############");
    LiLogSampleApp(@"############  Refreshing controllers ##############");

    // Lets us know that IAP has loaded
    // Provides arrays of virtual goods & currencies that can be used immediately
    [self refreshViewControllers];
}


#pragma mark -
#pragma mark - Push Notification Delegate Methods
#pragma mark -

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [LiCore registerDeviceToken:deviceToken];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [LiCore failToRegisterDeviceToken];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    LiObjPushNotification *pushInstance = [LiObjPushNotification pushWithDictionary:userInfo];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Egg says" message:pushInstance.message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -
#pragma mark - Facebook Delegate Methods
#pragma mark -

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[LiKitFacebook getActiveSession] handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{

}

@end
