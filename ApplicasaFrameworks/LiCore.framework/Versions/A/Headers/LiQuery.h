//
//  LiQuery.h
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCoreDelegate.h>
#import "LiDataTypes.h"

@class LiFilters;
@class LiPager;
@interface LiQuery : NSObject

@property (nonatomic, retain) NSMutableArray *orderArray;
@property (nonatomic, retain) LiFilters *filters;
@property (nonatomic, retain) LiFilters *geoFilter;
@property (nonatomic, retain) LiPager *pager;

- (void) setGeoFilterBy:(LiFields)field Location:(CLLocation *)location Radius:(int)radius;
- (void) addOrderByField:(LiFields)field SortType:(SortType)sortType;
- (void) addPagerByPage:(NSUInteger)page RecordsPerPage:(NSUInteger)recordsPerPage;

- (NSString *) getMongoQueryWithQueryKind:(QueryKind)queryKind ClassName:(NSString *)className;
- (NSString *) sqlQueryDescription;
- (NSString *) sqlOrderQuery;

@end
