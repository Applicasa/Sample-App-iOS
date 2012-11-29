//
//  LiPromo.h
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LiKitPromotions/LiKitPromotions.h>

@interface LiPromo : NSObject

+ (void) setLiKitPromotionsDelegate:(id <LiKitPromotionsDelegate>)delegate;
+ (void) getAllAvailblePromosWithBlock:(GetPromotionArrayFinished)block;
+ (void) refreshPromotions;

@end
