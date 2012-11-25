//
//  FindFriendsViewController.h
//  egg
//
//  Created by admin on 11/22/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindFriendsViewController;
@class LiObjFBFriend;

@protocol FindFriendsViewControllerDelegate <NSObject>
// delegate for handling login controller actions
- (void) findFriendsViewControllerDidGoBack:(FindFriendsViewController*)controller;
@end

@interface FindFriendsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) id <FindFriendsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (nonatomic, strong) NSArray *fbFriendsArray;
@property (nonatomic, strong) NSMutableArray *selectionsArray;

// actions for storyboard
- (IBAction)goBack:(id)sender;
- (IBAction)shareOnFB:(id)sender;
- (IBAction)challengeFriend:(id)sender;
- (IBAction)inviteFriend:(id)sender;

- (void) friendSelected:(NSIndexPath *)indexPath;
- (void) friendDeSelected:(NSIndexPath *)indexPath;

@end
