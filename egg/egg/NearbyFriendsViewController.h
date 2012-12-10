//
//  NearbyFriendsViewController.h
//  egg
//
//  Created by Benny Davidovitz on 12/4/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NearbyFriendsViewController;

@protocol NearbyFriendsViewControllerDelegate <NSObject>

// handles NearbyFriendsViewController interactions
- (void) nearbyFriendsViewControllerDidGoBack:(NearbyFriendsViewController*)controller;

@end

@interface NearbyFriendsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) id <NearbyFriendsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *challangeButton;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

- (IBAction)goBack:(id)sender;
- (IBAction)challangeAction:(id)sender;

- (void) addUserByCell:(UITableViewCell *)cell;
- (void) removeUserByCell:(UITableViewCell *)cell;

@end
