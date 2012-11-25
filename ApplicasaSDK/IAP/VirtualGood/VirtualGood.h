//
// VirtualGood.h
// Created by Applicasa 
// 11/25/2012
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>
#import "LiBlockQuery.h"
#import <LiKitIAP/LiKitIAP.h>



//*************
//
// VirtualGood Class
//
//

#define kVirtualGoodNotificationString @"VirtualGoodConflictFound"
#define kShouldVirtualGoodWorkOffline TRUE
@class VirtualGoodCategory;
@interface VirtualGood : LiObject <LiCoreRequestDelegate> {
}

@property (nonatomic, retain) NSString *virtualGoodID;
@property (nonatomic, retain) NSString *virtualGoodTitle;
@property (nonatomic, retain) NSString *virtualGoodDescription;
@property (nonatomic, assign) int virtualGoodMainCurrency;
@property (nonatomic, assign) int virtualGoodSecondaryCurrency;
@property (nonatomic, retain) NSString *virtualGoodRelatedVirtualGood;
@property (nonatomic, assign) int virtualGoodQuantity;
@property (nonatomic, assign) int virtualGoodMaxForUser;
@property (nonatomic, assign) int virtualGoodUserInventory;
@property (nonatomic, retain) NSURL *virtualGoodImageA;
@property (nonatomic, retain) NSURL *virtualGoodImageB;
@property (nonatomic, retain) NSURL *virtualGoodImageC;
@property (nonatomic, assign) BOOL virtualGoodIsDeal;
@property (nonatomic, assign) BOOL virtualGoodConsumable;
@property (nonatomic, retain, readonly) NSDate *virtualGoodLastUpdate;
@property (nonatomic, retain) VirtualGoodCategory *virtualGoodMainCategory;

#pragma mark - End of Basic SDK


// ****
// Save VirtualGood item to Applicasa DB
//
//- (void) saveWithBlock:(LiBlockAction)block;

// ****
// Increase VirtualGood int and float fields item in Applicasa DB
//
//- (void) increaseField:(LiFields)field ByValue:(NSNumber *)value;

// ****
// Get VirtualGood Array from Applicasa DB - Locally only
//
+ (void) getArrayWithQuery:(LiQuery *)query WithBlock:(GetVirtualGoodArrayFinished)block;

+ (void) getAllVirtualGoodByType:(VirutalGoodGetTypes)type WithBlock:(GetVirtualGoodArrayFinished)block;
+ (void) getAllVirtualGoodByType:(VirutalGoodGetTypes)type ByCategory:(VirtualGoodCategory *)category WithBlock:(GetVirtualGoodArrayFinished)block;

- (void) buyVirtualGoodWithQuantity:(NSInteger)quantity CurrencyKind:(LiCurrency)currencyKind WithBlock:(LiBlockAction)block;
- (void) giveVirtualGoodWithQuantity:(NSInteger)quantity WithBlock:(LiBlockAction)block;
- (void) useWithQuantity:(NSInteger)quantity WithBlock:(LiBlockAction)block;


@end
