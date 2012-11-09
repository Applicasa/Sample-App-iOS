//
// VirtualGoodCategory.h
// Created by Applicasa 
// 11/8/2012
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>
#import "LiBlockQuery.h"
#import <LiKitIAP/LiKitIAP.h>



//*************
//
// VirtualGoodCategory Class
//
//

#define kVirtualGoodCategoryNotificationString @"VirtualGoodCategoryConflictFound"
#define kShouldVirtualGoodCategoryWorkOffline TRUE
@interface VirtualGoodCategory : LiObject <LiCoreRequestDelegate> {
}

@property (nonatomic, retain) NSString *virtualGoodCategoryID;
@property (nonatomic, retain) NSString *virtualGoodCategoryName;
@property (nonatomic, retain, readonly) NSDate *virtualGoodCategoryLastUpdate;

// ****
// Save VirtualGoodCategoryitem to Applicasa DB
//
- (void) saveWithBlock:(LiBlockAction)block;

// ****
// Increase VirtualGoodCategory int and float fields item in Applicasa DB
//
- (void) increaseField:(LiFields)field ByValue:(NSNumber *)value;

// ****
// Delete VirtualGoodCategory item from Applicasa DB
//
- (void) deleteWithBlock:(LiBlockAction)block;

// ****
// Get VirtualGoodCategory item from Applicasa DB
//
+ (void) getByID:(NSString *)Id QueryKind:(QueryKind)queryKind WithBlock:(GetVirtualGoodCategoryFinished)block;


// ****
// Get VirtualGoodCategory Array from Applicasa DB
// Limit up to 1500 records
// Use The Query's Order and Pager functions to manage the Get method
//
+ (void) getArrayWithQuery:(LiQuery *)query QueryKind:(QueryKind)queryKind WithBlock:(GetVirtualGoodCategoryArrayFinished)block;


// ****
// Get VirtualGoodCategory Array from Local DB
//
+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetVirtualGoodCategoryArrayFinished)block;

// ****
// uploadFile
//
- (void) uploadFile:(NSData *)data ToField:(LiFields)field FileType:(AMAZON_FILE_TYPES)fileType Extenstion:(NSString *)ext WithBlock:(LiBlockAction)block;



#pragma mark - End of Basic SDK

@end
