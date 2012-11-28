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
#import "StoreViewController.h"
#import "User+Facebook.h"
#import <FacebookSDK/FBSession.h>
#import "MainViewController.h"

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
							
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Logout users if they've logged in. Not doing anything else here cos we don't have special processing
    // needs in the sample app.
    [User logOutWithBlock:^(NSError *error, NSString *itemID, Actions action) {
        DDLogInfo(@"Logged Out User");
    }];
    
    [User facebookLogOutWithBlock:^(NSError *error, NSString *itemID, Actions action) {
        DDLogInfo(@"Logged out Facebook user");
    }];
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
    DDLogInfo(@"We initialized Applicasa ... wahooo");
};

- (void)liCoreHasNewUser:(User *)user {
    // This delegate method can be implemented if you wish to know when a new user exists
    DDLogVerbose(@"New User!!!");
}

#pragma mark -
#pragma mark LiKitIAP delegate methods
#pragma mark -

- (void)finishedIntializedLiKitIAPWithVirtualCurrencies:(NSArray *)virtualCurrencies VirtualGoods:(NSArray *)virtualGoods {
    // Lets us know that IAP has loaded
    // Provides arrays of virtual goods & currencies that can be used immediately
    [self refreshViewControllers];

#ifdef DEBUG
    // Just for DEBUG purposes, let's see our virtual currencies and items to make
    // sure we have a successful connnection to Applicasa.
    
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

#pragma mark -
#pragma mark LiKitPromotions delegate methods
#pragma mark -

- (void)liKitPromotionsHasPromos {
    // Lets us know that there are promotions that are available to show to the user
    // This simple implementation shows the promos that are returned
    DDLogInfo(@"!!! We have promotions !!!");
    UIViewController *viewController = self.window.rootViewController.presentedViewController;
    if (!viewController)
        viewController = self.window.rootViewController;
    [LiKitPromotions getAllAvailblePromosWithBlock:^(NSError *error, NSArray *array) {
        if ([array count] > 0) {
            for (Promotion *promo in array) {
                [promo showOnView:viewController.view Block:^(LiPromotionResult result) {
                    switch (result) {
                        case LiPromotionResultCancel:
                        {
                            //Do nothing
                        }
                            break;
                        case LiPromotionResultPress:
                        {
                            //Update balance label
                            if ([viewController isKindOfClass:[StoreViewController class]])
                                [(StoreViewController *)viewController updateBalanceLabel];
                        }
                            break;
                        default:
                            break;
                    }
                }];
            }
        }
    }];
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
    
}

#pragma mark -
#pragma mark - Facebook Delegate Methods
#pragma mark -

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[LiKitFacebook getActiveSession] handleOpenURL:url];
}

@end
