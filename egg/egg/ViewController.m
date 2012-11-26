//
//  ViewController.m
//  egg
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

/*
 ViewController Calss Do nothing but being a main view
 that allows the user to naigate its way
 */

#import "ViewController.h"
#import "AlertShower.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark FindFriendsViewControllerDelegate methods
- (void)findFriendsViewControllerDidGoBack:(FindFriendsViewController *)controller {
    // Handle dismissing FindFriendsViewController when user taps back button
    DDLogInfo(@"doing goBack delegate action for FindFriends");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark LoginViewControllerDelegate methods
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

#pragma mark StoreViewControllerDelegate methods
- (void)storeViewControllerDidGoBack:(StoreViewController *)controller {
    // Handle dismissing StoreViewController when user taps back button
    DDLogInfo(@"doing goBack delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark prepareForSegue
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
    else if ([segue.identifier isEqualToString:@"findFriendsSegue"]) {
        DDLogInfo(@"doing findFriends segue");
        FindFriendsViewController *findFriendsModal = segue.destinationViewController;
        findFriendsModal.delegate = self;
    }
}

@end
