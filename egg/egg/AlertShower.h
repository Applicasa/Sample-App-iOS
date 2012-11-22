//
//  AlertShower.h
//  egg
//
//  Created by admin on 11/22/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertShower : NSObject

+ (void) showAlertWithMessage:(NSString *)message OnViewController:(UIViewController *)viewController;

@end
