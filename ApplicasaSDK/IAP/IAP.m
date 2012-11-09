//
//  IAP.m
// Created by Applicasa 
// 10/09/2012
//


#import "IAP.h"
#import "VirtualGood.h"
#import "VirtualCurrency.h"

@implementation IAP

// Buy

+ (void) buyVirtualCurrency:(VirtualCurrency *)virtualCurrency WithBlock:(LiBlockAction)block{
    [virtualCurrency buyVirtualCurrencyWithBlock:block];
}

+ (void) buyVirtualGood:(VirtualGood *)virtualGood Quantity:(NSInteger)quantity CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block{
    [virtualGood buyVirtualGoodWithQuantity:quantity CurrencyKind:currencyKind WithBlock:block];
}

// Give

+ (void) giveVirtualCurrency:(NSInteger)amount CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block{
    [VirtualCurrency giveVirtualCurrency:amount CurrencyKind:currencyKind WithBlock:block];
}

+ (void) giveVirtualGood:(VirtualGood *)virtualGood Quantity:(NSInteger)quantity WithBlock:(LiBlockAction)block{
    [virtualGood giveVirtualGoodWithQuantity:quantity WithBlock:block];
}

// Use

+ (void) useVirtualCurrency:(NSInteger)amount CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block{
    [VirtualCurrency useVirtualCurrency:amount CurrencyKind:currencyKind WithBlock:block];
}

+ (void) useVirtualGood:(VirtualGood *)virtualGood Quantity:(NSInteger)quantity WithBlock:(LiBlockAction)block{
    [virtualGood useWithQuantity:quantity WithBlock:block];
}

//Get - All From LiKitIAP's private shared instance

+ (void) getAllVirtualCurrenciesWithBlock:(GetVirtualCurrencyArrayFinished)block{
    [VirtualCurrency getAllVirtualCurrencyWithBlock:block];
}

+ (void) getAllVirtualGoodWithType:(VirutalGoodGetTypes)type WithBlock:(GetVirtualCurrencyArrayFinished)block{
    [VirtualGood getAllVirtualGoodByType:type WithBlock:block];
}

+ (void) getAllVirtualGoodCategoriesWithBlock:(GetVirtualGoodCategoryArrayFinished)block{
    block(nil,[LiKitIAP virtualGoodCategories]);
}

+ (void) getAllVirtualGoodWithType:(VirutalGoodGetTypes)type ByCategory:(VirtualGoodCategory *)category WithBlock:(GetVirtualCurrencyArrayFinished)block{
    [VirtualGood getAllVirtualGoodByType:type ByCategory:category WithBlock:block];
}

+ (NSInteger) getCurrentUserMainBalance{
    return [LiKitIAP getCurrentUserMainBalance];
}

+ (NSInteger) getCurrentUserSecondaryBalance{
    return [LiKitIAP getCurrentUserSecondaryBalance];
}

@end
