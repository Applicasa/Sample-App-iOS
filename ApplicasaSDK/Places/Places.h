//
// Places.h
// Created by Applicasa 
// 1/30/2013
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>
#import "LiBlocks.h"
#import "LiDataTypes.h"
#import <LiCore/LiKitFacebook.h>



//*************
//
// Places Class
//
//

#define kPlacesNotificationString @"PlacesConflictFound"
#define kShouldPlacesWorkOffline YES
@interface Places : LiObject <LiCoreRequestDelegate> {
}

@property (nonatomic, strong) NSString *placesID;
@property (nonatomic, strong, readonly) NSDate *placesLastUpdate;
@property (nonatomic, strong) CLLocation *placesLoc;
@property (nonatomic, strong) NSString *placesName;

/*********************************************************************************
 DEPRECATED METHODS WARNING:
 
 Applicasa is cleaning up its SDK in preparation for upcoming 2.0 release.
 
 Do not use methods marked with DEPRECATED_ATTRIBUTE.
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the final release. You should update your code immediately.
 
 Corrected methods are listed first. Use these methods instead.
 **********************************************************************************/
 
// Save Placesitem to Applicasa DB
- (void) saveWithBlock:(LiBlockAction)block;

// Increase Places int and float fields item in Applicasa DB
- (void) increaseField:(LiFields)field byValue:(NSNumber *)value;
- (void) increaseField:(LiFields)field ByValue:(NSNumber *)value DEPRECATED_ATTRIBUTE;

// Delete Places item from Applicasa DB
- (void) deleteWithBlock:(LiBlockAction)block;

// Get Places item from Applicasa DB
+ (void) getById:(NSString *)idString queryKind:(QueryKind)queryKind withBlock:(GetPlacesFinished)block;
+ (void) getByID:(NSString *)idString QueryKind:(QueryKind)queryKind WithBlock:(GetPlacesFinished)block DEPRECATED_ATTRIBUTE;

// Get Places Array from Applicasa DB
// Limit up to 1500 records
// Use The Query's Order and Pager functions to manage the Get method
+ (void) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind withBlock:(GetPlacesArrayFinished)block;
+ (void) getArrayWithQuery:(LiQuery *)query QueryKind:(QueryKind)queryKind WithBlock:(GetPlacesArrayFinished)block DEPRECATED_ATTRIBUTE;

// Get Places Array from Local DB
+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetPlacesArrayFinished)block;
+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetPlacesArrayFinished)block DEPRECATED_ATTRIBUTE;

// uploadFile
- (void) uploadFile:(NSData *)data toField:(LiFields)field withFileType:(AMAZON_FILE_TYPES)fileType extension:(NSString *)ext andBlock:(LiBlockAction)block;
- (void) uploadFile:(NSData *)data ToField:(LiFields)field FileType:(AMAZON_FILE_TYPES)fileType Extenstion:(NSString *)ext WithBlock:(LiBlockAction)block DEPRECATED_ATTRIBUTE;


#pragma mark - End of Basic SDK

@end
