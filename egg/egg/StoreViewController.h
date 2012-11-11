//
//  StoreViewController.h
//  egg
//
//  Created by Bob Waycott on 10/30/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreViewController;

@protocol StoreViewControllerDelegate <NSObject>

// handles StoreViewController interactions
- (void) storeViewControllerDidGoBack:(StoreViewController*)controller;
- (void) storeViewControllerDidChangeSection:(StoreViewController*)controller;

@end


@interface StoreViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSMutableArray *collectionItems;
    NSMutableDictionary *cachedImages;
    BOOL isDisplayingVirtualGoods;
    BOOL isDisplayingVirtualCurrency;
    BOOL isDisplayingUserInventory;
}

// properties
@property (nonatomic, weak) id <StoreViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *collectionItems;
@property (nonatomic, strong) NSMutableDictionary *cachedImages;

// IBOutlets
@property (nonatomic, weak) IBOutlet UICollectionView *storeItemView;
@property (nonatomic, weak) IBOutlet UIButton *btnVirtualItems;
@property (nonatomic, weak) IBOutlet UIButton *btnMyItems;
@property (nonatomic, weak) IBOutlet UIButton *btnBuyCoins;
@property (nonatomic, strong) IBOutlet UILabel *coinTotal;

// actions for storyboard
- (IBAction)goBack:(id)sender;
- (IBAction)changeSection:(id)sender;

// other actions
- (void)loadImagesForItems;
- (void)updateCoinTotal;
- (void)setActiveStoreSection:(id)sender;
- (void)cacheImageWithRemoteURL:(NSURL*)imageURL;
- (UIImage*)getImageWithRemoteURL:(NSURL*)imageURL;

@end
