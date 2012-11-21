//
//  LiSession.h
//  testForLior
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LiGameResultLoose = 0,
    LiGameResultWin
} LiGameResult;

@interface LiSession : NSObject
/*
 A method to start the session.
 Calling twice will override the first session
 best to implement in:
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 
 ex.
 [LiSession sessionStart];
 */
+ (void) sessionStart;

/*
 A method to pause the session
 best to implement in:
 - (void)applicationDidEnterBackground:(UIApplication *)application
 
 ex.
 [LiSession sessionPause];
 */
+ (void) sessionPause;

/*
 A method to resume the last session
 If the break was longer than 15 seconds
 Then LiKitPromotions will perform EndSession instead.
 
 best to implement in:
 - (void)applicationWillEnterForeground:(UIApplication *)application
 or in:
 - (void)applicationDidBecomeActive:(UIApplication *)application
 
 ex.
 [LiSession sessionResume];
 */
+ (void) sessionResume;

/*
 A method to finish the session (Under normal circumstances this function will not be called but there are some cases where the OS will terminate the app.)
 best to implement in:
 
 - (void)applicationWillTerminate:(UIApplication *)application
 or in:
 - (void)applicationWillResignActive:(UIApplication *)application
 
 ex.
 [LiSession sessionEnd];
 */
+ (void) sessionEnd;

#pragma mark - Game Methods

/*
 A method to start a game.
 Only one game can be managed at any given time.
 If you start a game twice the first will be finished with all parameters 0
 
 ex.
 [LiSession gameStart:@"level1"];
 */
+ (void) gameStart:(NSString *)gameName;

/*
 A method to pause the current game
 
 ex.
 [LiSession gamePause];
 */
+ (void) gamePause;

/*
 A method to resume the current game
 
 ex.
 [LiSession gameResume];
 */
+ (void) gameResume;

/*
 A method to finish the current game
 
 ex.
 [LiSession gameFinishWithGameResult:LiGameResultWin MainCurrency:10 SecondaryCurrency:1 Score:50 Bonus:5];
 */
+ (void) gameFinishWithGameResult:(LiGameResult)gameResult MainCurrency:(NSInteger)mainCurrency SecondaryCurrency:(NSInteger)secondaryCurrency Score:(NSInteger)score Bonus:(NSInteger)bonus;

@end
