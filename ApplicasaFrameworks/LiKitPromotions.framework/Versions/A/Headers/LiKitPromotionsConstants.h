//
//  LiKitPromotionsConstants.h
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

typedef enum {
    LEVEL_RESULT_WIN = 1,
    LEVEL_RESULT_LOSE,
    LEVEL_RESULT_EXIT
}LEVEL_RESULT;

typedef enum {
// App session events
    appStart,//0
    appStop,
    appPause,
    appResume,
    
// Game events
    gameStarted,//4
    gameOver,
    gameCompleted,
    
// User-based session events
    userFirstSession,//7
    userReturnSession,
    
// Promo events
    promoDisplayed,//9
    promoAccepted,
    promoDismissed,
    
// IAP
    
// VirtualCurrency-based events
    virtualCurrencyBought,//12
    virtualCurrencyGiven,
    virtualCurrencyUsed,
    virtualCurrencyFirstPurchase,
    
// VirtualGood-based events
    virtualGoodBought,//16
    virtualGoodGiven,
    virtualGoodUsed,
    virtualGoodFirstPurchase,
    
// Balance-based events
    balanceChanged,//20
    balanceZero,
    balanceLow,
    
// Inventory-based events
    inventoryDepleted, // all inventory at zero
    inventoryItemDepleted, // a specific item depleted from inventory
    
// Level events
    levelStart,
    levelQuit,
    levelRestart,
    levelPause,
    levelResume,
    levelComplete,
    levelFail,
    levelTooDifficult,
    levelTooEasy,
    
// Player events
    playerDied,
    playerDidAction,
    playerAchievement,
    
// Score events
    scoreHigh,
    scoreLow,
    scoreAchieved,
    
// Choice events
    choiceGood,
    choiceBad,
    choiceAggressive,
    choiceDefensive,
    choiceNeutral,
    
// Versus events
    versusStart,
    versusEnd,
    versusQuit,
    versusWin,
    versusLoss,
    
// Level-up events
    levelUpCharacter,
    levelUpItem,
    
// Unlockable events
    unlockedCharacter,
    unlockedItem,
    unlockedLevel,
    unlockedSecret
    
} LiEventTypes;

typedef void (^GetPromotionArrayFinished)(NSError *error, NSArray *array);

typedef enum {
    UpdatePromotion = 1
} LiAnalyticsKind;

@protocol LiKitPromotionsDelegate <NSObject>

- (void) liKitPromotionsHasPromos;

@end
