//
// Promotion.h
// Created by Applicasa 
// 11/1/2012
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>
#import "LiBlockQuery.h"
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



#define kPromotionNotificationString @"PromotionConflictFound"
#define kShouldPromotionWorkOffline TRUE
@interface Promotion : LiObject <LiCoreRequestDelegate> {
}

@property (nonatomic, retain) NSString *promotionID;
@property (nonatomic, retain, readonly) NSDate *promotionLastUpdate;
@property (nonatomic, retain) NSString *promotionName;
@property (nonatomic, assign) LiEventTypes promotionAppEvent;
@property (nonatomic, assign) int promotionMaxPerUser;
@property (nonatomic, assign) int promotionMaxPerDay;
@property (nonatomic, assign) int promotionPriority;
@property (nonatomic, assign) BOOL promotionShowImmediately;
@property (nonatomic, assign) BOOL promotionShowOnce;
@property (nonatomic, assign) int promotionGender;
@property (nonatomic, retain) NSString *promotionSpendProfile;
@property (nonatomic, retain) NSString *promotionUseProfile;
@property (nonatomic, retain) NSString *promotionCountry;
@property (nonatomic, retain) NSString *promotionAge;
@property (nonatomic, retain) NSDate *promotionStartTime;
@property (nonatomic, retain) NSDate *promotionEndTime;
@property (nonatomic, retain) NSString *promotionFilterParameters;
@property (nonatomic, retain) NSString *promotionType;
@property (nonatomic, assign) LiPromotionActionKind promotionActionKind;
@property (nonatomic, retain) NSString *promotionActionData;
@property (nonatomic, retain) NSURL *promotionImage;
@property (nonatomic, retain) NSURL *promotionButton;
@property (nonatomic, assign) int promotionEligible;
@property (nonatomic, assign) int promotionViews;
@property (nonatomic, assign) int promotionUsed;
@property (nonatomic, retain) NSString *promotionImageBase;
@property (nonatomic, retain) NSString *promotionDefaultPhone;
@property (nonatomic, retain) NSString *promotionDefaultTablet;
@property (nonatomic, retain) NSString *promotionImageOptions;
@property (nonatomic, assign) BOOL promotionWaitingToBeViewed;
@property (nonatomic, retain) NSString *promotionIdentifier;


// ****
// Get Promotion Array from Local DB
//
+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetPromotionArrayFinished)block;

- (void) showOnView:(UIView *)view;
- (void) show;

#pragma mark - End of Basic SDK

@end
