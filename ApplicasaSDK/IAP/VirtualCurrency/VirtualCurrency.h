//
// VirtualCurrency.h
// Created by Applicasa 
// 11/25/2012
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>
#import "LiBlockQuery.h"
#import <LiKitIAP/LiKitIAP.h>



//*************
//
// VirtualCurrency Class
//
//

@class SKProduct;

#define kVirtualCurrencyNotificationString @"VirtualCurrencyConflictFound"
#define kShouldVirtualCurrencyWorkOffline TRUE
@interface VirtualCurrency : LiObject <LiCoreRequestDelegate,LiKitIAPDelegate> {
}

@property (nonatomic, retain) NSString *virtualCurrencyID;
@property (nonatomic, retain) NSString *virtualCurrencyTitle;
@property (nonatomic, retain) NSString *virtualCurrencyAppleIdentifier;
@property (nonatomic, retain) NSString *virtualCurrencyGoogleIdentifier;
@property (nonatomic, retain) NSString *virtualCurrencyDescription;
@property (nonatomic, assign) float virtualCurrencyPrice;
@property (nonatomic, assign) int virtualCurrencyCredit;
@property (nonatomic, assign) LiCurrency virtualCurrencyKind;
@property (nonatomic, retain) NSURL *virtualCurrencyImageA;
@property (nonatomic, retain) NSURL *virtualCurrencyImageB;
@property (nonatomic, retain) NSURL *virtualCurrencyImageC;
@property (nonatomic, assign) BOOL virtualCurrencyIsDeal;
@property (nonatomic, assign) BOOL virtualCurrencyInAppleStore;
@property (nonatomic, assign) BOOL virtualCurrencyInGoogleStore;
@property (nonatomic, retain, readonly) NSDate *virtualCurrencyLastUpdate;
@property (nonatomic, retain) SKProduct *product;
@property (nonatomic, retain) NSDecimalNumber *itunesPrice;

#pragma mark - End of Basic SDK

+ (void) getAllVirtualCurrencyWithBlock:(GetVirtualCurrencyArrayFinished)block;

- (void) buyVirtualCurrencyWithBlock:(LiBlockAction)block;
+ (void) giveVirtualCurrency:(NSInteger)amount CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block;
+ (void) useVirtualCurrency:(NSInteger)amount CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block;


@end
