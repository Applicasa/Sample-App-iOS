//
//  LiKitIAPDelegate.h
//  Applicasa
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum LiCurrency {
    MainCurrency = 1,
    SecondaryCurrency
    }LiCurrency;

@class VirtualCurrency;
@protocol LiKitIAPDelegate <NSObject>

@optional 

- (void) InAppPurchase_ValidatedVirtualCurrencys:(NSArray *)items;

- (void) InAppPurchase_LoadVirtualCurrencysFinishedWithArray:(NSArray *)array;

//Purchase AppStore Item
- (void) InAppPurchase_AppStorePurchase:(VirtualCurrency *)item ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage;


@end
