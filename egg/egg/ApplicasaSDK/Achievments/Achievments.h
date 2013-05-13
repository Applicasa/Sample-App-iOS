//
// Achievments.h
// Created by Applicasa 
// 5/13/2013
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>
#import "LiBlocks.h"
#import "LiDataTypes.h"
#import <LiCore/LiKitFacebook.h>
#import <LiCore/UpdateObject.h>



//*************
//
// Achievments Class
//
//

#define kAchievmentsNotificationString @"AchievmentsConflictFound"
#define kShouldAchievmentsWorkOffline YES
@interface Achievments : LiObject <LiCoreRequestDelegate> {
}

@property (nonatomic, strong) NSString *achievmentsID;
@property (nonatomic, strong, readonly) NSDate *achievmentsLastUpdate;
@property (nonatomic, assign) int achievmentsPoints;
@property (nonatomic, strong) NSString *achievmentsDes;

/*********************************************************************************
 DEPRECATED METHODS WARNING:
 
 Applicasa is cleaning up its SDK in preparation for upcoming 2.0 release.
 
 Do not use methods marked with DEPRECATED_ATTRIBUTE.
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the final release. You should update your code immediately.
 
 Corrected methods are listed first. Use these methods instead.
 **********************************************************************************/
 
// Save Achievmentsitem to Applicasa DB
- (void) saveWithBlock:(LiBlockAction)block;

// Increase Achievments int and float fields item in Applicasa DB
- (void) increaseField:(LiFields)field byValue:(NSNumber *)value;

// Delete Achievments item from Applicasa DB
- (void) deleteWithBlock:(LiBlockAction)block;

// Get Achievments item from Applicasa DB
+ (void) getById:(NSString *)idString queryKind:(QueryKind)queryKind withBlock:(GetAchievmentsFinished)block;

// Get Achievments Array from Applicasa DB
// Limit up to 1500 records
// Use The Query's Order and Pager functions to manage the Get method
+ (void) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind withBlock:(GetAchievmentsArrayFinished)block;

// Get Achievments Array from Local DB
+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetAchievmentsArrayFinished)block;

+ (NSArray *) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind;

+ (void) getArrayWithFilter:(LiFilters *)filter withBlock:(UpdateObjectFinished)block;

// uploadFile
- (void) uploadFile:(NSData *)data toField:(LiFields)field withFileType:(AMAZON_FILE_TYPES)fileType extension:(NSString *)ext andBlock:(LiBlockAction)block;


#pragma mark - End of Basic SDK

@end
