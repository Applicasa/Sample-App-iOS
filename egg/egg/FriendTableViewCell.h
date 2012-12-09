//
//  FriendTableViewCell.h
//  egg
//
//  Created by Benny Davidovitz on 12/4/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class NearbyFriendsViewController;
@interface FriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)actionButtonPressed:(id)sender;

- (void) setCellContenetWithUser:(User *)user viewController:(NearbyFriendsViewController *)viewController;

@end
