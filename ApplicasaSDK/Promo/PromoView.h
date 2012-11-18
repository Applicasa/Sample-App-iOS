//
//  PromoView.h
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import <UIKit/UIKit.h>

@class Promotion;
@interface PromoView : UIView
@property (nonatomic, retain) Promotion *promotion;
+ (PromoView *) promoViewWithPromotion:(Promotion *)promotion Frame:(CGRect)frame;

@end
