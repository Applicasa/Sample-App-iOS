//
//  User+Facebook.h
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "User.h"
#import <LiKitFacebook/LiKitFacebook.h>

typedef void (^LiBlockFBFriendsAction)(NSError *error, NSArray *friends,Actions action);

@interface User (Facebook) <LiKitFacebookDelegate>

#pragma mark - LiKitFacebook

#pragma mark - End of Basic SDK

/*********************************************************************************
 DEPRECATED METHODS WARNING:
 
 Applicasa is cleaning up its SDK in preparation for upcoming 2.0 release.
 
 Do not use methods marked with DEPRECATED_ATTRIBUTE.
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the final release. You should update your code immediately.
 
 Corrected methods are listed first. Use these methods instead.
 **********************************************************************************/

- (void) facebookLoginWithBlock:(LiBlockAction)block;
+ (void) facebookFindFriendsWithBlock:(LiBlockFBFriendsAction)block;

+ (void) facebookLogoutWithBlock:(LiBlockAction)block;
+ (void) facebookLogOutWithBlock:(LiBlockAction)block DEPRECATED_ATTRIBUTE;

@end
