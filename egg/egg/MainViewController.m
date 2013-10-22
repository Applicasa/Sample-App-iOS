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
#import "IAP.h"
#import "LiPromoHelperViews.h"
#import "LiUserLocation.h"
#import "User.h"
#import "LiLog.h"

@interface MainViewController ()

- (void) refreshProfileIcons;

@end

@implementation MainViewController
@synthesize spendProfileImageView,usageProfileImageView;
/*
 view Did Load method
 presenet Loading screen if the Framework still initialized itself
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    LiActivityIndicator *activity = [LiActivityIndicator startAnimatingOnView:self.view sizeFactor:1];
    [activity setLabelText:@"loading..."];
    [activity setUserInteractionEnabled:TRUE];
}

- (void) viewDidAppear:(BOOL)animated{
    [LiKitPromotions setLiKitPromotionsDelegate:self];
    [self refreshProfileIcons];
    [super viewDidAppear:animated];
}

- (void) dismissLoadingScreen{
    //Remove indicator
    LiActivityIndicator *activityView = (LiActivityIndicator *)[self.view viewWithTag:kActivityViewTag];
    [activityView removeFromSuperview];
    [self performSelectorOnMainThread:@selector(updateCurrentUserLocation) withObject:nil waitUntilDone:FALSE];
    [self performSelectorOnMainThread:@selector(refreshProfileIcons) withObject:nil waitUntilDone:FALSE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Profile Data

- (void) updateSpendingProfileImage:(LiSpendingProfile)profile{
    if (spendProfileImageView.tag == profile)
        return;
    
    NSString *imageName = @"";
    switch (profile) {
        case LiSpendingProfileRockefeller:
            imageName = @"profileRockfeller";
            break;
        case LiSpendingProfileTaxPayer:
            imageName = @"profileTaxpayer";
            break;
        case LiSpendingProfileTourist:
            imageName = @"profileTurist";
            break;
        case LiSpendingProfileZombie:
            imageName = @"profileZombie";
            break;
        default:
            break;
    }
    
    [spendProfileImageView setImage:[UIImage imageNamed:imageName]];
    [spendProfileImageView setTag:profile];
}

- (void) updateUsageProfileImage:(LiUsageProfile)profile{
    if (usageProfileImageView.tag == profile)
        return;
    
    NSString *imageName = @"";
    switch (profile) {
        case LiUsageProfileGeneral:
            imageName = @"rankGeneral";
            break;
        case LiUsageProfileSergeant:
            imageName = @"rankSergeant";
            break;
        case LiUsageProfilePrivate:
            imageName = @"rankPrivate";
            break;
        case LiUsageProfileCivilan:
            imageName = @"rankHippie";
            break;
        default:
            break;
    }
    
    [usageProfileImageView setImage:[UIImage imageNamed:imageName]];
    [usageProfileImageView setTag:profile];
}




- (void) refreshProfileIcons{
    LiSpendingProfile spendingProfile = [User getCurrentSpendingProfile];
    LiUsageProfile usageProfile = [User getCurrentUsageProfile];
    
    [self updateSpendingProfileImage:spendingProfile];
    [self updateUsageProfileImage:usageProfile];
}

#pragma mark - Update user location

- (void) updateCurrentUserLocation{
    LiUserLocation *userLocation = [[LiUserLocation alloc] init];
    [userLocation updateLocationWithAccuracy:kCLLocationAccuracyBest distanceFilter:1000 andBlock:^(NSError *error, CLLocation *location, Actions action) {
        if (error)
            LiLogSampleApp(@"Failed to upload location: %@",error.localizedDescription);
        else
            LiLogSampleApp(@"Update to location: %@",location);
    }];
}

#pragma mark -
#pragma mark Raise Custom event method
#pragma mark -
/**
 
 Method to raise custom events.
 The "Egg" sample app implemented custom events that will raise the different ad network possible (TrialPay, MMedia, SupersonicAds, SponsorPay Appnext and Chartboost)
 
 To raise different AdNetwork just change the name of the customEvent belos.
 use the the following names to raise the different ad network:
 
 1. TrialPay:
 A. MainCurrency ------------------->OfferwallMainCurrency
 B. SecondaryCurrency -------------->OfferwallSecondaryCurrency
 2. Millennial Media ------------------>@"MMedia"
 3. SupersonicAds
 A. SupersonicAds BrandConnect ----->@"SuperSonicBrand"
 B. SupersonicAds offerwall -------->@"SuperSonic"
 3. SponsorPay
 A. SponsorPay BrandEngage --------->@"SponsorPayBrand"
 B. SponsorPay offerwall ----------->@"SponsorPay"
 4.Appnext ---------------------------->@"Appnext"
 5.Chartboost ------------------------->@"Chartboost"
 
 *note, you should also view implementations of "liKitPromotionsAvailable"
 
 
 
 */
