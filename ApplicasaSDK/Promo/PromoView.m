//
//  PromoView.m
//  LiCore
//
//  Created by Applicasa
//  Copyright (c) 2012 LiCore All rights reserved.
//

#import "PromoView.h"
#import "VirtualGood.h"
#import "LiPromoHelperViews.h"
#import "VirtualCurrency.h"
#import <LiKitIAP/LiKitIAP.h>
#import <LiKitPromotions/LiKitPromotions.h>
#import <LiCore/LiCore.h>

#define kCancelButtonTag 1
#define kActionButtonTag 2

@interface PromoView()

- (void) defaultAction;
- (VirtualCurrency *) getVirtualCurrencyByID:(NSString *)ID;
- (VirtualGood *) getVirtualGoodByID:(NSString *)ID IsDeal:(BOOL)isDeal;
- (void) closeAction;
- (IBAction) promoButtonPressed:(UIButton *)sender;

@end

@implementation PromoView
@synthesize promotion;

#pragma mark - UI Builder

+ (PromoView *) promoViewWithPromotion:(Promotion *)promotion Frame:(CGRect)frame{
    PromoView *view = [[PromoView alloc] initWithFrame:frame];
    view.promotion = promotion;
    [view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *bgImageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    [bgImageView setUserInteractionEnabled:TRUE];
    [bgImageView setContentMode:UIViewContentModeScaleAspectFit];
    [bgImageView setBackgroundColor:[UIColor clearColor]];
    [view addSubview:bgImageView];
    [view sendSubviewToBack:bgImageView];
    
    UIButton *closeButton = [[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-60, 15, 40, 40)] autorelease];
    [closeButton setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton setBackgroundColor:[UIColor clearColor]];
    [closeButton addTarget:view action:@selector(promoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.tag = kCancelButtonTag;
    [view addSubview:closeButton];
    
    UIButton *actionButton = [[[UIButton alloc] initWithFrame:CGRectMake((frame.size.width/10)*3, (frame.size.height/10)*8, (frame.size.width/10)*4, (frame.size.height/10)*2)] autorelease];
    [actionButton addTarget:view action:@selector(promoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [actionButton setBackgroundColor:[UIColor clearColor]];
    actionButton.tag = kActionButtonTag;
    [view addSubview:actionButton];
    
    LiActivityIndicator *bgActivity = [LiActivityIndicator startAnimatingOnView:bgImageView];
    
    [[promotion promotionImage] getCachedImageWithBlock:^(NSError *error, UIImage *image) {
        [bgImageView setImage:image];
        [bgActivity stopAndRemove];
    }];
    
    [[promotion promotionButton] getCachedImageWithBlock:^(NSError *error, UIImage *image) {
        CGRect rect = actionButton.frame;
        rect.size.width = (image.size.width)/2;
        rect.size.height = (image.size.height)/2;
        rect.origin.x = (view.frame.size.width-rect.size.width)/2;
        
        [actionButton setFrame:rect];
        [actionButton setImage:image forState:UIControlStateNormal];
    }];
    
    return [view autorelease];
}

- (IBAction) promoButtonPressed:(UIButton *)sender{
    if (sender.tag == kCancelButtonTag){
        [self closeAction];
    } else if (sender.tag == kActionButtonTag){
        [self defaultAction];
    }
    [self removeFromSuperview];
}

#pragma mark - Close Button

- (void) closeAction{
    [LiKitPromotions promo:promotion ButtonClicked:FALSE CancelButton:TRUE];
}

#pragma mark - Action Button

- (VirtualGood *) getVirtualGoodByID:(NSString *)ID IsDeal:(BOOL)isDeal{
    NSArray *items = isDeal?[LiKitIAP virtualGoodDeals]:[LiKitIAP virtualGoods];
    for (VirtualGood *virtualGood in items) {
        if ([virtualGood.virtualGoodID isEqualToString:ID])
            return virtualGood;
    }
    return nil;
}

- (VirtualCurrency *) getVirtualCurrencyByID:(NSString *)ID{
    NSArray *items = [LiKitIAP virtualCurrencyDeals];
    for (VirtualCurrency *virtualCurrency in items) {
        if ([virtualCurrency.virtualCurrencyID isEqualToString:ID])
            return virtualCurrency;
    }
    return nil;
    
}

- (void) defaultAction{
    NSDictionary *dictionary = [promotion.promotionActionData liJSONValue];
    switch (promotion.promotionActionKind) {
        case LiPromotionTypeLink:{
            LiWebView *webView = [[LiWebView alloc] initWithFrame:self.frame];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dictionary objectForKey:@"link"]]]];
            [[self superview] addSubview:webView];
        }
            break;
        case LiPromotionTypeString:{
            NSString *string = [dictionary objectForKey:@"string"];
            NSLog(@"string is %@",string);
        }
            break;
        case LiPromotionTypeGiveVirtualCurrency:{
            NSInteger amount = [[dictionary objectForKey:@"amount"] integerValue];
            LiCurrency currencyKind = [[dictionary objectForKey:@"virtualCurrencyKind"] integerValue];
            NSError *error = nil;
            [LiKitIAP giveAmount:amount CurrencyKind:currencyKind WithError:&error];
            if (error)
                NSLog(@"Give Amount Failed With Error %@",error);
        }
            break;
        case LiPromotionTypeGiveVirtualGood:{
            NSString *vgID = [dictionary objectForKey:@"_id"];
            VirtualGood *vg = [self getVirtualGoodByID:vgID IsDeal:FALSE];
            NSError *error = nil;
            [LiKitIAP giveVirtualGood:vg Quantity:1 WithError:&error];
            if (error)
                NSLog(@"Give Virtual Good Failed With Error %@",error);
        }
            break;
        case LiPromotionTypeOfferDealVC:{
            NSString *vcID = [dictionary objectForKey:@"_id"];
            NSLog(@"responds %d",[self respondsToSelector:@selector(getVirtualCurrencyByID:)]);
            VirtualCurrency *vc = [self getVirtualCurrencyByID:vcID];
            [LiKitIAP purchaseVirtualCurrency:vc Delegate:nil];
        }
            break;
        case LiPromotionTypeOfferDealVG:{
            NSString *vgID = [dictionary objectForKey:@"_id"];
            VirtualGood *vg = [self getVirtualGoodByID:vgID IsDeal:TRUE];
            NSError *error = nil;
            LiCurrency currencyKind = MainCurrency;
            if (vg.virtualGoodMainCurrency == 0)
                currencyKind = SecondaryCurrency;
            [LiKitIAP purchaseVirtualGood:vg Quantity:1 CurrencyKind:currencyKind WithError:&error];
            if (error)
                NSLog(@"Purchase Virtual Good Failed With Error %@",error);
        }
            break;
        default:
            //nothing...
            break;
    }
    [LiKitPromotions promo:promotion ButtonClicked:TRUE CancelButton:FALSE];
}



@end
