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
#import "IAP.h"
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
    promotion.block(LiPromotionActionCancel,0,nil);
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
    __block LiPromotionAction promoAction = LiPromotionActionPressed;
    __block id info = nil;
    __block LiPromotionResult result = LiPromotionTypeNothing;
    BOOL respondNow = TRUE;
    LiBlockAction actionBlock = ^(NSError *error, NSString *itemID, Actions action) {
        if (error){
            NSLog(@"Commit Promotion Action Failed With Error %@",error);
            result = 0;
            promoAction = LiPromotionActionFailed;
            info = error;
        }
    };
    switch (promotion.promotionActionKind) {
        case LiPromotionTypeLink:{
            /*LiWebView *webView = [[LiWebView alloc] initWithFrame:self.frame];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dictionary objectForKey:@"link"]]]];
            [[self superview] addSubview:webView];*/
            info = [NSURL URLWithString:[dictionary objectForKey:@"link"]];
            [[UIApplication sharedApplication] openURL:info];
            result = LiPromotionResultLinkOpened;
        }
            break;
        case LiPromotionTypeString:{
            info = [dictionary objectForKey:@"string"];
            result = LiPromotionResultStringInfo;
        }
            break;
        case LiPromotionTypeGiveVirtualCurrency:{
            NSInteger amount = [[dictionary objectForKey:@"amount"] integerValue];
            info = [NSNumber numberWithInt:amount];
            LiCurrency currencyKind = [[dictionary objectForKey:@"virtualCurrencyKind"] integerValue];
            result = (currencyKind == MainCurrency)?LiPromotionResultGiveMainCurrencyVirtualCurrency:LiPromotionResultGiveSecondaryCurrencyVirtualCurrency;
            respondNow = FALSE;
            [IAP giveVirtualCurrency:amount CurrencyKind:currencyKind WithBlock:actionBlock];
        }
            break;
        case LiPromotionTypeGiveVirtualGood:{
            NSString *vgID = [dictionary objectForKey:@"_id"];
            info = [self getVirtualGoodByID:vgID IsDeal:FALSE];
            result = LiPromotionResultGiveVirtualGood;
            respondNow = FALSE;
            [IAP giveVirtualGood:info Quantity:1 WithBlock:actionBlock];
        }
            break;
        case LiPromotionTypeOfferDealVC:{
            NSString *vcID = [dictionary objectForKey:@"_id"];
            NSLog(@"responds %d",[self respondsToSelector:@selector(getVirtualCurrencyByID:)]);
            info = [self getVirtualCurrencyByID:vcID];
            result = LiPromotionResultDealVirtualCurrency;
            respondNow = FALSE;
            [IAP buyVirtualCurrency:info WithBlock:actionBlock];
        }
            break;
        case LiPromotionTypeOfferDealVG:{
            NSString *vgID = [dictionary objectForKey:@"_id"];
            info = [self getVirtualGoodByID:vgID IsDeal:TRUE];
            LiCurrency currencyKind = MainCurrency;
            if ([(VirtualGood *)info virtualGoodMainCurrency] == 0)
                currencyKind = SecondaryCurrency;
            result = LiPromotionResultDealVirtualGood;
            respondNow = FALSE;
            [IAP buyVirtualGood:info Quantity:1 CurrencyKind:currencyKind WithBlock:actionBlock];
        }
            break;
        default:
            //nothing...
            break;
    }
    [LiKitPromotions promo:promotion ButtonClicked:TRUE CancelButton:FALSE];
    if (respondNow){
        promotion.block(promoAction,result,info);
    }
}



@end
