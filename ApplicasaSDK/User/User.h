//
// User.h
// Created by Applicasa 
// 12/20/2012
//

#import <LiKitPromotions/LiKitPromotionsConstants.h>
#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>
#import "LiBlocks.h"
#import "LiDataTypes.h"



//*************
//
// User Class
//
//

#define kUserNotificationString @"UserConflictFound"
#define kShouldUserWorkOffline YES
@interface User : LiObject <LiCoreRequestDelegate> {
}

@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain, readonly) NSString *userName;
@property (nonatomic, retain) NSString *userFirstName;
@property (nonatomic, retain) NSString *userLastName;
@property (nonatomic, retain) NSString *userEmail;
@property (nonatomic, retain) NSString *userPhone;
@property (nonatomic, retain, readonly) NSString *userPassword;
@property (nonatomic, retain, readonly) NSDate *userLastLogin;
@property (nonatomic, retain, readonly) NSDate *userRegisterDate;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, assign, readonly) BOOL userIsRegisteredFacebook;
@property (nonatomic, assign, readonly) BOOL userIsRegistered;
@property (nonatomic, retain, readonly) NSDate *userLastUpdate;
@property (nonatomic, retain, readonly) NSString *userFacebookID;
@property (nonatomic, retain) NSURL *userImage;
@property (nonatomic, assign) int userMainCurrencyBalance;
@property (nonatomic, assign) int userSecondaryCurrencyBalance;
@property (nonatomic, retain) NSDate *userTempDate;

/*********************************************************************************
 DEPRECATED METHODS WARNING:
 
 Applicasa is cleaning up its SDK in preparation for upcoming 2.0 release.
 
 Do not use methods marked with DEPRECATED_ATTRIBUTE.
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the final release. You should update your code immediately.
 
 Corrected methods are listed first. Use these methods instead.
 **********************************************************************************/
 
// Save Useritem to Applicasa DB
- (void) saveWithBlock:(LiBlockAction)block;

// Increase User int and float fields item in Applicasa DB
- (void) increaseField:(LiFields)field byValue:(NSNumber *)value;
- (void) increaseField:(LiFields)field ByValue:(NSNumber *)value DEPRECATED_ATTRIBUTE;

// Get User item from Applicasa DB
+ (void) getById:(NSString *)idString queryKind:(QueryKind)queryKind withBlock:(GetUserFinished)block;
+ (void) getByID:(NSString *)idString QueryKind:(QueryKind)queryKind WithBlock:(GetUserFinished)block DEPRECATED_ATTRIBUTE;

// Get User Array from Applicasa DB
// Limit up to 1500 records
// Use The Query's Order and Pager functions to manage the Get method
+ (void) getArrayWithQuery:(LiQuery *)query queryKind:(QueryKind)queryKind withBlock:(GetUserArrayFinished)block;
+ (void) getArrayWithQuery:(LiQuery *)query QueryKind:(QueryKind)queryKind WithBlock:(GetUserArrayFinished)block DEPRECATED_ATTRIBUTE;

// Get User Array from Local DB
+ (void) getLocalArrayWithRawSQLQuery:(NSString *)rawQuery andBlock:(GetUserArrayFinished)block;
+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetUserArrayFinished)block DEPRECATED_ATTRIBUTE;

// uploadFile
- (void) uploadFile:(NSData *)data toField:(LiFields)field withFileType:(AMAZON_FILE_TYPES)fileType extension:(NSString *)ext andBlock:(LiBlockAction)block;
- (void) uploadFile:(NSData *)data ToField:(LiFields)field FileType:(AMAZON_FILE_TYPES)fileType Extenstion:(NSString *)ext WithBlock:(LiBlockAction)block DEPRECATED_ATTRIBUTE;


+ (User *) getCurrentUser;

#pragma mark - Profile Data Methods

+ (LiSpendProfile) getCurrentSpendProfile;
+ (LiUsageProfile) getCurrentUsageProfile;

#pragma mark - End of Basic SDK



- (void) registerUsername:(NSString *)username andPassword:(NSString *)password withBlock:(LiBlockAction)block;
- (void) registerUserWithUsername:(NSString *)username Password:(NSString *)password WithBlock:(LiBlockAction)block DEPRECATED_ATTRIBUTE;

+ (void) loginWithUsername:(NSString *)username andPassword:(NSString *)password withBlock:(LiBlockAction)block;
+ (void) loginUserWithUsername:(NSString *)username Password:(NSString *)password WithBlock:(LiBlockAction)block DEPRECATED_ATTRIBUTE;

+ (void) updateUsername:(NSString *)newUsername usingPassword:(NSString *)password withBlock:(LiBlockAction)block;
+ (void) updateUsername:(NSString *)newUsername WithPassword:(NSString *)password WithBlock:(LiBlockAction)block DEPRECATED_ATTRIBUTE;

+ (void) updatePassword:(NSString *)newPassword forOldPassword:(NSString *)oldPassword withBlock:(LiBlockAction)block;
+ (void) updatePassword:(NSString *)newPassword OldPassword:(NSString *)oldPassword WithBlock:(LiBlockAction)block DEPRECATED_ATTRIBUTE;

+ (void) logoutWithBlock:(LiBlockAction)block;
+ (void) logOutWithBlock:(LiBlockAction)block DEPRECATED_ATTRIBUTE;

+ (void) forgotPasswordForUsername:(NSString *)username withBlock:(LiBlockAction)block;

@end
