//
//  AlertShower.h
//  egg
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertShower : NSObject

+ (void) showAlertWithMessage:(NSString *)message OnViewController:(UIViewController *)viewController;

@end
