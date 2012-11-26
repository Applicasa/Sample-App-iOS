//
//  LoginViewController.m
//  egg
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

/*
 LoginViewController Class present the main methods of User management in applicasa
 which are:
 Register,
 Login,
 LoginWithFacebook
 
 Other methods that Applicasa provide but we didn't implement here:
 Logout, facebookLogout
 Update username
 Update password
 Forgot password
 */

#import "LoginViewController.h"
#import "User+Facebook.h"
#import "AlertShower.h"

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
    DDLogInfo(@"login view did load");
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions 

- (IBAction)cancel:(id)sender {
    DDLogInfo(@"delegate said cancel. Dismissing...");
    [self.delegate loginViewControllerDidCancel:self];
}

/*
 Login Method
 This method takes the username & password from the UITextFields
 And call for login (sync method)
 
 The login call return the result in the block
 If the error isn't nil logged in succesfuly.
 else, there was an error and we present the error description
 
 */

- (IBAction)loggedIn:(id)sender {
    [User loginUserWithUsername:inputUsername.text Password:inputUsername.text WithBlock:^(NSError *error, NSString *itemID, Actions action) {
        if (!error){
            DDLogInfo(@"delegate said loggedIn. Dismissing...");
            [self.delegate loginViewControllerDidLogin:self];
        } else {
            [AlertShower showAlertWithMessage:[NSString stringWithFormat:@"Login Failed\n%@",error.localizedDescription] OnViewController:self];
        }
    }];
}

/*
 Register Method
 This method takes the username & password from the UITextFields
 And call for regiser (sync method)
 
 We are able to insert more info to ther user
 ect.
 [currentUser setUserPhone:@"055-1234567"];
 
 The regiser call return the result in the block
 If the error isn't nil regisered in succesfuly.
 else, there was an error and we present the error description
 
 */

- (IBAction)registerAction:(id)sender{
    User *currentUser = [LiCore getCurrentUser];
    [currentUser registerUserWithUsername:inputUsername.text Password:inputPassword.text WithBlock:^(NSError *error, NSString *itemID, Actions action) {
        if (!error){
            [self.delegate loginViewControllerDidRegister:self];
        } else {
            [AlertShower showAlertWithMessage:error.localizedDescription OnViewController:self];
        }
    }];
}

/*
 Login with facebook
 
 The method declare in User+Facebook (User category)
 This method open activate the FBSession if its not activate
 You need also to implement the AppDelegate relevant delegate method
 Follow facebook instruction about how to define the app to use facebook oath
 
 The method return the userID in the delegate
 The User instance availble in [User getCurrentUser]
 */

- (IBAction)facebookLogin:(id)sender{
    User *currentUser = [LiCore getCurrentUser];
    [currentUser facebookLoginWithBlock:^(NSError *error, NSString *itemID, Actions action) {
        if (!error){
            [self.delegate loginViewControllerDidLogin:self];
        } else {
            [AlertShower showAlertWithMessage:error.localizedDescription OnViewController:self];
        }
    }];
}

- (IBAction)hideKeyboard:(id)sender{
    [inputUsername resignFirstResponder];
    [inputPassword resignFirstResponder];
}

@end
