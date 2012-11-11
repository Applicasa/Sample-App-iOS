//
//  LiStoreCell.m
//  egg
//
//  Created by Bob Waycott on 11/9/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "LiStoreCell.h"

@implementation LiStoreCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    if(_image != image) {
        _image = image;
    }
    self.itemImage.image = _image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
