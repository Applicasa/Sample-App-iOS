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
#import "NearbyFriendsViewController.h"
#import "LiPromo.h"

@interface MainViewController : UIViewController <LoginViewControllerDelegate, StoreViewControllerDelegate,NearbyFriendsViewControllerDelegate,LiKitPromotionsDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *spendProfileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *usageProfileImageView;



- (void) dismissLoadingScreen;

@end
