//
//  ViewController.m
//  egg
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

/*
 
 MainViewController is the app's starting point,
 presenting all available actions to the user.

*/

#import "MainViewController.h"
#import "AlertShower.h"
#import <LiKitIAP/LiKitIAP.h>
#import "LiPromoHelperViews.h"
#import "LiUserLocation.h"

@implementation MainViewController

/*
 view Did Load method
 presenet Loading screen in the Framework still initialized itself
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([LiKitIAP liKitIAPLoaded]){
        //Remove indicator
        LiActivityIndicator *activityView = (LiActivityIndicator *)[self.view viewWithTag:kActivityViewTag];
        [activityView removeFromSuperview];
        LiUserLocation *userLocation = [[LiUserLocation alloc] init];
        [userLocation updateCurrentUserToCurrentLocation_Auto:FALSE DesireAccuracy:kCLLocationAccuracyBest DistanceFilter:0 WithBlock:^(NSError *error, CLLocation *location, Actions action) {
            if (error)
                DDLogInfo(@"Update user location failed %@",error.localizedDescription);
        }];
    } else {
        [[LiActivityIndicator startAnimatingOnView:self.view] setLabelText:@"loading..."];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark LoginViewControllerDelegate methods
#pragma mark -

- (void)loginViewControllerDidCancel:(LoginViewController *)controller {
    // Handle dismissing LoginViewController when user taps "Login Later"
    DDLogInfo(@"doing cancel delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginViewControllerDidLogin:(LoginViewController *)controller {
    // Handle post-login actions & dismissal
    DDLogInfo(@"doing loggedIn delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
    [AlertShower showAlertWithMessage:@"Logged In" OnViewController:self];

}

- (void)loginViewControllerDidRegister:(LoginViewController *)controller{
    DDLogInfo(@"doing register delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
    [AlertShower showAlertWithMessage:@"Registered Successfully" OnViewController:self];
}

#pragma mark -
#pragma mark StoreViewControllerDelegate methods
#pragma mark -

- (void)storeViewControllerDidGoBack:(StoreViewController *)controller {
    // Handle dismissing StoreViewController when user taps back button
    DDLogInfo(@"doing goBack delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark prepareForSegue
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"loginSegue"]) {
		DDLogInfo(@"doing login segue");
        LoginViewController *loginModal = segue.destinationViewController;
        loginModal.delegate = self;
	}
    else if ([segue.identifier isEqualToString:@"storeSegue"]) {
        DDLogInfo(@"doing store segue");
        StoreViewController *storeModal = segue.destinationViewController;
        storeModal.delegate = self;
    }
}

@end
