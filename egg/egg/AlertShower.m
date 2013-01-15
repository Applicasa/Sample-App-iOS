//
//  AlertShower.m
//  egg
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "AlertShower.h"

@implementation AlertShower

+ (void) showAlertWithMessage:(NSString *)message onViewController:(UIViewController *)viewController{
    // Shows a simple alert message that fades away after 3-second delay.
    UILabel *thankYouLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, viewController.view.frame.size.width, 100)];
    [thankYouLabel setText:message];
    [thankYouLabel setTextColor:[UIColor whiteColor]];
    [thankYouLabel setBackgroundColor:[UIColor blackColor]];
    [thankYouLabel setTextAlignment:NSTextAlignmentCenter];
    [thankYouLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [thankYouLabel setNumberOfLines:0];
    [thankYouLabel setAlpha:1];
    [viewController.view addSubview:thankYouLabel];
    
    [UIView beginAnimations:@"removeLabel" context:nil];
    [UIView setAnimationDuration:3];
    [thankYouLabel setAlpha:0];
    [UIView commitAnimations];
    [thankYouLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3.01];
}

@end
