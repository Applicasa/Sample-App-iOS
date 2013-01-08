//
//  FacebookFeatureViewController.h
//  egg
//
//  Created by Benny Davidovitz on 12/30/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FacebookFeatureViewController;

@protocol FacebookFeatureViewControllerDelegate <NSObject>

// handles NearbyFriendsViewController interactions
- (void) facebookFeatureViewControllerViewControllerDidGoBack:(FacebookFeatureViewController *)controller;

@end

@interface FacebookFeatureViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) id <FacebookFeatureViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *fbFriends;
@property (weak, nonatomic) IBOutlet UITableView *fbFriendsTableView;

@end
