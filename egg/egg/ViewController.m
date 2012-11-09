//
//  ViewController.m
//  egg
//
//  Created by Bob Waycott on 10/29/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "ViewController.h"

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

#pragma mark LoginViewControllerDelegate methods
- (void)loginViewControllerDidCancel:(LoginViewController *)controller {
    // Handle dismissing LoginViewController when user taps "Login Later"
    NSLog(@"doing cancel delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginViewControllerDidLogin:(LoginViewController *)controller {
    // Handle post-login actions & dismissal
    NSLog(@"doing loggedIn delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark StoreViewControllerDelegate methods
- (void)storeViewControllerDidGoBack:(StoreViewController *)controller {
    // Handle dismissing StoreViewController when user taps back button
    NSLog(@"doing goBack delegate action");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) storeViewControllerDidChangeSection:(StoreViewController *)controller {
    // Handle changing StoreViewController sections (for collection view)
    NSLog(@"doing changeSection action");
    [controller.storeItemView reloadData];
}

#pragma mark prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"loginSegue"]) {
		NSLog(@"doing login segue");
        LoginViewController *loginModal = segue.destinationViewController;
        loginModal.delegate = self;
	}
    else if ([segue.identifier isEqualToString:@"storeSegue"]) {
        NSLog(@"doing store segue");
        StoreViewController *storeModal = segue.destinationViewController;
        storeModal.delegate = self;
    }
}

@end
