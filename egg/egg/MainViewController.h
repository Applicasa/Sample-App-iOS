//
//  ViewController.h
//  egg
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "StoreViewController.h"
#import "LiPromo.h"

@interface MainViewController : UIViewController <LoginViewControllerDelegate, StoreViewControllerDelegate,LiKitPromotionsDelegate>

- (void) dismissLoadingScreen;

@end
