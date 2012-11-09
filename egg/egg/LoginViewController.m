//
//  LoginViewController.m
//  egg
//
//  Created by Bob Waycott on 10/29/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom init stuff
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"login view did load");
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions for Delegate
- (IBAction)cancel:(id)sender {
    NSLog(@"delegate said cancel. Dismissing...");
    [self.delegate loginViewControllerDidCancel:self];
}

- (IBAction)loggedIn:(id)sender {
    NSLog(@"delegate said loggedIn. Dismissing...");
    [self.delegate loginViewControllerDidLogin:self];
}

@end
