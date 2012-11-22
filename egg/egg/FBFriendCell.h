//
//  FBFriendCell.h
//  egg
//
//  Created by admin on 11/22/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LiKitFacebook/LiObjFBFriend.h>

@interface FBFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Friend:(LiObjFBFriend *)liObjFbFriend;

@end
