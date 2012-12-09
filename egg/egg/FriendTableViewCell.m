//
//  FriendTableViewCell.m
//  egg
//
//  Created by Benny Davidovitz on 12/4/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "NearbyFriendsViewController.h"
#import "FriendTableViewCell.h"
#import "User+DisplayName.h"

enum ActionButtonState {
    ActionButtonStateNormal = 1,
    ActionButtonStateSelected
    };

@implementation FriendTableViewCell

static UIImage *addImage = nil;
static UIImage *addedImage = nil;
static UIImage *avatarImage = nil;
static NearbyFriendsViewController *nearbyFriendsViewController = nil;

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

- (IBAction)actionButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case ActionButtonStateNormal:
        {
            [button setTag:ActionButtonStateSelected];
            [button setImage:addedImage forState:UIControlStateNormal];
            [nearbyFriendsViewController addUserByCell:self];
        }
            break;
        case ActionButtonStateSelected:
        {
            [button setTag:ActionButtonStateNormal];
            [button setImage:addImage forState:UIControlStateNormal];
            [nearbyFriendsViewController removeUserByCell:self];
        }
            break;
        default:
            break;
    }
    
}

- (void) setCellContenetWithUser:(User *)user viewController:(NearbyFriendsViewController *)viewController{
    [[user userImage] getCachedImageWithBlock:^(NSError *error, UIImage *image) {
        if (error || !image){
            //load avatar
            if (!avatarImage)
                avatarImage = [UIImage imageNamed:@"avatar"];
            [self.imageView setImage:avatarImage];
        } else {
            [self.imageView setImage:image];
        }
    }];
    
    CLLocation *currentLocation = [[User getCurrentUser] userLocation];
    NSString *labelString = [NSString stringWithFormat:@"%@, %d meters",[user displayName],(int)[currentLocation distanceFromLocation:[user userLocation]]];
    [self.label setText:labelString];
    
    if (!addImage)
        addImage = [UIImage imageNamed:@"add"];
    if (!addedImage)
        addedImage = [UIImage imageNamed:@"added"];

    [self.actionButton setImage:addImage forState:UIControlStateNormal];
    [self.actionButton setTag:ActionButtonStateNormal];
    
    if (!nearbyFriendsViewController)
        nearbyFriendsViewController = viewController;
}

@end
