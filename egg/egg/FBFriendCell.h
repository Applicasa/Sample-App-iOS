//
//  FBFriendCell.h
//  egg
//
//  Created by Benny Davidovitz on 1/7/13.
//  Copyright (c) 2013 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LiObjFBFriend;
@interface FBFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;


- (void) setCellContenetWithLiObjFBFriend:(LiObjFBFriend *)liObjFBFriend;

@end
