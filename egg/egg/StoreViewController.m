//
//  StoreViewController.m
//  egg
//
//  Created by Bob Waycott on 10/30/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "StoreViewController.h"
#import "User.h"
#import "IAP.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"
#import "VirtualGoodCategory.h"
#import "LiStoreCell.h"
#import "LiPromoHelperViews.h"
#import "AlertShower.h"

@implementation StoreViewController
@synthesize coinTotal,
            collectionItems,
            btnBuyCoins,
            btnMyItems,
            btnVirtualItems,
            storeItemView;

static UIImage *virtualCurrencyImage = nil;
static UIImage *virtualGoodImage = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // custom init
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateBalanceLabel];
    
    if (!virtualCurrencyImage)
        virtualCurrencyImage = [UIImage imageNamed:@"btnBuyCoins"];
    if (!virtualGoodImage)
        virtualGoodImage = [UIImage imageNamed:@"green_btn"];
    
    collectionItems = [[NSMutableArray alloc] init];
    storeItemView.backgroundView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iapBgContent@2x.png"]];
    
    if ([LiKitIAP liKitIAPLoaded]){
        [self setActiveStoreSection:btnVirtualItems];
        //Remove indicator
        LiActivityIndicator *activityView = (LiActivityIndicator *)[self.view viewWithTag:kActivityViewTag];
        [activityView removeFromSuperview];
    } else {
        [[LiActivityIndicator startAnimatingOnView:self.view] setLabelText:nil];
    }
}

#pragma mark Helper methods
- (void)updateStoreItemViewData {
    GetVirtualCurrencyArrayFinished block = ^(NSError *error, NSArray *array) {
        [collectionItems setArray:array];
        [self.storeItemView reloadData];
    };
    
    // Checks for active store section & loads data & images for collection view
    if (isDisplayingVirtualGoods) {
        [IAP getAllVirtualGoodWithType:All WithBlock:block];
    } else if (isDisplayingUserInventory) {
        [IAP getAllVirtualGoodWithType:Non_0_Quantity WithBlock:block];
    } else if (isDisplayingVirtualCurrency) {
        [IAP getAllVirtualCurrenciesWithBlock:block];
    }
}
- (void)updateBalanceLabel {
    // updates User's balance displayed in the top-right corner of the the view
    self.coinTotal.text = [NSString stringWithFormat:@"%d", [IAP getCurrentUserMainBalance]];
}

#pragma mark Give/Buy/Use methods
- (void)buyVirtualGood:(id)obj {
    // generic helper for buying virtual items
    [IAP buyVirtualGood:obj Quantity:1 CurrencyKind:MainCurrency WithBlock:^(NSError *error, NSString *itemID, Actions action) {
        if (error == nil) {
            // purchase success
            DDLogWarn(@"Bought item: %@", [obj virtualGoodTitle]);
            [self updateBalanceLabel];
            [AlertShower showAlertWithMessage:[NSString stringWithFormat:@"Bought %@",[obj virtualGoodTitle]] OnViewController:self];
        }
        else {
            // purchased failed
            DDLogError(@"Purchase Error: %@", error);
            [AlertShower showAlertWithMessage:error.localizedDescription OnViewController:self];
        }
    }];
}

- (void)buyVirtualCurrency:(id)obj {
    // generic helper for buying currency
    LiActivityIndicator *buyingActivity = [LiActivityIndicator startAnimatingOnView:self.view];
    [buyingActivity setLabelText:nil];
    [IAP buyVirtualCurrency:obj WithBlock:^(NSError *error, NSString *itemID, Actions action) {
        [buyingActivity stopAndRemove];
        if (error == nil) {
            // purchase success
            DDLogWarn(@"Bought item: %@; added %d to User's balance", [obj virtualCurrencyTitle], [obj virtualCurrencyCredit]);
            [self updateBalanceLabel];
            [AlertShower showAlertWithMessage:@"Purchase success!" OnViewController:self];
        }
        else {
            [AlertShower showAlertWithMessage:error.localizedDescription OnViewController:self];
            // purchase failed
            DDLogError(@"Purchase Error: %@", error);
        }
    }];
}

- (void)useInventoryItem:(id)obj {
    // generic helper for using inventory
    [IAP useVirtualGood:obj Quantity:1 WithBlock:^(NSError *error, NSString *itemID, Actions action) {
        if (error == nil) {
            // used inventory item
            DDLogVerbose(@"Used inventory item: %@", [obj virtualGoodTitle]);
            [self setActiveStoreSection:btnMyItems];
        }
        else {
            // use failed
            DDLogError(@"Inventory Error: %@", error);
        }
    }];
}



#pragma mark UI state-handling methods
- (void)activateVirtualGoodsDisplay {
    // sets UI for displaying virtual goods
    isDisplayingVirtualGoods = YES;
    isDisplayingVirtualCurrency = NO;
    isDisplayingUserInventory = NO;
    [btnMyItems setSelected:NO];
    [btnBuyCoins setSelected:NO];
    [btnVirtualItems setSelected:YES];
}

- (void)activateVirtualCurrencyDisplay {
    // sets UI for displaying virtual currency
    isDisplayingVirtualGoods = NO;
    isDisplayingVirtualCurrency = YES;
    isDisplayingUserInventory = NO;
    [btnVirtualItems setSelected:NO];
    [btnMyItems setSelected:NO];
    [btnBuyCoins setSelected:YES];
}

- (void)activateUserInventoryDisplay {
    // sets UI for displaying inventory
    isDisplayingVirtualGoods = NO;
    isDisplayingVirtualCurrency = NO;
    isDisplayingUserInventory = YES;
    [btnVirtualItems setSelected:NO];
    [btnBuyCoins setSelected:NO];
    [btnMyItems setSelected:YES];
}

