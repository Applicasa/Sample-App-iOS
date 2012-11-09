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

- (void) facebookLoginWithBlock:(LiBlockAction)block;
+ (void) facebookFindFriendsWithBlock:(LiBlockFBFriendsAction)block;
+ (void) facebookLogOutWithBlock:(LiBlockAction)block;

@end
