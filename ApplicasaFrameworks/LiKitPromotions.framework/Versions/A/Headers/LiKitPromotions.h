//
//  LiKitPromotions.h
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LiKitPromotions/Promotion.h>
#import <LiKitPromotions/LiKitPromotionsConstants.h>

@interface LiKitPromotions : NSObject

+ (NSDictionary *) getPromotionsFieldsDictionary;
+ (NSDictionary *) getProfileSettingsFieldsDictionary;
+ (NSDictionary *) getAnalyticsFieldsDictionary;

//Level
+ (void) startLevel:(NSString *)level;
+ (void) endLevel:(LEVEL_RESULT)result Socre:(NSInteger)score Bonus:(NSInteger)bonus;
+ (void) pauseLevel;
+ (void) resumeLevel;

//Session
+ (void) initSession;
+ (void) endSession;
+ (void) pauseSession;
+ (void) resumeSession;

+ (void) refreshProfileData;

+ (void) refreshPromotions;
+ (void) getAllAvailblePromosWithBlock:(GetPromotionArrayFinished)block;

+ (void) promoHadViewed:(Promotion *)promotion;
+ (void) promo:(Promotion *)promotion ButtonClicked:(BOOL)button CancelButton:(BOOL)cancelButton;

@end
