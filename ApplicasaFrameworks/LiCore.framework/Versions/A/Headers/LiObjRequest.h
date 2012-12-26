//
//  LiObjRequest.h
//  Applicasa
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LiCore/LiCoreDelegate.h>

@class LiResponse;
@interface LiObjRequest : NSObject <LiCoreRequestDelegate>{
    BOOL shouldReturnToDelegate;
    NSMutableData *_data;
}

@property (nonatomic, assign) void *callBackBlock;

@property (nonatomic,retain) id <LiCoreRequestDelegate> delegate;
@property (nonatomic,retain) NSString                   *className;
@property (nonatomic,assign) Actions                    action;
@property (nonatomic,retain) NSMutableDictionary        *requestParameters;

@property (nonatomic,retain) LiResponse                 *response;
@property (nonatomic,assign) BOOL shouldWorkOffline;

+ (LiObjRequest *)requestWithAction:(Actions)action ClassName:(NSString *)className;

- (void) addValue:(id)value forKey:(NSString *)key;
- (void) addIntValue:(NSInteger)value forKey:(NSString *)key;
- (void) addBoolValue:(BOOL)value forKey:(NSString *)key;
- (void) addFloatValue:(float)value forKey:(NSString *)key;
- (void) addDateValue:(NSDate *)value forKey:(NSString *)key;
- (void) addLocationValue:(CLLocation *)value forKey:(NSString *)key;
- (void) addDictionaryValues:(NSDictionary *)dictionary;
- (void) addUrlValue:(NSURL *)url forKey:(NSString *)key;

- (void) startSync:(BOOL)sync;
- (void) respondToDelegate;
- (void) handleOfflineAUDAction;
- (void) handleGetAction;

//+ (NSDate *) parseDateValue:(NSString *)value;
+ (BOOL) parseBoolFromString:(NSString *)str;

+ (BOOL) handleError:(NSError **)error ResponseType:(int)responseType ResponseMessage:(NSString *)responseMessage;
+ (void) removeIDsList:(NSArray *)ids FromObject:(NSString *)object;

- (void) setBlock:(void *)block;
- (void *) getBlock;
- (void) releaseBlock;

@end
