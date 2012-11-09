//
//  IAP.h
// Created by Applicasa 
// 10/09/2012
//

#import <Foundation/Foundation.h>
#import <LiCore/LiObject.h>
#import <LiKitIAP/LiKitIAPDelegate.h>
#import "LiBlockQuery.h"

@class VirtualGood;
@class VirtualCurrency;

@interface IAP : NSObject

// Buy

+ (void) buyVirtualCurrency:(VirtualCurrency *)virtualCurrency WithBlock:(LiBlockAction)block;
+ (void) buyVirtualGood:(VirtualGood *)virtualGood Quantity:(NSInteger)quantity CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block;

// Give

+ (void) giveVirtualCurrency:(NSInteger)amount CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block;
+ (void) giveVirtualGood:(VirtualGood *)virtualGood Quantity:(NSInteger)quantity WithBlock:(LiBlockAction)block;

// Use

+ (void) useVirtualCurrency:(NSInteger)amount CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block;
+ (void) useVirtualGood:(VirtualGood *)virtualGood Quantity:(NSInteger)quantity WithBlock:(LiBlockAction)block;

//Get - All From LiKitIAP's private shared instance

+ (void) getAllVirtualCurrenciesWithBlock:(GetVirtualCurrencyArrayFinished)block;
+ (void) getAllVirtualGoodWithType:(VirutalGoodGetTypes)type WithBlock:(GetVirtualCurrencyArrayFinished)block;
+ (void) getAllVirtualGoodCategoriesWithBlock:(GetVirtualGoodCategoryArrayFinished)block;

+ (void) getAllVirtualGoodWithType:(VirutalGoodGetTypes)type ByCategory:(VirtualGoodCategory *)category WithBlock:(GetVirtualCurrencyArrayFinished)block;

+ (NSInteger) getCurrentUserMainBalance;
+ (NSInteger) getCurrentUserSecondaryBalance;

@end
