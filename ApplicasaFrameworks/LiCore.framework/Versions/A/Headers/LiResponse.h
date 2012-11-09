//
//  LiResponse.h
//  Applicasa
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiResponse : NSObject{
    void *statement;
}

@property NSInteger responseType;
@property (nonatomic,retain) NSString *responseMessage;
@property (nonatomic,retain) NSDictionary *responseData;
@property (nonatomic,retain) NSDate *responseTime;

+ (LiResponse *) responseWithDictionary:(NSDictionary *)dictionary;
+ (LiResponse *) responseWithResponseType:(NSInteger)_responseType ResponseMessage:(NSString *)_responseMessage ResponseData:(NSDictionary *)_responseData;

- (void) setStatement:(void *)stmt;
- (void *) getStatement;

- (void)logResponse;


@end
