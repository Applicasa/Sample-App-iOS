//
//  FindFriendsViewController.h
//  egg
//
//  Created by admin on 11/22/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindFriendsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

@property (nonatomic, strong) NSArray *fbFriendsArray;

@end
