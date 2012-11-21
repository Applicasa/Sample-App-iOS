//
//  LiStoreCell.h
//  egg
//
//  Created by Bob Waycott on 11/9/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiStoreCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *itemImage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *imgData;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) IBOutlet UIButton *btnBuy;

- (void)setImage:(UIImage*)image;
- (void)setInfoText:(NSString *)text;

@end
