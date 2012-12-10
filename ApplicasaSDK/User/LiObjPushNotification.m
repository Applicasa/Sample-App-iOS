//
//  LiObjPushNotification.m
//  Framework-iOS
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa All rights reserved.
//

#import "LiObjPushNotification.h"
#import "User.h"
#import <LiCore/LiPushManager.h>

@implementation LiObjPushNotification
@synthesize message;
@synthesize sound;
@synthesize badge;
@synthesize pushID;
@synthesize tag;

-(void)dealloc{
    [message release];
    [sound release];
    [tag release];
    [super dealloc];
}

#pragma mark - init Method

+ (LiObjPushNotification *)pushWithMessage:(NSString *)theMessage sound:(NSString *)theSound badge:(NSInteger)theBadge andTag:(NSDictionary *)theTag{
    return [[[LiObjPushNotification alloc]initWithMessage:theMessage sound:theSound badge:theBadge andTag:theTag]autorelease];
}

-(id)initWithMessage:(NSString *)theMessage sound:(NSString *)theSound badge:(NSInteger)theBadge andTag:(NSDictionary *)theTag{
    if (self=[super init]){
        if (theMessage){
            self.message = theMessage;
        } else {
            self.message = @"";
        }
        self.badge = theBadge;
        self.sound = theSound;
        self.tag = theTag;
    }
    return self;
}

-(id) initWithDictionary:(NSDictionary *)dictionary{
    NSDictionary *theTag = [dictionary objectForKey:@"tag"];
    if ([dictionary objectForKey:@"aps"]){
        dictionary=[dictionary objectForKey:@"aps"];
    }
    return [self initWithMessage:[dictionary objectForKey:@"alert"] sound:[dictionary objectForKey:@"sound"] badge:[[dictionary objectForKey:@"badge"] intValue] andTag:theTag];
}

+ (LiObjPushNotification *) pushWithDictionary:(NSDictionary *)dictionary{
    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}

- (void) sendPushToUsers:(NSArray *)users withBlock:(SendPushFinished)block{
    pushBlock = Block_copy(block);
    [LiPushManager sendPush:self UsersArray:users];
}

#pragma mark - LiObjRequest Delegate

- (void) requestDidFinished:(LiObjRequest *)request{
    NSInteger responseType = request.response.responseType;
    NSString *responseMessage = request.response.responseMessage;
    //NSDictionary *responseData = request.response.responseData;
    
    NSError *error = nil;
    [LiObjRequest handleError:&error ResponseType:responseType ResponseMessage:responseMessage];
    
    pushBlock(error,responseMessage,self);
    Block_release(pushBlock);
    
}

#pragma mark - Deprecated Methods
/*********************************************************************************
 DEPRECATED METHODS:
 
 These methods are deprecated. They are included for backward-compatibility only.
 They will be removed in the next release. You should update your code immediately.
 **********************************************************************************/

- (id) initWithMessage:(NSString *)theMessage Badge:(NSInteger)theBadge Sound:(NSString *)theSound Tag:(NSDictionary *)theTag {
    return [self initWithMessage:theMessage sound:theSound badge:theBadge andTag:theTag];
}

+ (LiObjPushNotification *)pushWithMessage:(NSString *)theMessage Sound:(NSString *)theSound Badge:(NSInteger)theBadge Tag:(NSDictionary *)theTag {
    return [self pushWithMessage:theMessage sound:theSound badge:theBadge andTag:theTag];
}

@end