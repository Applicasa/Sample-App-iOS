//
//  LoginViewController.m
//  egg
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

/*
 LoginViewController
 
 Shows primary Applicasa SDK/framework methods used to handle users
 
 Includes:
 - Registering users
 - Login via Applicasa's user management
 - Login via Facebook
 
 Other methods that Applicasa provide but not implemented here:
 - Logout users via Applicasa or Facebook
 - Update username
 - Update password
 - Forgot password
 
 */

#import "LoginViewController.h"
#import "User+Facebook.h"
#import "AlertShower.h"
#import "LiPromo.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize delegate,inputPassword,inputUsername;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom init stuff
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DDLogInfo(@"login view did load");
    [LiPromo setLiKitPromotionsDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBActions
#pragma mark -

- (IBAction)cancel:(id)sender {
    DDLogInfo(@"delegate said cancel. Dismissing...");
    [self.delegate loginViewControllerDidCancel:self];
}

- (IBAction)loggedIn:(id)sender {
    // Authenticate user via Applicasa's user management features.
    // Returns result or error in a block for additional processing.
    [User loginWithUsername:inputUsername.text andPassword:inputPassword.text withBlock:^(NSError *error, NSString *itemID, Actions action) {
        if (!error){
            DDLogInfo(@"delegate said loggedIn. Dismissing...");
            [self.delegate loginViewControllerDidLogin:self];
        } else {
            [AlertShower showAlertWithMessage:[NSString stringWithFormat:@"Login Failed\n%@",error.localizedDescription] onViewController:self];
        }
    }];
}

- (IBAction)registerUser:(id)sender{
    /*
     
     Registers users via Applicasa with the username/password inputs.
     
     If desired, we could further modify the user with additional
     information, such as email address, gender, etc. using the
     User class/instance methods.
     
     Returns result or error in a block that allows for additional processing.
     
     */
    User *currentUser = [LiCore getCurrentUser];
    [currentUser registerUsername:inputUsername.text andPassword:inputPassword.text withBlock:^(NSError *error, NSString *itemID, Actions action) {
        if (!error){
            [self.delegate loginViewControllerDidRegister:self];
        } else {
            [AlertShower showAlertWithMessage:error.localizedDescription onViewController:self];
        }
    }];
}

- (IBAction)facebookLogin:(id)sender{
    /*
     
     Uses the Facebook SDK to start a new authenticated session
     if one does not already exist and log FB user in.
     
     Returns result or error in a block that allows for additional processing.
     
     */
    User *currentUser = [LiCore getCurrentUser];
    [currentUser facebookLoginWithBlock:^(NSError *error, NSString *itemID, Actions action) {
        if (!error){
            [self.delegate loginViewControllerDidLogin:self];
        } else {
            [AlertShower showAlertWithMessage:error.localizedDescription onViewController:self];
        }
    }];
}

- (IBAction)hideKeyboard:(id)sender{
    [inputUsername resignFirstResponder];
    [inputPassword resignFirstResponder];
}

@end
