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
 presenet Loading screen if the Framework still initialized itself
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    LiActivityIndicator *activity = [LiActivityIndicator startAnimatingOnView:self.view];
    [activity setLabelText:@"loading..."];
    [activity setUserInteractionEnabled:TRUE];
}

- (void) viewDidAppear:(BOOL)animated{
    [LiKitPromotions setLiKitPromotionsDelegate:self];
    [super viewDidAppear:animated];
}

- (void) updateCurrentUserLocation{
    [[[LiUserLocation alloc] init] updateCurrentUserToCurrentLocation_Auto:FALSE DesireAccuracy:kCLLocationAccuracyBest DistanceFilter:kCLDistanceFilterNone WithBlock:^(NSError *error, CLLocation *location, Actions action) {
        if (error)
            DDLogInfo(@"Failed update current location %@",error.localizedDescription);
    }];
}

- (void) dismissLoadingScreen{
    //Remove indicator
    LiActivityIndicator *activityView = (LiActivityIndicator *)[self.view viewWithTag:kActivityViewTag];
    [activityView removeFromSuperview];
    [self performSelectorOnMainThread:@selector(updateCurrentUserLocation) withObject:nil waitUntilDone:FALSE];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark LiKitPromotionsDelegate method
#pragma mark -

- (void) liKitPromotionsAvailable:(NSArray *)promotions{
    for (Promotion *promo in promotions) {
        [promo showOnView:self.view Block:^(LiPromotionAction promoAction, LiPromotionResult result, id info) {
            if (!promoAction)
                return ;
            
            switch (result) {
                case LiPromotionResultGiveMainCurrencyVirtualCurrency:{
                    [AlertShower showAlertWithMessage:[NSString stringWithFormat:@"Reward %@ Coins",info] onViewController:self];
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }
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
    [AlertShower showAlertWithMessage:@"Logged In" onViewController:self];

}

- (void)loginViewControllerDidRegister:(LoginViewController *)controller{
    DDLogInfo(@"doing register delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
    [AlertShower showAlertWithMessage:@"Registered Successfully" onViewController:self];
    [self updateCurrentUserLocation];
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
