//
//  AppDelegate.h
//  egg
//
//  Created by Applicasa on 10/29/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LiCore/LiCore.h>
#import "LiPromo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, LiCoreInitializeDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void) iapStatus;
@end
