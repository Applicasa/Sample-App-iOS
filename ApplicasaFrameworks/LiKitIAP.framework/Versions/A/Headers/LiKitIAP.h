//
//  LiKitIAP.h
//  Applicasa
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa All rights reserved.
//  

#import <UIKit/UIKit.h>

#import <LiKitIAP/SKProduct+LiPriceAsString.h>
#import <LiKitIAP/LiKitIAPDelegate.h>
#import <LiCore/LiResponse.h>

@class VirtualCurrency;
@class VirtualGood;

@interface LiKitIAP : NSObject

+ (BOOL) liKitIAPLoaded;

+ (NSDictionary *) getIAPActionFieldsDictionary;
+ (NSDictionary *) getIAPFKsDictionary;

+ (BOOL) validateObjectDictionary:(NSDictionary *)dictionary FromTable:(NSString *)tableName Header:(NSString *)header;
+ (void) validateVirtualCurrencys:(NSArray *)items WithDelegate:(id <LiKitIAPDelegate>)delegate;

+ (NSArray *) virtualCurrencies;
+ (NSArray *) virtualGoods;
+ (NSArray *) virtualGoodCategories;

+ (NSArray *) virtualGoodDeals;
+ (NSArray *) virtualCurrencyDeals;

+ (void) refreshInventories;
+ (void) refreshStore;

//AppStore Methods

//AppStore Purchase method
+ (void) purchaseVirtualCurrency:(VirtualCurrency *)VirtualCurrency Delegate:(id <LiKitIAPDelegate>)delegate;
//Give App credits for free
+ (BOOL) giveAmount:(NSInteger)amount CurrencyKind:(LiCurrency)currencyKind WithError:(NSError **)error;
//Use the App credits
+ (BOOL) useAmount:(NSInteger)amount CurrencyKind:(LiCurrency)currencyKind WithError:(NSError **)error;
//Get the current balance
+ (NSInteger) getCurrentUserMainBalance;
+ (NSInteger) getCurrentUserSecondaryBalance;


+ (BOOL) purchaseVirtualGood:(VirtualGood *)product Quantity:(NSInteger)quantity CurrencyKind:(LiCurrency)currencyKind WithError:(NSError **)error;
+ (BOOL) giveVirtualGood:(VirtualGood *)product Quantity:(NSInteger)quantity WithError:(NSError **)error;
+ (BOOL) useVirtualGood:(VirtualGood *)product Quantity:(NSInteger)quantity WithError:(NSError **)error;

@end
