//
//  LiObjFBFriend.h
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa All rights reserved.
// 

#import <UIKit/UIKit.h>

@class User;
@interface LiObjFBFriend : NSObject

@property (nonatomic, retain) User *user;
@property (nonatomic, assign) NSInteger facebookID;
@property (nonatomic, retain) NSString *facebookName;
@property (nonatomic, retain) NSURL *facebookImage;

+ (LiObjFBFriend *) friendWithDictionary:(NSDictionary *)dictionary;

@end
