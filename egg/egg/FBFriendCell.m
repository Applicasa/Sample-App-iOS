//
//  FBFriendCell.m
//  egg
//
//  Created by admin on 11/22/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "FBFriendCell.h"
#import "User+Facebook.h"

@implementation FBFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Friend:(LiObjFBFriend *)liObjFbFriend{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    [liObjFbFriend.facebookImage getCachedImageWithBlock:^(NSError *error, UIImage *image) {
        self.imageView.image = image;
    }];
    [self.nameLabel setText:liObjFbFriend.facebookName];
    NSString *addButtonImageName = @"";
    if (liObjFbFriend.user)
        addButtonImageName = @"add";
    else
        addButtonImageName = @"added";
    [self.addButton setImage:[UIImage imageNamed:addButtonImageName] forState:UIControlStateNormal];
    return self;
}

@end
