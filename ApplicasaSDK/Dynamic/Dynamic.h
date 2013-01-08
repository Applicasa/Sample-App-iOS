//
// Dynamic.h
// Created by Applicasa 
// 07/01/2013
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>
#import "LiBlocks.h"
#import "LiDataTypes.h"



//*************
//
// Dynamic Class
//
//

#define kDynamicNotificationString @"DynamicConflictFound"
#define kShouldDynamicWorkOffline YES
@interface Dynamic : LiObject <LiCoreRequestDelegate> {
}

@property (nonatomic, strong) NSString *dynamicID;
@property (nonatomic, strong, readonly) NSDate *dynamicLastUpdate;
@property (nonatomic, strong) NSString *dynamicText;
@property (nonatomic, assign) int dynamicNumber;
@property (nonatomic, assign) float dynamicReal;
@property (nonatomic, strong) NSDate *dynamicDate;
@property (nonatomic, assign) BOOL dynamicBool;
@property (nonatomic, strong) NSString *dynamicHtml;

/*********************************************************************************
 DEPRECATED METHODS WARNING:
 
 Applicasa is cleaning up its SDK in preparation for upcoming 2.0 release.
 
 Do not use methods marked with DEPRECATED_ATTRIBUTE.
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the final release. You should update your code immediately.
 
 Corrected methods are listed first. Use these methods instead.
 **********************************************************************************/
 
// Save Dynamicitem to Applicasa DB
- (void) saveWithBlock:(LiBlockAction)block;

// Increase Dynamic int and float fields item in Applicasa DB
- (void) increaseField:(LiFields)field byValue:(NSNumber *)value;
- (void) increaseField:(LiFields)field ByValue:(NSNumber *)value DEPRECATED_ATTRIBUTE;

// Delete Dynamic item from Applicasa DB
- (void) deleteWithBlock:(LiBlockAction)block;

// Get Dynamic item from Applicasa DB
+ (void) getById:(NSString *)idString queryKind:(QueryKind)queryKind withBlock:(GetDynamicFinished)block;
+ (void) getByID:(NSString *)idString QueryKind:(QueryKind)queryKind WithBlock:(GetDynamicFinished)block DEPRECATED_ATTRIBUTE;

// Get Dynamic Array from Applicasa DB
// Limit up to 1500 records
// Use The Query's Order and Pager functions to manage the Get method
+ (void) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind withBlock:(GetDynamicArrayFinished)block;
+ (void) getArrayWithQuery:(LiQuery *)query QueryKind:(QueryKind)queryKind WithBlock:(GetDynamicArrayFinished)block DEPRECATED_ATTRIBUTE;

// Get Dynamic Array from Local DB
+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetDynamicArrayFinished)block;
+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetDynamicArrayFinished)block DEPRECATED_ATTRIBUTE;

// uploadFile
- (void) uploadFile:(NSData *)data toField:(LiFields)field withFileType:(AMAZON_FILE_TYPES)fileType extension:(NSString *)ext andBlock:(LiBlockAction)block;
- (void) uploadFile:(NSData *)data ToField:(LiFields)field FileType:(AMAZON_FILE_TYPES)fileType Extenstion:(NSString *)ext WithBlock:(LiBlockAction)block DEPRECATED_ATTRIBUTE;


#pragma mark - End of Basic SDK

@end
