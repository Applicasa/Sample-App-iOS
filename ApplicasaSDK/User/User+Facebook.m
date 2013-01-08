//
//  User+Facebook.m
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "User+Facebook.h"

@implementation User (Facebook)
static LiBlockFBFriendsAction fbFriendsAction = NULL;
static LiBlockAction actionBlock = NULL;

- (void) setFbFriendsAction:(LiBlockFBFriendsAction)block{
    fbFriendsAction = (__bridge LiBlockFBFriendsAction)CFBridgingRetain(block);
}

- (void) setActionBlock:(LiBlockAction)block{
    actionBlock = (__bridge LiBlockAction)CFBridgingRetain(block);
}

- (void) facebookLoginWithBlock:(LiBlockAction)block{
    [self setActionBlock:block];
    [LiKitFacebook loginWithFacebookWithUser:self Delegate:self];
}

+ (void) facebookFindFriendsWithBlock:(LiBlockFBFriendsAction)block{
    User *item = [User instance];
    [item setFbFriendsAction:block];
    [LiKitFacebook findFacebookFriendsWithDelegate:item];
}

+ (void) facebookLogoutWithBlock:(LiBlockAction)block{
    [LiKitFacebook logOut];
    [self logoutWithBlock:block];
}

#pragma mark - FB Kit Delegate

- (void) FBdidLoginUser:(User *)user ResponseType:(int)responseType ResponseMessage:(NSString *)responseMessage{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
    actionBlock(error,user.userID,LoginWithFacebook);
    actionBlock = NULL;
}

- (void) FBdidFindFacebookFriends:(NSArray *)friends ResponseType:(int)responseType ResponseMessage:(NSString *)responseMessage{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
    fbFriendsAction(error,friends,FacebookFriends);
    actionBlock = NULL;
}

#pragma mark - Deprecated Methods
/*********************************************************************************
 DEPRECATED METHODS:
 
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the next release. You should update your code immediately.
 **********************************************************************************/

+ (void)facebookLogOutWithBlock:(LiBlockAction)block {
    [self facebookLogoutWithBlock:block];
}

@end
