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
#import "AlertShower.h"

@interface FindFriendsViewController ()

@end

@implementation FindFriendsViewController
@synthesize fbFriendsArray,selectionsArray;

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
    NSMutableArray *usersArray = [[NSMutableArray alloc] init];
    for (LiObjFBFriend *friend in fbFriendsArray)
        if ([[friend user] userID])
            [usersArray addObject:[friend user]];
    
    [LiCore sendPush:[LiObjPushNotification pushWithMessage:@"I am challanging you my friend" Sound:nil Badge:1 Tag:nil] ToUsers:usersArray WithBlock:^(NSError *error, NSString *message, LiObjPushNotification *pushObject) {
        if (error)
            [AlertShower showAlertWithMessage:error.localizedDescription OnViewController:self];
        else
            [AlertShower showAlertWithMessage:@"Challange Sent" OnViewController:self];
    }];
}

- (IBAction)inviteFriend:(id)sender{
    DDLogInfo(@"User said inviteFriend. Inviting ...");
    
}

- (void) friendSelected:(NSIndexPath *)indexPath{
    if (!selectionsArray)
        self.selectionsArray = [[NSMutableArray alloc] init];
    [selectionsArray addObject:[fbFriendsArray objectAtIndex:indexPath.row]];
}

- (void) friendDeSelected:(NSIndexPath *)indexPath{
    [selectionsArray removeObject:[fbFriendsArray objectAtIndex:indexPath.row]];
}

#pragma mark - UITableView Data Source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return fbFriendsArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FBFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    [cell configureWithFriend:[fbFriendsArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
