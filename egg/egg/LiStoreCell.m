//
//  LiStoreCell.m
//  egg
//
//  Created by Bob Waycott on 11/9/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "LiStoreCell.h"
#import "LiStoreCellBackground.h"

@implementation LiStoreCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // set the custom selectedBackgroundView using LiStoreCellBackground
        [self setBackgroundColor:[UIColor clearColor]];
        [self.itemImage setBackgroundColor:[UIColor clearColor]];
        LiStoreCellBackground *bgView = [[LiStoreCellBackground alloc] initWithFrame:CGRectZero];
        [bgView setBackgroundColor:[UIColor clearColor]];
        self.selectedBackgroundView = bgView;
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
