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

- (void)finishedIntializedLiKitIAPWithVirtualCurrencies:(NSArray *)virtualCurrencies VirtualGoods:(NSArray *)virtualGoods {
#ifdef DEBUG
    DDLogInfo(@"############  FROM DELEGATE METHOD ##############");
    DDLogVerbose(@"#### VirtualCurrency count: %d ####", virtualCurrencies.count);
    for (VirtualCurrency *currentItem in virtualCurrencies) {
        // log out virtual currency
        DDLogVerbose(@"VirtualCurrency item: %@, %f@, %d", currentItem.virtualCurrencyTitle, currentItem.virtualCurrencyPrice, currentItem.virtualCurrencyCredit);
    }
    
    
    DDLogInfo(@"#### VirtualGoods count: %d ####", virtualGoods.count);
    for (VirtualGood *currentItem in virtualGoods) {
        // log out virtual goods
        DDLogVerbose(@"VirtualCurrency item: %@, %@, %d", currentItem.virtualGoodTitle, currentItem.virtualGoodDescription, currentItem.virtualGoodQuantity);
    }
    DDLogInfo(@"#############   END DELEGATE METHOD #############");
#endif
}

#pragma mark LiKitPromotions delegate methods
- (void)liKitPromotionsHasPromos {
    DDLogInfo(@"!!! We have promotions !!!");
    [LiKitPromotions getAllAvailblePromosWithBlock:^(NSError *error, NSArray *array) {
        if ([array count] > 0) {
            [(Promotion *)[array objectAtIndex:0] show];
        }
    }];
}

@end
