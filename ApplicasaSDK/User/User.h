//
// User.h
// Created by Applicasa 
// 11/11/2012
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>
#import "LiBlockQuery.h"



//*************
//
// User Class
//
//

#define kUserNotificationString @"UserConflictFound"
#define kShouldUserWorkOffline TRUE
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
@property (nonatomic, assign, readonly) BOOL userIsRegistered;
@property (nonatomic, assign, readonly) BOOL userIsRegisteredFacebook;
@property (nonatomic, retain, readonly) NSDate *userLastUpdate;
@property (nonatomic, retain) NSURL *userImage;
@property (nonatomic, assign) int userMainCurrencyBalance;
@property (nonatomic, assign) int userSecondaryCurrencyBalance;
@property (nonatomic, retain, readonly) NSString *userFacebookID;

// ****
// Save Useritem to Applicasa DB
//
- (void) saveWithBlock:(LiBlockAction)block;

// ****
// Increase User int and float fields item in Applicasa DB
//
- (void) increaseField:(LiFields)field ByValue:(NSNumber *)value;


// ****
// Get User item from Applicasa DB
//
+ (void) getByID:(NSString *)Id QueryKind:(QueryKind)queryKind WithBlock:(GetUserFinished)block;


// ****
// Get User Array from Applicasa DB
// Limit up to 1500 records
// Use The Query's Order and Pager functions to manage the Get method
//
+ (void) getArrayWithQuery:(LiQuery *)query QueryKind:(QueryKind)queryKind WithBlock:(GetUserArrayFinished)block;


// ****
// Get User Array from Local DB
//
+ (void) getArrayLocalyWithRawSQLQuery:(NSString *)rawQuery WithBlock:(GetUserArrayFinished)block;

// ****
// uploadFile
//
- (void) uploadFile:(NSData *)data ToField:(LiFields)field FileType:(AMAZON_FILE_TYPES)fileType Extenstion:(NSString *)ext WithBlock:(LiBlockAction)block;


+ (User *) getCurrentUser;

#pragma mark - End of Basic SDK



- (void) registerUserWithUsername:(NSString *)username Password:(NSString *)password WithBlock:(LiBlockAction)block;
+ (void) loginUserWithUsername:(NSString *)username Password:(NSString *)password WithBlock:(LiBlockAction)block;
+ (void) updateUsername:(NSString *)newUsername WithPassword:(NSString *)password WithBlock:(LiBlockAction)block;
+ (void) updatePassword:(NSString *)newPassword OldPassword:(NSString *)oldPassword WithBlock:(LiBlockAction)block;
+ (void) logOutWithBlock:(LiBlockAction)block;
+ (void) forgotPasswordWithBlock:(LiBlockAction)block;


@end