- (void)setActiveStoreSection:(id)sender {
    // set state of storeItemView
    if (sender == btnVirtualItems) {
        [self activateVirtualGoodsDisplay];
    }
    else if (sender == btnBuyCoins) {
        [self activateVirtualCurrencyDisplay];
    }
    else if (sender == btnMyItems) {
        [self activateUserInventoryDisplay];
    }
    
    [self updateStoreItemViewData];
}

#pragma mark Button Action methods
- (void)btnBuyTapped:(id)sender {
    // Responds to blue button tap to buy/use item
    UIButton *buyButton = (UIButton*)sender;
    if (isDisplayingVirtualGoods) {
        DDLogVerbose(@"buying item: %@", [collectionItems objectAtIndex:buyButton.tag]);
        [self buyVirtualGood:[collectionItems objectAtIndex:buyButton.tag]];
    }
    else if (isDisplayingVirtualCurrency) {
        DDLogVerbose(@"buying item: %@", [collectionItems objectAtIndex:buyButton.tag]);
        [self buyVirtualCurrency:[collectionItems objectAtIndex:buyButton.tag]];
    }
    else if (isDisplayingUserInventory) {
        [self useInventoryItem:[collectionItems objectAtIndex:buyButton.tag]];
    }
}

- (IBAction)goBack:(id)sender {
    // Responds to back arrow button tap
    DDLogInfo(@"User said goBack. Dismissing...");
    [self.delegate storeViewControllerDidGoBack:self];
}

- (IBAction)changeSection:(id)sender {
    // Responds to bottom-row button taps (items, inventory, & coins)
    // Sets active store section, fetches section data, and reloads
    DDLogInfo(@"User changed section. Updating store state & data...");
    NSParameterAssert([sender isKindOfClass:[UIButton class]]);
    [self setActiveStoreSection:sender];
}

#pragma mark UICollectionView datasource methods
- (NSInteger)collectionView:(UICollectionView *)storeView numberOfItemsInSection:(NSInteger)section {
    // simple count of the collectionItems
    DDLogVerbose(@"Number of items in section: %d", [collectionItems count]);
    return [collectionItems count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)storeView {
    // this is hard-coded because we have 3 buttons (virtual items, my items, & buy coins)
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)storeView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LiStoreCell *cell = [storeView dequeueReusableCellWithReuseIdentifier:@"storeItemCell" forIndexPath:indexPath];
    int row = indexPath.row;
    id item = [collectionItems objectAtIndex:row];
    NSURL *imageUrl = nil;
    NSString *title = nil;
    cell.infoLabel.hidden = TRUE;
    
    if (isDisplayingVirtualGoods) {
        // Customize cell for displaying virtual goods
        imageUrl = [item virtualGoodImageA];
        title = [NSString stringWithFormat:@"%d",[item virtualGoodMainCurrency]];
        [cell.btnBuy setBackgroundImage:virtualGoodImage forState:UIControlStateNormal];
    } else if (isDisplayingVirtualCurrency) {
        // Customize cell for displaying virtual currencies
        imageUrl = [item virtualCurrencyImageA];
        title = [NSString stringWithFormat:@"$%g",[item virtualCurrencyPrice]];
        [cell setInfoText:[NSString stringWithFormat:@"%d %@",[item virtualCurrencyCredit],([item virtualCurrencyKind]==MainCurrency)?@"Coins":@"Gems"]];
        [cell.btnBuy setBackgroundImage:virtualCurrencyImage forState:UIControlStateNormal];
    } else if (isDisplayingUserInventory) {
        // Customize cell for displaying virtual goods
        imageUrl = [item virtualGoodImageA];
        title = [NSString stringWithFormat:@"%d",[item virtualGoodUserInventory]];
    }
    
    LiActivityIndicator *indicator = (LiActivityIndicator *)[cell viewWithTag:kActivityViewTag];
    if (!indicator){
        indicator = [LiActivityIndicator startAnimatingOnView:cell];
    }
    [imageUrl getCachedImageWithBlock:^(NSError *error, UIImage *image) {
        [indicator stopAndRemove];
        [cell setImage:image];
    }];
    cell.btnBuy.tag = row;
    [cell.btnBuy addTarget:self action:@selector(btnBuyTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnBuy setTitle:title forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark UICollectionView delegate methods
- (void)collectionView:(UICollectionView *)storeView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Select the item & respond
    DDLogInfo(@"Selected storeViewCell");
    if (isDisplayingVirtualGoods) {
        DDLogVerbose(@"buying item: %@", [collectionItems objectAtIndex:indexPath.row]);
        [self buyVirtualGood:[collectionItems objectAtIndex:indexPath.row]];
    }
    else if (isDisplayingVirtualCurrency) {
        DDLogVerbose(@"buying item: %@", [collectionItems objectAtIndex:indexPath.row]);
        [self buyVirtualCurrency:[collectionItems objectAtIndex:indexPath.row]];
    }
    else if (isDisplayingUserInventory) {
        DDLogVerbose(@"using item: %@", [collectionItems objectAtIndex:indexPath.row]);
        [self useInventoryItem:[collectionItems objectAtIndex:indexPath.row]];
    }
    [self.storeItemView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)collectionView:(UICollectionView *)storeView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect the item (might not need this for our purposes)
    DDLogInfo(@"Deselected storeViewCell");
}

- (CGSize)collectionView:(UICollectionView *)storeView layout:(UICollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 125);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)storeView layout:(UICollectionViewLayout *)layout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
