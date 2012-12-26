//
//  LiFilters.h
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCoreDelegate.h>
#import "LiBlocks.h"
#import "LiDataTypes.h"
#import <LiCore/LiCoreDelegate.h>

@class LiGeoFilter;
@interface LiFilters : NSObject
@property (nonatomic, retain) id field;
@property (nonatomic, retain) id value;

- (NSString *) sqlDescription;
- (NSString *) mongoDescriptionByClassName:(NSString *)className;
- (LiGeoFilter *) getGeoFilter;

+ (NSString *) getSQLOperatorString:(OPERATORS)oper;
+ (NSString *) getMongoOperatorString:(OPERATORS)oper WithValue:(id)value isIDField:(BOOL)isIDField;

- (LiFilters *) NOT;
/*
 Bool val with kLiTrue or kLiFalse
 */
+ (LiFilters *) filterByField:(LiFields)field Operator:(OPERATORS)op Value:(id)value;
+ (LiFilters *) filterByOperandA:(LiFilters *)operandA ComplexOperator:(COMPLEX_OPERATORS)op OperandB:(LiFilters *)operandB;
+ (LiFilters *) filterByField:(LiFields)field OrOperatorWithArrayOfValues:(NSArray *)array;

@end

@interface LiBasicFilters: LiFilters {
    OPERATORS _operator;
}

- (id) initFilterWithField:(LiFields)_field Value:(id)_value Operator:(OPERATORS)__operator;

@end

@interface LiComplexFilters : LiFilters {
    
}
@property (nonatomic, assign) COMPLEX_OPERATORS complexOperator;
- (id) initWithOperandA:(LiFilters *)_operandA OperandB:(LiFilters *)_operandB Operator:(COMPLEX_OPERATORS)_operator;

@property (nonatomic, retain) LiFilters *operandA;
@property (nonatomic, retain) LiFilters *operandB;

@end

@interface LiPager : NSObject{
    NSUInteger page;
    NSUInteger recordsPerPage;
}

+ (LiPager *) pagerWithPage:(NSUInteger)page RecordsPerPage:(NSUInteger)recordsPerPage;
- (NSDictionary *) pagerMongoDictionary;
- (NSString *) sqlPagingQuery;

@end
