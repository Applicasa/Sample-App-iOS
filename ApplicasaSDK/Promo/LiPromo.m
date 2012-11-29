//
//  LiPromo.m
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import "LiPromo.h"

@implementation LiPromo


+ (void) setLiKitPromotionsDelegate:(id <LiKitPromotionsDelegate>)delegate{
    [LiKitPromotions setLiKitPromotionsDelegate:delegate];
}

+ (void) getAllAvailblePromosWithBlock:(GetPromotionArrayFinished)block{
    [LiKitPromotions getAllAvailblePromosWithBlock:block];
}

+ (void) refreshPromotions{
    [LiKitPromotions refreshPromotions];
}

@end
