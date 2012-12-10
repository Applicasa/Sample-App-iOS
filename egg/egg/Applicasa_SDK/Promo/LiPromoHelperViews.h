//
//  LiWebView.h
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import <UIKit/UIKit.h>
#define kActivityViewTag 999

@interface LiWebView : UIWebView

@end

@interface LiActivityIndicator : UIView

+ (id) startAnimatingOnView:(UIView *)view;
- (void) stopAndRemove;
- (void) setLabelText:(NSString *)text;

@end