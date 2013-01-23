//
// Promotion.h
// Created by Applicasa
// 11/1/2012
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>
#import "LiDataTypes.h"
#import "LiKitPromotionsConstants.h"


#define KEY_promotionID				@"PromotionID"
#define KEY_promotionLastUpdate				@"PromotionLastUpdate"
#define KEY_promotionName				@"PromotionName"
#define KEY_promotionAppEvent				@"PromotionAppEvent"
#define KEY_promotionMaxPerUser				@"PromotionMaxPerUser"
#define KEY_promotionMaxPerDay				@"PromotionMaxPerDay"
#define KEY_promotionPriority				@"PromotionPriority"
#define KEY_promotionShowImmediately				@"PromotionShowImmediately"
#define KEY_promotionShowOnce				@"PromotionShowOnce"
#define KEY_promotionGender				@"PromotionGender"
#define KEY_promotionSpendProfile				@"PromotionSpendProfile"
#define KEY_promotionUseProfile				@"PromotionUseProfile"
#define KEY_promotionCountry				@"PromotionCountry"
#define KEY_promotionAge				@"PromotionAge"
#define KEY_promotionStartTime				@"PromotionStartTime"
#define KEY_promotionEndTime				@"PromotionEndTime"
#define KEY_promotionFilterParameters				@"PromotionFilterParameters"
#define KEY_promotionType				@"PromotionType"
#define KEY_promotionActionKind				@"PromotionActionKind"
#define KEY_promotionActionData				@"PromotionActionData"
#define KEY_promotionImage				@"PromotionImage"
#define KEY_promotionButton				@"PromotionButton"
#define KEY_promotionEligible				@"PromotionEligible"
#define KEY_promotionViews				@"PromotionViews"
#define KEY_promotionUsed				@"PromotionUsed"
#define KEY_promotionImageBase				@"PromotionImageBase"
#define KEY_promotionDefaultPhone				@"PromotionDefaultPhone"
#define KEY_promotionDefaultTablet				@"PromotionDefaultTablet"
#define KEY_promotionImageOptions				@"PromotionImageOptions"
#define KEY_promotionWaitingToBeViewed				@"PromotionWaitingToBeViewed"
#define KEY_promotionIdentifier				@"PromotionIdentifier"

//*************
//
// Promotion Class
//
//

typedef enum {
    LiPromotionTypeNothing = 1, //data = nil
    LiPromotionTypeLink, // data = url
    LiPromotionTypeString, // data = string
    LiPromotionTypeGiveVirtualCurrency, // data = amout + currencyKind
    LiPromotionTypeGiveVirtualGood, // data = VG id
    LiPromotionTypeOfferDealVC, // data = VC id & deal details
    LiPromotionTypeOfferDealVG, // data = VG id & deal details
} LiPromotionActionKind;

typedef void (^PromotionResultBlock)(LiPromotionAction promoAction,LiPromotionResult result,id info);

#define kPromotionNotificationString @"PromotionConflictFound"
#define kShouldPromotionWorkOffline TRUE
@interface Promotion : LiObject <LiCoreRequestDelegate> {
    PromotionResultBlock promoBlock;
}

@property (nonatomic, strong) NSString *promotionID;
@property (nonatomic, strong, readonly) NSDate *promotionLastUpdate;
@property (nonatomic, strong) NSString *promotionName;
@property (nonatomic, assign) LiEventTypes promotionAppEvent;
@property (nonatomic, assign) int promotionMaxPerUser;
@property (nonatomic, assign) int promotionMaxPerDay;
@property (nonatomic, assign) int promotionPriority;
@property (nonatomic, assign) BOOL promotionShowImmediately;
@property (nonatomic, assign) BOOL promotionShowOnce;
@property (nonatomic, assign) int promotionGender;
@property (nonatomic, strong) NSString *promotionSpendProfile;
@property (nonatomic, strong) NSString *promotionUseProfile;
@property (nonatomic, strong) NSString *promotionCountry;
@property (nonatomic, strong) NSString *promotionAge;
@property (nonatomic, strong) NSDate *promotionStartTime;
@property (nonatomic, strong) NSDate *promotionEndTime;
@property (nonatomic, strong) NSString *promotionFilterParameters;
@property (nonatomic, strong) NSString *promotionType;
@property (nonatomic, assign) LiPromotionActionKind promotionActionKind;
@property (nonatomic, strong) NSString *promotionActionData;
@property (nonatomic, strong) NSURL *promotionImage;
@property (nonatomic, strong) NSURL *promotionButton;
@property (nonatomic, assign) int promotionEligible;
@property (nonatomic, assign) int promotionViews;
@property (nonatomic, assign) int promotionUsed;
@property (nonatomic, strong) NSString *promotionImageBase;
@property (nonatomic, strong) NSString *promotionDefaultPhone;
@property (nonatomic, strong) NSString *promotionDefaultTablet;
@property (nonatomic, strong) NSString *promotionImageOptions;
@property (nonatomic, assign) BOOL promotionWaitingToBeViewed;
@property (nonatomic, strong) NSString *promotionIdentifier;


// ****
// Get Promotion Array from Local DB
//
+ (void) getArrayLocallyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetPromotionArrayFinished)block;

- (void) showOnView:(UIView *)view Block:(PromotionResultBlock)block;
- (void) showWithBlock:(PromotionResultBlock)block;

- (PromotionResultBlock) block;

#pragma mark - End of Basic SDK

@end
