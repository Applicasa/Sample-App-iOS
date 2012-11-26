//
//  ViewController.h
//  egg
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "FindFriendsViewController.h"
#import "StoreViewController.h"

@interface ViewController : UIViewController <LoginViewControllerDelegate, StoreViewControllerDelegate, FindFriendsViewControllerDelegate>

@end
