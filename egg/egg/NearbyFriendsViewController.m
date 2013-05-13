//
//  NearbyFriendsViewController.m
//  egg
//
//  Created by Benny Davidovitz on 12/4/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "NearbyFriendsViewController.h"
#import "LiObjPushNotification.h"
#import "FriendTableViewCell.h"
#import "User+DisplayName.h"
#import "AlertShower.h"
#import "User.h"
#import "LiLog.h"

static UIImage *challangeOn = nil;
static UIImage *challangeOff = nil;

@interface NearbyFriendsViewController ()

@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, strong) NSMutableArray *selectedUsers;

@end

@implementation NearbyFriendsViewController
@synthesize tableArray,selectedUsers;

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
    
    self.selectedUsers = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
    LiQuery *query = [[LiQuery alloc] init];
    CLLocation *currentUserLocation = [[User getCurrentUser] userLocation];
    if (!currentUserLocation){
        [AlertShower showAlertWithMessage:@"Can't get Currenct Location" onViewController:self];
        return;
    }
    [query setGeoFilterBy:UserLocation Location:currentUserLocation Radius:50000];
    [User getArrayWithQuery:query queryKind:LIGHT withBlock:^(NSError *error, NSArray *array) {
        self.tableArray = array;
        [self.friendsTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    // Responds to back arrow button tap
    LiLogSampleApp(@"User said goBack. Dismissing...");
    [self.delegate nearbyFriendsViewControllerDidGoBack:self];
}

- (IBAction)challangeAction:(id)sender {
    if (!selectedUsers.count)
        return;
    
    NSString *myName = [[User getCurrentUser] displayName];
    LiObjPushNotification *pushNotification = [LiObjPushNotification pushWithMessage:[NSString stringWithFormat:@"%@ is challanging you",myName] sound:nil badge:1 andTag:nil];
    [pushNotification sendPushToUsers:selectedUsers withBlock:^(NSError *error, NSString *message, LiObjPushNotification *pushObject) {
        if (!error){
            //Clean the selections
            [selectedUsers removeAllObjects];
            [self setChallangeButtonState:FALSE];
            [self.friendsTableView reloadData];
        } else {
            [AlertShower showAlertWithMessage:error.localizedDescription onViewController:self];
        }
    }];
    
}

- (void) setChallangeButtonState:(BOOL)state{
    if (state){
        if (!challangeOn)
            challangeOn = [UIImage imageNamed:@"tabChallengeOn"];
        [self.challangeButton setImage:challangeOn forState:UIControlStateNormal];
    } else {
        if (!challangeOff)
            challangeOff = [UIImage imageNamed:@"tabChallenge"];
        [self.challangeButton setImage:challangeOff forState:UIControlStateNormal];
    }
}

- (void) addUserByCell:(UITableViewCell *)cell{
    if (!selectedUsers.count)
        [self setChallangeButtonState:YES];
    
    NSIndexPath *indexPath = [self.friendsTableView indexPathForCell:cell];
    User *item = [self.tableArray objectAtIndex:indexPath.row];
    [selectedUsers addObject:item];
}

- (void) removeUserByCell:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.friendsTableView indexPathForCell:cell];
    User *item = [self.tableArray objectAtIndex:indexPath.row];
    [selectedUsers removeObject:item];
    if (!selectedUsers.count)
        [self setChallangeButtonState:FALSE];
}

#pragma mark - TableView DataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setCellContenetWithUser:[self.tableArray objectAtIndex:indexPath.row] viewController:self];
    return cell;
}

@end
