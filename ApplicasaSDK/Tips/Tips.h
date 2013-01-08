//
// Tips.h
// Created by Applicasa 
// 07/01/2013
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>
#import "LiBlocks.h"
#import "LiDataTypes.h"



//*************
//
// Tips Class
//
//

#define kTipsNotificationString @"TipsConflictFound"
#define kShouldTipsWorkOffline YES
@interface Tips : LiObject <LiCoreRequestDelegate> {
}

@property (nonatomic, strong) NSString *tipsID;
@property (nonatomic, strong, readonly) NSDate *tipsLastUpdate;
@property (nonatomic, strong) NSString *tipsContent;

/*********************************************************************************
 DEPRECATED METHODS WARNING:
 
 Applicasa is cleaning up its SDK in preparation for upcoming 2.0 release.
 
 Do not use methods marked with DEPRECATED_ATTRIBUTE.
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the final release. You should update your code immediately.
 
 Corrected methods are listed first. Use these methods instead.
 **********************************************************************************/
 
// Save Tipsitem to Applicasa DB
- (void) saveWithBlock:(LiBlockAction)block;

// Increase Tips int and float fields item in Applicasa DB
- (void) increaseField:(LiFields)field byValue:(NSNumber *)value;
- (void) increaseField:(LiFields)field ByValue:(NSNumber *)value DEPRECATED_ATTRIBUTE;

// Delete Tips item from Applicasa DB
- (void) deleteWithBlock:(LiBlockAction)block;

// Get Tips item from Applicasa DB
+ (void) getById:(NSString *)idString queryKind:(QueryKind)queryKind withBlock:(GetTipsFinished)block;
+ (void) getByID:(NSString *)idString QueryKind:(QueryKind)queryKind WithBlock:(GetTipsFinished)block DEPRECATED_ATTRIBUTE;

// Get Tips Array from Applicasa DB
// Limit up to 1500 records
// Use The Query's Order and Pager functions to manage the Get method
+ (void) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind withBlock:(GetTipsArrayFinished)block;
+ (void) getArrayWithQuery:(LiQuery *)query QueryKind:(QueryKind)queryKind WithBlock:(GetTipsArrayFinished)block DEPRECATED_ATTRIBUTE;

// Get Tips Array from Local DB
+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetTipsArrayFinished)block;
+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetTipsArrayFinished)block DEPRECATED_ATTRIBUTE;

// uploadFile
- (void) uploadFile:(NSData *)data toField:(LiFields)field withFileType:(AMAZON_FILE_TYPES)fileType extension:(NSString *)ext andBlock:(LiBlockAction)block;
- (void) uploadFile:(NSData *)data ToField:(LiFields)field FileType:(AMAZON_FILE_TYPES)fileType Extenstion:(NSString *)ext WithBlock:(LiBlockAction)block DEPRECATED_ATTRIBUTE;


#pragma mark - End of Basic SDK

@end
