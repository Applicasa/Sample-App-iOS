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

@implementation StoreViewController
@synthesize coinTotal,
            collectionItems,
            cachedImages,
            btnBuyCoins,
            btnMyItems,
            btnVirtualItems,
            storeItemView;

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
    collectionItems = [[NSMutableArray alloc] init];
    cachedImages = [[NSMutableDictionary alloc] init];
    storeItemView.backgroundView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iapBgContent@2x.png"]];
    [self activateVirtualGoodsDisplay];
    [self updateStoreItemViewData];
    [self.storeItemView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Helper methods
- (void)updateStoreItemViewData {
    // Checks for active store section & loads data & images for collection view
    if (isDisplayingVirtualGoods) {
        [IAP getAllVirtualGoodWithType:All WithBlock:^(NSError *error, NSArray *array) {
            [collectionItems setArray:array];
            [self loadImagesForItems];
        }];
    }
    else if (isDisplayingUserInventory) {
        [IAP getAllVirtualGoodWithType:Non_0_Quantity WithBlock:^(NSError *error, NSArray *array) {
            [collectionItems setArray:array];
            [self loadImagesForItems];
        }];
    }
    else if (isDisplayingVirtualCurrency) {
        [IAP getAllVirtualCurrenciesWithBlock:^(NSError *error, NSArray *array) {
            [collectionItems setArray:array];
            [self loadImagesForItems];
        }];
    }
}

- (void)loadImagesForItems {
    // update collectionItems for storeItemView cells & cache images
    if ([collectionItems count] != 0) {
        [collectionItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (isDisplayingVirtualGoods) {
                [self cacheImageWithRemoteURL:[obj virtualGoodImageA]];
            }
            else if (isDisplayingVirtualCurrency) {
                [self cacheImageWithRemoteURL:[obj virtualCurrencyImageA]];
            }
            else if (isDisplayingUserInventory) {
                [self cacheImageWithRemoteURL:[obj virtualGoodImageA]];
            }
        }];
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
        }
        else {
            // purchased failed
            DDLogError(@"Purchase Error: %@", error);
        }
    }];
}

- (void)buyVirtualCurrency:(id)obj {
    // generic helper for buying currency
    [IAP buyVirtualCurrency:obj WithBlock:^(NSError *error, NSString *itemID, Actions action) {
        if (error == nil) {
            // purchase success
            DDLogWarn(@"Bought item: %@; added %d to User's balance", [obj virtualCurrencyTitle], [obj virtualCurrencyCredit]);
            [self updateBalanceLabel];
        }
        else {
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
            [IAP getAllVirtualGoodWithType:Non_0_Quantity WithBlock:^(NSError *error, NSArray *array) {
                [collectionItems setArray:array];
                [self loadImagesForItems];
            }];
            [self.storeItemView reloadData];
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
    [btnVirtualItems setSelected:YES];
    [btnMyItems setSelected:NO];
    [btnBuyCoins setSelected:NO];
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
    [btnMyItems setSelected:YES];
    [btnBuyCoins setSelected:NO];
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
}

#pragma mark Image-handling methods
- (void)cacheImageWithRemoteURL:(NSURL*)imageURL {
    /* 
        PROBLEM:
        Every time a reusable cell scrolls out of the collectionview visible area, it is
        dequeued and re-loaded the next time the images come into view. This makes for
        rather abysmal scrolling performance (at least on the iPhone 4).
        
        SOLUTION: 
        Create a custom local cache of the image objects so once they're loaded, scrolling
        is as smooth as can be.
     
        NOTE:
        This isn't necessarily a recommended practice. It's only used to make things smoother
        in the sample app. Your needs will likely vary.
    */
    if (![cachedImages objectForKey:[imageURL absoluteString]]) {
        // We only want to fetch & cache the image if it does not exist
        [imageURL getCachedImageWithBlock:^(NSError *error, UIImage *image) {
            // getting cached image from Applicasa & storing in local cache on view controller
            [cachedImages setObject:image forKey:[imageURL absoluteString]];
        }];
    }
}

- (UIImage*)getImageWithRemoteURL:(NSURL*)imageURL {
    // Gets cached image from cachedImages dictionary
    return [cachedImages objectForKey:[imageURL absoluteString]];
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
    if ([sender isKindOfClass:[UIButton class]]) {
        [self updateStoreItemViewData];
    }
    [self.storeItemView reloadData];
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
    if (isDisplayingVirtualGoods) {
        // Customize cell for displaying virtual goods
        [cell setImage:[self getImageWithRemoteURL:[[collectionItems objectAtIndex:indexPath.row] virtualGoodImageA]]];
        [cell.btnBuy addTarget:self action:@selector(btnBuyTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnBuy.tag = indexPath.row;
        [cell.btnBuy setTitle:[NSString stringWithFormat:@"%d coins",
                               [[collectionItems objectAtIndex:indexPath.row] virtualGoodMainCurrency]]
                     forState:UIControlStateNormal];
    }
    else if (isDisplayingVirtualCurrency) {
        // Customize cell for displaying virtual currencies
        [cell setImage:[self getImageWithRemoteURL:[[collectionItems objectAtIndex:indexPath.row] virtualCurrencyImageA]]];
        [cell.btnBuy addTarget:self action:@selector(btnBuyTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnBuy.tag = indexPath.row;
        [cell.btnBuy setTitle:[NSString stringWithFormat:@"$%g",
                               [[collectionItems objectAtIndex:indexPath.row] virtualCurrencyPrice]]
                     forState:UIControlStateNormal];
    }
    else if (isDisplayingUserInventory) {
        // Customize cell for displaying virtual goods
        [cell setImage:[self getImageWithRemoteURL:[[collectionItems objectAtIndex:indexPath.row] virtualGoodImageA]]];
        [cell.btnBuy addTarget:self action:@selector(btnBuyTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnBuy.tag = indexPath.row;
        [cell.btnBuy setTitle:[NSString stringWithFormat:@"%d",
                               [[collectionItems objectAtIndex:indexPath.row] virtualGoodUserInventory]]
                     forState:UIControlStateNormal];
    }
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
