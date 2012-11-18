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
    return [super initWithFrame:frame];
}

+ (id) startAnimatingOnView:(UIView *)view{
    CGRect frame = view.frame;
    float height = frame.size.height/2;
    float width = frame.size.width/2;
    
    LiActivityIndicator *indicatorView = [[LiActivityIndicator alloc] initWithFrame:CGRectMake(width/2, height/2, width, height)];
    indicatorView.tag = 3;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setFrame:CGRectMake(0, 0, 100, 100)];
    [indicator setCenter:indicatorView.center];
    [indicatorView addSubview:indicator];
    [indicator release];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(-width/2, height/10*8, width*3, height/10*2)];
    [loadingLabel setText:@"Loading..."];
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [loadingLabel setTextColor:[UIColor blackColor]];
    [indicatorView addSubview:loadingLabel];
    [loadingLabel release];

    [view addSubview:indicatorView];
   
    return [indicatorView autorelease];
}

- (void) stopAndRemove{
    [self removeFromSuperview];
}


@end
