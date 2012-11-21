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
    fbFriendsAction = Block_copy(block);
}

- (void) setActionBlock:(LiBlockAction)block{
    actionBlock = Block_copy(block);
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

+ (void) facebookLogOutWithBlock:(LiBlockAction)block{
    [LiKitFacebook logOut];
    [self logOutWithBlock:block];
}

#pragma mark - FB Kit Delegate

- (void) FBdidLoginUser:(User *)user ResponseType:(int)responseType ResponseMessage:(NSString *)responseMessage{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
    actionBlock(error,user.userID,LoginWithFacebook);
    Block_release(actionBlock);
}

- (void) FBdidFindFacebookFriends:(NSArray *)friends ResponseType:(int)responseType ResponseMessage:(NSString *)responseMessage{
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
    fbFriendsAction(error,friends,FacebookFriends);
    Block_release(fbFriendsAction);
}

@end
