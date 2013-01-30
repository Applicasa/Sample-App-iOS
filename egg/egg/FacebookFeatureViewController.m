//
//  FacebookFeatureViewController.m
//  egg
//
//  Created by Benny Davidovitz on 12/30/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "FacebookFeatureViewController.h"
#import "User.h"
#import "AlertShower.h"
#import "FBFriendCell.h"

#define kFacebookShareLink          @"www.applicasa.com"
#define kFacebookShareImage         @"https://developers.facebook.com/attachment/iossdk_logo.png"
#define kFacebookShareName          @"Facebook SDK for iOS"
#define kFacebookShareCaption       @"Build great social apps and get more installs."
#define kFacebookShareDescription   @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps."

@interface FacebookFeatureViewController ()

@end

@implementation FacebookFeatureViewController
@synthesize fbFriends,fbFriendsTableView;

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
        if (error){
            [AlertShower showAlertWithMessage:error.localizedDescription onViewController:self];
        } else {
            self.fbFriends = friends;
            [fbFriendsTableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Go Back Action

- (IBAction)goBack:(id)sender {
    DDLogInfo(@"User said goBack. Dismissing...");
    [self.delegate facebookFeatureViewControllerViewControllerDidGoBack:self];
}

#pragma mark - Share Action

- (IBAction)shareAction:(id)sender {
    NSDictionary *postParams = [[NSDictionary alloc] initWithObjectsAndKeys:kFacebookShareLink, @"link",kFacebookShareImage, @"picture",kFacebookShareName, @"name",kFacebookShareCaption, @"caption",kFacebookShareDescription, @"description",nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:postParams HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
         NSString *alertText = nil;
         if (error) {
             alertText = error.localizedDescription;
         } else {
             alertText = @"Share Action Succeeded";
         }
         // Show the result in an alert
        [AlertShower showAlertWithMessage:alertText onViewController:self];
     }];
}

#pragma mark - UITableView DataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fbFriends.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FBFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setCellContenetWithLiObjFBFriend:[fbFriends objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    //Invite the selected friend to join the egg app by posting on his wall
    LiObjFBFriend *friend = [fbFriends objectAtIndex:indexPath.row];
    NSMutableDictionary *postDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Join me!", @"message", @"http://itunes.apple.com/my-super-app", @"link", @"My Super App", @"name", nil];
    
    NSString  *path = [NSString stringWithFormat:@"%@/feed",friend.facebookID];
    [FBRequestConnection startWithGraphPath:path parameters:postDictionary HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSString *alertText = nil;
        if (error) {
            alertText = error.localizedDescription;
        } else {
            alertText = @"Posted action Succeeded";
        }
        // Show the result in an alert
        [AlertShower showAlertWithMessage:alertText onViewController:self];
    }];
    
}

@end
