//
//  LiBasicFilters.h
//  LiCore
//
//  Created by Benny Davidovitz on 12/30/12.
//  Copyright (c) 2012 benny@applicasa.com. All rights reserved.
//

#import <LiCore/LiCore.h>

@interface LiBasicFilters : LiFilters{
    OPERATORS _operator;
}

- (id) initFilterWithField:(LiFields)_field Value:(id)_value Operator:(OPERATORS)__operator;

@end
