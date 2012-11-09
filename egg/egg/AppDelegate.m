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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
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
    NSLog(@"We initialized Applicasa ... wahooo");
};

- (void)liCoreHasNewUser:(User *)user {
    NSLog(@"New User!!!");
}

- (void)finishedIntializedLiKitIAPWithVirtualCurrencies:(NSArray *)virtualCurrencies VirtualGoods:(NSArray *)virtualGoods {
    NSLog(@"############  FROM DELEGATE METHOD ##############");
    
    NSLog(@"#### VirtualCurrency count: %d ####", virtualCurrencies.count);
    for (VirtualCurrency *currentItem in virtualCurrencies) {
        // log out virtual currency
        NSLog(@"VirtualCurrency item: %@, %f@, %d", currentItem.virtualCurrencyTitle, currentItem.virtualCurrencyPrice, currentItem.virtualCurrencyCredit);
    }
    
    
    NSLog(@"#### VirtualGoods count: %d ####", virtualGoods.count);
    for (VirtualGood *currentItem in virtualGoods) {
        // log out virtual goods
        NSLog(@"VirtualCurrency item: %@, %@, %d", currentItem.virtualGoodTitle, currentItem.virtualGoodDescription, currentItem.virtualGoodQuantity);
    }
    NSLog(@"#############   END DELEGATE METHOD #############");
}

@end
