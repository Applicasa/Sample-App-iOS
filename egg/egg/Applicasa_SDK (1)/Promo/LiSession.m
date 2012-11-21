//
//  LiSession.m
//  testForLior
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import "LiSession.h"
#import <LiKitPromotions/LiKitPromotions.h>

@implementation LiSession

+ (void) sessionStart{
    [LiKitPromotions initSession];
}

+ (void) sessionPause{
    [LiKitPromotions pauseSession];
}

+ (void) sessionResume{
    [LiKitPromotions resumeSession];
}

+ (void) sessionEnd{
    [LiKitPromotions endSession];
}

#pragma mark - Game Methods

+ (void) gameStart:(NSString *)gameName{
    [LiKitPromotions startGame:gameName];
}

+ (void) gamePause{
    [LiKitPromotions pauseGame];
}

+ (void) gameResume{
    [LiKitPromotions resumeGame];
}

+ (void) gameFinishWithGameResult:(LiGameResult)gameResult MainCurrency:(NSInteger)mainCurrency SecondaryCurrency:(NSInteger)secondaryCurrency Score:(NSInteger)score Bonus:(NSInteger)bonus{
    [LiKitPromotions finishGameWithGameResult:gameResult MainCurrency:mainCurrency SecondaryCurrency:secondaryCurrency Score:score Bonus:bonus];
}

@end
