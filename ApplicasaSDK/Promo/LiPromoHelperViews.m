//
//  LiWebView.m
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import "LiPromoHelperViews.h"

@implementation LiWebView

- (void) hideLiWebView{
    [self removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-40, 20, 40, 40)];
        [closeButton setTitle:@"X" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeButton setBackgroundColor:[UIColor blackColor]];
        [closeButton addTarget:self action:@selector(hideLiWebView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        [closeButton release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

@implementation LiActivityIndicator

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:[UIColor blackColor]];
    [self setAlpha:0.6];
    self.tag = kActivityViewTag;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [indicator setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [indicator setCenter:self.center];
    [indicator setBackgroundColor:[UIColor blackColor]];
    [indicator startAnimating];

    [self addSubview:indicator];
    //[indicator release];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*4/5, frame.size.width, frame.size.width*1/5)];
    [loadingLabel setText:@"Loading..."];
    [loadingLabel setTag:1];
    [loadingLabel setFont:[UIFont systemFontOfSize:loadingLabel.frame.size.height-1]];
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [loadingLabel setBackgroundColor:[UIColor blackColor]];
    [loadingLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:loadingLabel];
    [loadingLabel release];
    
    return self;
}

- (void) setLabelText:(NSString *)text{
    if (text)
        [(UILabel *)[self viewWithTag:1] setText:text];
    else
        [[self viewWithTag:1] removeFromSuperview];
}

+ (id) startAnimatingOnView:(UIView *)view{
    float width = view.frame.size.width;
    float height = view.frame.size.height;

    if (width == 0)
        width = 50;
    
    if (height == 0)
        height = 50;
    
    LiActivityIndicator *indicatorView = [[LiActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, width, height)];

    //[indicatorView setCenter:[view center]];
    [view addSubview:indicatorView];
    [view bringSubviewToFront:indicatorView];
   
    return [indicatorView autorelease];
}

- (void) stopAndRemove{
    [self removeFromSuperview];
}


@end