- (IBAction)raiseCustomPromotion:(id)sender {
    [LiPromo raiseCustomEventByName:@"MMedia"];
}

#pragma mark -
#pragma mark LiKitPromotionsDelegate method
#pragma mark -

- (void) liKitPromotionsAvailable:(NSArray *)promotions{
    if ([promotions count] == 0)return;
    Promotion *promo = [promotions objectAtIndex:0];{
        [promo showOnView:self.view Block:^(LiPromotionAction promoAction, LiPromotionResult result, id info) {
            
            switch (result) {
                case LiPromotionResultGiveMainCurrencyVirtualCurrency:{
                    [AlertShower showAlertWithMessage:[NSString stringWithFormat:@"Reward %@ Coins",info] onViewController:self];
                }
                    break;
                    
                    /*
                     In case the promoAction comes from one of this AdNetwork, we check if the result is success, 
                     If so, We ask for ThirdPartyAction, This call checks if the server received a callback from one of these adnetworks
                     and return and update the User for any currency he should recieve.
                     */
                case LiPromotionResultSponsorPay:
                case LiPromotionResultSupersonicAds:
                case LiPromotionResultTrialPay:
                    LiLogSampleApp(@"Response %@",info);
                    [LiKitPromotions getThirdPartyActions:^(NSError *error, NSArray *thirdpartyResponse) {
                        if (!error)
                            NSLog(@"Received %i actions from server",[thirdpartyResponse count]);
                    }];
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
    LiLogSampleApp(@"doing cancel delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginViewControllerDidLogin:(LoginViewController *)controller {
    // Handle post-login actions & dismissal
    LiLogSampleApp(@"doing loggedIn delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
    [AlertShower showAlertWithMessage:@"Logged In" onViewController:self];
    
}

- (void)loginViewControllerDidRegister:(LoginViewController *)controller{
    LiLogSampleApp(@"doing register delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
    [AlertShower showAlertWithMessage:@"Registered Successfully" onViewController:self];
    [self updateCurrentUserLocation];
}

#pragma mark -
#pragma mark StoreViewControllerDelegate methods
#pragma mark -

- (void)storeViewControllerDidGoBack:(StoreViewController *)controller {
    // Handle dismissing StoreViewController when user taps back button
    LiLogSampleApp(@"doing goBack delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark NearbyFriendsViewController methods
#pragma mark -

- (void)nearbyFriendsViewControllerDidGoBack:(NearbyFriendsViewController *)controller{
    // Handle dismissing StoreViewController when user taps back button
    LiLogSampleApp(@"doing goBack delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark NearbyFriendsViewController methods
#pragma mark -

- (void)facebookFeatureViewControllerViewControllerDidGoBack:(FacebookFeatureViewController *)controller{
    // Handle dismissing StoreViewController when user taps back button
    LiLogSampleApp(@"doing goBack delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark prepareForSegue
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"loginSegue"]) {
		LiLogSampleApp(@"doing login segue");
        LoginViewController *loginModal = segue.destinationViewController;
        loginModal.delegate = self;
	}
    else if ([segue.identifier isEqualToString:@"storeSegue"]) {
        LiLogSampleApp(@"doing store segue");
        StoreViewController *storeModal = segue.destinationViewController;
        storeModal.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"nearByFriendsSegueue"]){
        LiLogSampleApp(@"doing findFriends segue");
        NearbyFriendsViewController *nearbyFriendsViewController = segue.destinationViewController;
        nearbyFriendsViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"facebookFeatureSegue"] && [[User getCurrentUser] userIsRegisteredFacebook]){
        LiLogSampleApp(@"doing facebookFeature segue");
        FacebookFeatureViewController *facebookFeatureViewController = segue.destinationViewController;
        facebookFeatureViewController.delegate = self;
    }
}


-(IBAction) onLogout:(id)sender
{
    [User logoutWithBlock:^(NSError *error, NSString *itemID, Actions action) {
       if (error)
       {
          LiLogSampleApp(@"Logout failed");
       }
       else
       {
           LiLogSampleApp(@"Logout succesfully");
       }
    }];
}
@end
