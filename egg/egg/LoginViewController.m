//
//  LoginViewController.m
//  egg
//
//  Created by Bob Waycott on 10/29/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

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
