//
//  StoreViewController.h
//  egg
//
//  Created by Applicasa
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiPromo.h"

@class StoreViewController;

@protocol StoreViewControllerDelegate <NSObject>

// handles StoreViewController interactions
- (void) storeViewControllerDidGoBack:(StoreViewController*)controller;

@end

#import "LiPromo.h"

@interface StoreViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LiKitPromotionsDelegate> {
    NSMutableArray *collectionItems;
    BOOL isDisplayingVirtualGoods;
    BOOL isDisplayingVirtualCurrency;
    BOOL isDisplayingUserInventory;
}

// properties
@property (nonatomic, weak) id <StoreViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *collectionItems;

// IBOutlets
@property (nonatomic, weak) IBOutlet UICollectionView *storeItemView;
@property (nonatomic, weak) IBOutlet UIButton *btnVirtualItems;
@property (nonatomic, weak) IBOutlet UIButton *btnMyItems;
@property (nonatomic, weak) IBOutlet UIButton *btnBuyCoins;
@property (nonatomic, strong) IBOutlet UILabel *coinTotal;

// actions for storyboard
- (IBAction)goBack:(id)sender;
- (IBAction)changeSection:(id)sender;

// method to call the StoreVC from other classes
- (void)updateBalanceLabel;

@end
