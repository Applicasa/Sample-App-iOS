//
//  LiStoreCell.m
//  egg
//
//  Created by Applicasa on 11/9/12.
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
    // Sets item image to the LiStoreCell created & managed by StoreViewController
    if(_image != image) {
        _image = image;
    }
    self.itemImage.image = _image;
}

- (void)setInfoText:(NSString *)text{
    // Sets custom label text to LiStoreCell when necessary
    [self.infoLabel setText:text];
    [self.infoLabel setFont:[UIFont systemFontOfSize:13]];
    [self.infoLabel setHidden:FALSE];
}


@end
