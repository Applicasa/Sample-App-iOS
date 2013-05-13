//
// Languages.h
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
// Languages Class
//
//

#define kLanguagesNotificationString @"LanguagesConflictFound"
#define kShouldLanguagesWorkOffline YES
@interface Languages : LiObject <LiCoreRequestDelegate> {
}

@property (nonatomic, strong) NSString *languagesID;
@property (nonatomic, strong, readonly) NSDate *languagesLastUpdate;
@property (nonatomic, strong) NSString *languagesText;
@property (nonatomic, strong) NSString *languagesLanguageName;

/*********************************************************************************
 DEPRECATED METHODS WARNING:
 
 Applicasa is cleaning up its SDK in preparation for upcoming 2.0 release.
 
 Do not use methods marked with DEPRECATED_ATTRIBUTE.
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the final release. You should update your code immediately.
 
 Corrected methods are listed first. Use these methods instead.
 **********************************************************************************/
 
// Save Languagesitem to Applicasa DB
- (void) saveWithBlock:(LiBlockAction)block;

// Increase Languages int and float fields item in Applicasa DB
- (void) increaseField:(LiFields)field byValue:(NSNumber *)value;

// Delete Languages item from Applicasa DB
- (void) deleteWithBlock:(LiBlockAction)block;

// Get Languages item from Applicasa DB
+ (void) getById:(NSString *)idString queryKind:(QueryKind)queryKind withBlock:(GetLanguagesFinished)block;

// Get Languages Array from Applicasa DB
// Limit up to 1500 records
// Use The Query's Order and Pager functions to manage the Get method
+ (void) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind withBlock:(GetLanguagesArrayFinished)block;

// Get Languages Array from Local DB
+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetLanguagesArrayFinished)block;

+ (NSArray *) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind;

+ (void) getArrayWithFilter:(LiFilters *)filter withBlock:(UpdateObjectFinished)block;

// uploadFile
- (void) uploadFile:(NSData *)data toField:(LiFields)field withFileType:(AMAZON_FILE_TYPES)fileType extension:(NSString *)ext andBlock:(LiBlockAction)block;


#pragma mark - End of Basic SDK

@end
