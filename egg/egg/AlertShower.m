//
//  AlertShower.m
//  egg
//
//  Created by admin on 11/22/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "AlertShower.h"

@implementation AlertShower

+ (void) showAlertWithMessage:(NSString *)message OnViewController:(UIViewController *)viewController{
    UILabel *thankYouLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 100)];
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
