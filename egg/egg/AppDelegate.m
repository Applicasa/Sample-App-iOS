//
//  AppDelegate.m
//  egg
//
//  Created by Bob Waycott on 10/29/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
#import "IAP.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"
#import "StoreViewController.h"
#import "User+Facebook.h"
#import "LiUserLocation.h"
#import <FacebookSDK/FBSession.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // setup Lumberjack logging
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:0.58 green:0.77 blue:0.49 alpha:1.0] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:1.00 green:0.85 blue:0.40 alpha:1.0] backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)finishedInitializeLiCoreFrameworkWithUser:(User*)user isFirstLoad:(BOOL)isFirst {
    // LiCoreInitialize
    DDLogInfo(@"We initialized Applicasa ... wahooo");
};


#pragma mark LiCore delegate methods
- (void)liCoreHasNewUser:(User *)user {
    DDLogVerbose(@"New User!!!");
}

- (void) refreshStoreViewController{
    UIViewController *currenctViewController = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentedViewController];
    if ([currenctViewController isKindOfClass:[StoreViewController class]])
        [currenctViewController viewDidLoad];
}

- (void)finishedIntializedLiKitIAPWithVirtualCurrencies:(NSArray *)virtualCurrencies VirtualGoods:(NSArray *)virtualGoods {
#ifdef DEBUG
    [self refreshStoreViewController];
    DDLogInfo(@"############  FROM DELEGATE METHOD ##############");
    DDLogInfo(@"#### VirtualCurrency count: %d ####", virtualCurrencies.count);
    for (VirtualCurrency *currentItem in virtualCurrencies) {
        // log out virtual currency
        DDLogVerbose(@"VirtualCurrency item: %@, %f@, %d", currentItem.virtualCurrencyTitle, currentItem.virtualCurrencyPrice, currentItem.virtualCurrencyCredit);
    }
    
    
    DDLogInfo(@"#### VirtualGoods count: %d ####", virtualGoods.count);
    for (VirtualGood *currentItem in virtualGoods) {
        // log out virtual goods
        DDLogVerbose(@"VirtualGood item: %@, %@, %d", currentItem.virtualGoodTitle, currentItem.virtualGoodDescription, currentItem.virtualGoodQuantity);
    }
    DDLogInfo(@"#############   END DELEGATE METHOD #############");
#endif
}

#pragma mark LiKitPromotions delegate methods
- (void)liKitPromotionsHasPromos {
    DDLogInfo(@"!!! We have promotions !!!");
    UIViewController *viewController = self.window.rootViewController.presentedViewController;
    if (!viewController)
        viewController = self.window.rootViewController;
    [LiKitPromotions getAllAvailblePromosWithBlock:^(NSError *error, NSArray *array) {
        if ([array count] > 0) {
            for (Promotion *promo in array) {
                [promo showOnView:viewController.view];
            }
        }
    }];
}

#pragma mark - Push Notification Delegate Methods
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [LiCore registerDeviceToken:deviceToken];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [LiCore failToRegisterDeviceToken];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
}

#pragma mark - Facebook Delegate Methods

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[LiKitFacebook getActiveSession] handleOpenURL:url];
}

@end
