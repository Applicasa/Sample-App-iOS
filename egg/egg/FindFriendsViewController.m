//
//  FindFriendsViewController.m
//  egg
//
//  Created by admin on 11/22/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "FindFriendsViewController.h"
#import "User+Facebook.h"
#import "FBFriendCell.h"

@interface FindFriendsViewController ()

@end

@implementation FindFriendsViewController
@synthesize fbFriendsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[User facebookFindFriendsWithBlock:^(NSError *error, NSArray *friends, Actions action) {
        self.fbFriendsArray = friends;
        [self.friendsTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)goBack:(id)sender{
    DDLogInfo(@"User said goBack. Dismissing ...");
    [self.delegate findFriendsViewControllerDidGoBack:self];
}

- (IBAction)shareOnFB:(id)sender{
    DDLogInfo(@"User said shareOnFB. Sharing ...");
}

- (IBAction)challengeFriend:(id)sender{
    DDLogInfo(@"User said challengeFriend. Challenging ...");
}

- (IBAction)inviteFriend:(id)sender{
    DDLogInfo(@"User said inviteFriend. Inviting ...");
}

#pragma mark - UITableView Data Source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return fbFriendsArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FBFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    if (cell == nil)
        cell = [[FBFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendCell" Friend:[fbFriendsArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
