//
//  LiKitFacebook.h
//  LiCore
//
//  Created by Benny Davidovich on 8/13/12.
//  Copyright (c) 2012 benny@applicasa.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LiKitFacebook/LiObjFBFriend.h>
#import <LiKitFacebook/LiKitFacebookDelegate.h>
#import <FacebookSDK/FacebookSDK.h>

/*
 Implement the application .plist file as described in
 https://developers.facebook.com/docs/getting-started/getting-started-with-the-ios-sdk/#samples
 (Secions 4,5)
 */

@interface LiKitFacebook : NSObject

+ (void) loginWithFacebookWithUser:(User *)User Delegate:(id <LiKitFacebookDelegate>)delegate;
+ (void) findFacebookFriendsWithDelegate:(id <LiKitFacebookDelegate>)delegate;
+ (void) setPermissions:(NSArray *)permissions AllowLoginUI:(BOOL)allowLoginUI;// Publish:(BOOL)publish;


+ (void) logOut;

+ (FBSession *) getActiveSession;


@end
