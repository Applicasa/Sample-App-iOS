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

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger facebookID;
@property (nonatomic, strong) NSString *facebookName;
@property (nonatomic, strong) NSURL *facebookImage;

+ (LiObjFBFriend *) friendWithDictionary:(NSDictionary *)dictionary;

@end
