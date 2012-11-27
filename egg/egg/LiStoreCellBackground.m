//
//  LiStoreCellBackground.m
//  egg
//
//  Created by Applicasa on 11/14/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "LiStoreCellBackground.h"

@implementation LiStoreCellBackground

- (void)drawRect:(CGRect)rect
{
    
    // draw a rounded rect bezier path filled with blue
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(aRef);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
    UIColor *fillColor = [UIColor colorWithRed:0.24 green:0.52 blue:0.78 alpha:1.0];
    [fillColor setFill];
    [bezierPath fill];
    CGContextRestoreGState(aRef);
}

@end
