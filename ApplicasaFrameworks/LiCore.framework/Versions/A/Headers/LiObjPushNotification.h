//
//  LiObjPushNotification.h
//  Framework-iOS
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LiCore/LiObjRequest.h>
#import <LiCore/LiCoreDelegate.h>

@class LiObjPushNotification;

typedef void (^SendPushFinished)(NSError *error, NSString *message,LiObjPushNotification *pushObject);

@interface LiObjPushNotification : NSObject <LiCoreRequestDelegate>{
    SendPushFinished pushBlock;
}

@property (readonly) NSInteger pushID;
@property (nonatomic) NSInteger badge;
@property (nonatomic, retain) NSDictionary *tag;

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *sound;

+ (LiObjPushNotification *) pushWithMessage:(NSString *)_message Sound:(NSString *)_sound Badge:(NSInteger)_badge Tag:(NSDictionary *)_tag;

- (id) initWithMessage:(NSString *)pushMessage Badge:(NSInteger)pushBadge Sound:(NSString *)pushSound Tag:(NSDictionary *)_tag;

- (id) initWithDictionary:(NSDictionary *)dictionary;
+ (LiObjPushNotification *) pushWithDictionary:(NSDictionary *)dictionary;

- (void) setSendPushBlock:(SendPushFinished)block;

@end
