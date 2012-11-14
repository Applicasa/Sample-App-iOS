//
//  LiCore.h
//  Framework-iOS
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import <Foundation/Foundation.h>

#import <LiCore/LiObjPushNotification.h>
#import <LiCore/NSDate+SQLiteDate.h>
#import <LiCore/LiCoreDelegate.h>
#import <LiCore/LiObjRequest.h>
#import <LiCore/LiUtilities.h>
#import <LiCore/LiResponse.h>
#import <LiCore/LiObjOrder.h>
#import <LiCore/LiFilters.h>
#import <LiCore/LiObject.h>
#import <LiCore/LiQuery.h>

@class User;
@interface LiCore : NSObject

// Push Notification

// Method that send the device token to LiCore server
+ (void) registerDeviceToken:(NSData *)deviceToken;
// Method that notify about failed to get Token
+ (void) failToRegisterDeviceToken;

// Location Services

// Method to get the current location
+ (void) getCurrentLocation:(id <LiCoreLocationDelegate>)delegate;
// Method to update the current User location (only once)
+ (void) updateUserLocation:(id <LiCoreUpdateLocationDelegate>)delegate;
// Method to auto update the current User location
+ (void) startUpdatingUserLocationWithDelegate:(id <LiCoreUpdateLocationDelegate>)delegate;
// Method to stop the current User location update
+ (void) stopUpdatingUserLocation;
// A Method to set the CLLocatinoManager's distanceFilter
+ (void) setDistanceFilter:(CLLocationDistance)distanceFilter;
// A Method to set the CLLocatinoManager's desireAccuracy
+ (void) setDesireAccuracy:(CLLocationAccuracy)desireAccuracy;


+ (void) clearContentOfObject:(NSString *)object WithFilter:(LiFilters *)filter Error:(NSError **)error;

+ (User *) getCurrentUser;
+ (NSDateFormatter *) liSqliteDateFormatter;

// Method to commit the sending push action
+ (void) sendPush:(LiObjPushNotification *)push ToUsers:(NSArray *)users WithBlock:(SendPushFinished)block;

+ (void) initObjectsDictionary:(NSArray *)array;
+ (void) initForeignKeysWithDictionary:(NSDictionary *)dictionary;

+ (BOOL) isDoneLoading;

#pragma mark - Caching Methods

+ (void) deleteAllCachedImages;


@end