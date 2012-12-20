//
//  LiObjOrder.h
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>

@interface LiObjOrder : NSObject

@property (nonatomic,retain) id sortField;
@property (nonatomic,assign) SortType sortType;

+ (LiObjOrder *) orderItemWithSortField:(id)sortField SortType:(SortType)sortType;
- (NSDictionary *) mongoDictionary;

@end
