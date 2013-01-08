//
//  IAP.m
// Created by Applicasa 
// 10/09/2012
//


#import "IAP.h"
#import "VirtualGood.h"
#import "VirtualCurrency.h"

@implementation IAP

/**********************
 Buy Currency & Goods
 **********************/

+ (void) buyVirtualCurrency:(VirtualCurrency *)virtualCurrency withBlock:(LiBlockAction)block{
    [virtualCurrency buyVirtualCurrencyWithBlock:block];
}

+ (void) buyVirtualGood:(VirtualGood *)virtualGood quantity:(NSInteger)quantity withCurrencyKind:(LiCurrency)currencyKind andBlock:(LiBlockAction)block{
    [virtualGood buyQuantity:quantity withCurrencyKind:currencyKind andBlock:block];
}

/**********************
 Give Currency & Goods
 **********************/

+ (void) giveAmount:(NSInteger)amount ofCurrencyKind:(LiCurrency)currencyKind withBlock:(LiBlockAction)block{
    [VirtualCurrency giveAmount:amount ofCurrencyKind:currencyKind withBlock:block];
}

+ (void) giveVirtualGood:(VirtualGood *)virtualGood quantity:(NSInteger)quantity withBlock:(LiBlockAction)block{
    [virtualGood giveQuantity:quantity withBlock:block];
}

/**********************
 Use Currency & Goods
 **********************/

+ (void) useAmount:(NSInteger)amount ofCurrencyKind:(LiCurrency)currencyKind withBlock:(LiBlockAction)block{
    [VirtualCurrency useAmount:amount OfCurrencyKind:currencyKind withBlock:block];
}

+ (void) useVirtualGood:(VirtualGood *)virtualGood quantity:(NSInteger)quantity withBlock:(LiBlockAction)block{
    [virtualGood useQuantity:quantity withBlock:block];
}

/**********************
 Query Methods
 **********************/

+ (void) getVirtualCurrenciesWithBlock:(GetVirtualCurrencyArrayFinished)block{
    [VirtualCurrency getVirtualCurrenciesWithBlock:block];
}

+ (void) getVirtualGoodsOfType:(VirtualGoodType)type withBlock:(GetVirtualCurrencyArrayFinished)block{
    [VirtualGood getVirtualGoodsOfType:type withBlock:block];
}

+ (void) getVirtualGoodCategoriesWithBlock:(GetVirtualGoodCategoryArrayFinished)block{
    block(nil,[LiKitIAP virtualGoodCategories]);
}

+ (void) getVirtualGoodsOfType:(VirtualGoodType)type andCategory:(VirtualGoodCategory *)category withBlock:(GetVirtualCurrencyArrayFinished)block{
    [VirtualGood getVirtualGoodsOfType:type andCategory:category withBlock:block];
}

/**********************
 Balance Methods
 **********************/

+ (NSInteger) getCurrentUserMainBalance{
    return [LiKitIAP getCurrentUserMainBalance];
}

+ (NSInteger) getCurrentUserSecondaryBalance{
    return [LiKitIAP getCurrentUserSecondaryBalance];
}


#pragma mark - Deprecated Methods
/*********************************************************************************
 DEPRECATED METHODS:
 
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the next release. You should update your code immediately.
 **********************************************************************************/

+ (void) buyVirtualCurrency:(VirtualCurrency *)virtualCurrency WithBlock:(LiBlockAction)block {
    [self buyVirtualCurrency:virtualCurrency withBlock:block];
}

+ (void) buyVirtualGood:(VirtualGood *)virtualGood Quantity:(NSInteger)quantity CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block {
    [self buyVirtualGood:virtualGood quantity:quantity withCurrencyKind:currencyKind andBlock:block];
}

+ (void) giveVirtualCurrency:(NSInteger)amount CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block {
    [self giveAmount:amount ofCurrencyKind:currencyKind withBlock:block];
}

+ (void) giveVirtualGood:(VirtualGood *)virtualGood Quantity:(NSInteger)quantity WithBlock:(LiBlockAction)block {
    [self giveVirtualGood:virtualGood quantity:quantity withBlock:block];
}

+ (void) useVirtualCurrency:(NSInteger)amount CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block {
    [self useAmount:amount ofCurrencyKind:currencyKind withBlock:block];
}

+ (void) useVirtualGood:(VirtualGood *)virtualGood Quantity:(NSInteger)quantity WithBlock:(LiBlockAction)block {
    [self useVirtualGood:virtualGood quantity:quantity withBlock:block];
}

+ (void) getAllVirtualCurrenciesWithBlock:(GetVirtualCurrencyArrayFinished)block {
    [self getVirtualCurrenciesWithBlock:block];
}

+ (void) getAllVirtualGoodWithType:(VirtualGoodType)type WithBlock:(GetVirtualCurrencyArrayFinished)block {
    [self getVirtualGoodsOfType:type withBlock:block];
}

+ (void) getAllVirtualGoodCategoriesWithBlock:(GetVirtualGoodCategoryArrayFinished)block {
    [self getVirtualGoodCategoriesWithBlock:block];
}

+ (void) getAllVirtualGoodWithType:(VirtualGoodType)type ByCategory:(VirtualGoodCategory *)category WithBlock:(GetVirtualCurrencyArrayFinished)block {
    [self getVirtualGoodsOfType:type andCategory:category withBlock:block];
}

@end
