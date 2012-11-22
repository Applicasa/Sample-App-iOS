//
//  LoginViewController.h
//  egg
//
//  Created by Bob Waycott on 10/29/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>
// delegate for handling login controller actions
- (void) loginViewControllerDidCancel:(LoginViewController*)controller;
- (void) loginViewControllerDidLogin:(LoginViewController*)controller;
- (void) loginViewControllerDidRegister:(LoginViewController*)controller;

@end

@interface LoginViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

}

// properties
@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UITextField *inputUsername;
@property (nonatomic, weak) IBOutlet UITextField *inputPassword;

// actions for storyboard
- (IBAction)cancel:(id)sender;
- (IBAction)loggedIn:(id)sender;

@end
