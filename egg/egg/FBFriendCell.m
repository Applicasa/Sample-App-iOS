//
//  FBFriendCell.m
//  egg
//
//  Created by admin on 11/22/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "FBFriendCell.h"
#import "User+Facebook.h"
#import "FindFriendsViewController.h"

enum SelectModes{
    SelectModesAdd = 1,
    SelectModesAdded = 2
};

@implementation FBFriendCell

static UIImage *addImage = nil;
static UIImage *addedImage = nil;

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
    [self configureWithFriend:liObjFbFriend];
    return self;
}

- (void) configureWithFriend:(LiObjFBFriend *)liObjFbFriend{
    [liObjFbFriend.facebookImage getCachedImageWithBlock:^(NSError *error, UIImage *image) {
        self.imageView.image = image;
    }];
    [self.nameLabel setText:liObjFbFriend.facebookName];
    if (!addImage)
        addImage = [UIImage imageNamed:@"add"];
    [self.addButton setImage:addImage forState:UIControlStateNormal];
    self.tag = SelectModesAdd;
}

- (IBAction)addAction:(UIButton *)sender{
    UIImage *image = nil;
    SEL selector = NULL;
    switch (self.tag) {
        case SelectModesAdd:
        {
            if (!addedImage)
                addedImage = [UIImage imageNamed:@"added"];
            image = addedImage;
            selector = @selector(friendSelected:);
            self.tag = SelectModesAdded;
        }
            break;
        case SelectModesAdded:
        {
            image = addImage;
            selector = @selector(friendDeSelected:);
            self.tag = SelectModesAdd;
        }
            break;
        default:
            break;
    }
    [sender setImage:image forState:UIControlStateNormal];
    UITableView *tableView = (UITableView *)[self superview];
    FindFriendsViewController *findFriendsVC = (FindFriendsViewController *)[tableView dataSource];
    if (selector){
        NSIndexPath *indexPath = [tableView indexPathForCell:self];
        [findFriendsVC performSelector:selector withObject:indexPath];
    }
    
}

@end
