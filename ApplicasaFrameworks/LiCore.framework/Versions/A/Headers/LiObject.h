//
//  LiObject.h
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>

typedef void (^LiBlockAction)(NSError *error, NSString *itemID,Actions action);

@class LiQuery;
@interface LiObject : NSObject <NSCopying>{

}
@property (nonatomic, strong) NSMutableDictionary *increaseDictionary;

- (id) initWithDictionary:(NSDictionary *)item;
- (id) initWithDictionary:(NSDictionary *)item Header:(NSString *)header;
- (id) initWithObject:(LiObject *)object;
- (id) initWithStatement:(sqlite3_stmt *)stmt Array:(int **)array IsFK:(BOOL)isFK;

- (NSDictionary *) dictionaryRepresentation;

+ (NSString *) getFieldName:(LiFields)field;
+ (id) instance;
+ (id) instanceWithID:(NSString *)ID;

+ (NSString *) getClassName;
+ (NSDictionary *) getFields;
+ (NSDictionary *) getForeignKeys;

+ (LiQuery *) setFieldsNameToQuery:(LiQuery *)query;
- (void) respondToGetArray_ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage Array:(NSArray *)array Block:(void *)block;

- (void) respondToLiActionCallBack:(NSInteger)resonseType ResponseMessage:(NSString *)responseMessage ItemID:(NSString *)itemID Action:(Actions)action Block:(void *)block;

+ (void) cancelRequestsForDelegate:(id)delegate;

- (BOOL) isServerId:(NSString *)IdString;
- (void) addValuesToRequest:(LiObjRequest **)request;

+ (void) clearAllObjectContentWithFilter:(LiFilters *)filter Error:(NSError **)error;

@end
