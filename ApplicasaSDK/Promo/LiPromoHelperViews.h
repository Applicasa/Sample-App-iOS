//
//  LiWebView.h
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiWebView : UIWebView

@end

@interface LiActivityIndicator : UIView

+ (id) startAnimatingOnView:(UIView *)view;
- (void) stopAndRemove;

@end