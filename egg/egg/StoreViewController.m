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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Helper methods
- (void)btnBuyTapped:(id)sender {
    UIButton *buyButton = (UIButton*)sender;
    if (isDisplayingVirtualGoods) {
        NSLog(@"buying item: %@", [collectionItems objectAtIndex:buyButton.tag]);
        [IAP buyVirtualGood:[collectionItems objectAtIndex:buyButton.tag] Quantity:1 CurrencyKind:MainCurrency WithBlock:^(NSError *error, NSString *itemID, Actions action) {
            if (error == nil) {
                // purchase success
                [self updateBalanceLabel];
            }
            else {
                NSLog(@"Purchase Error: %@", error);
            }
        }];
    }
    else if (isDisplayingVirtualCurrency) {
        NSLog(@"buying item: %@", [collectionItems objectAtIndex:buyButton.tag]);
        [IAP buyVirtualCurrency:[collectionItems objectAtIndex:buyButton.tag] WithBlock:^(NSError *error, NSString *itemID, Actions action) {
            if (error == nil) {
                // purchase success
                [self updateBalanceLabel];
            }
            else {
                NSLog(@"Purchase Error: %@", error);
            }
        }];
    }
    else if (isDisplayingUserInventory) {
        [IAP useVirtualGood:[collectionItems objectAtIndex:buyButton.tag] Quantity:1 WithBlock:^(NSError *error, NSString *itemID, Actions action) {
            if (error == nil) {
                // used inventory item
                NSLog(@"Used inventory item: %@", [[collectionItems objectAtIndex:buyButton.tag] virtualGoodTitle]);
                [IAP getAllVirtualGoodWithType:Non_0_Quantity WithBlock:^(NSError *error, NSArray *array) {
                    [collectionItems setArray:array];
                    [self loadImagesForItems];
                }];
                [self.storeItemView reloadData];
            }
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
    self.coinTotal.text = [NSString stringWithFormat:@"%d", [IAP getCurrentUserMainBalance]];
}

- (void)setActiveStoreSection:(id)sender {
    // set state of storeItemView
    NSParameterAssert([sender isKindOfClass:[UIButton class]]);
    if (sender == btnVirtualItems) {
        isDisplayingVirtualGoods = YES;
        isDisplayingVirtualCurrency = NO;
        isDisplayingUserInventory = NO;
        [btnVirtualItems setSelected:YES];
        [btnMyItems setSelected:NO];
        [btnBuyCoins setSelected:NO];
    }
    else if (sender == btnBuyCoins) {
        isDisplayingVirtualGoods = NO;
        isDisplayingVirtualCurrency = YES;
        isDisplayingUserInventory = NO;
        [btnVirtualItems setSelected:NO];
        [btnMyItems setSelected:NO];
        [btnBuyCoins setSelected:YES];
    }
    else if (sender == btnMyItems) {
        isDisplayingVirtualGoods = NO;
        isDisplayingVirtualCurrency = NO;
        isDisplayingUserInventory = YES;
        [btnVirtualItems setSelected:NO];
        [btnMyItems setSelected:YES];
        [btnBuyCoins setSelected:NO];
    }
}

- (void)cacheImageWithRemoteURL:(NSURL*)imageURL {
    /* 
        PROBLEM:
        Loading images directly via URL does not cache by default & scrolling is just awful.
        This means that every time a reusable cell scrolls out of the collectionview visible area,
        it is dequeued and re-downloaded the next time the images come into view. This makes for
        rather abysmal scrolling performance (at least on the iPhone 4).
        
        SOLUTION: 
        Create a custom local cache of the image objects so once they're loaded, scrolling
        is as smooth as can be.
    */
    if (![cachedImages objectForKey:[imageURL absoluteString]]) {
        // We only want to fetch & cache the image if it does not exist
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        [cachedImages setObject:image forKey:[imageURL absoluteString]];
    }
}

- (UIImage*)getImageWithRemoteURL:(NSURL*)imageURL {
    // Gets cached image from cachedImages dictionary
    return [cachedImages objectForKey:[imageURL absoluteString]];
}


#pragma mark IBActions for Delegate
- (IBAction)goBack:(id)sender {
    NSLog(@"delegate said goBack. Dismissing...");
    [self.delegate storeViewControllerDidGoBack:self];
}

- (IBAction)changeSection:(id)sender {
    NSLog(@"delegate said changeSection. Updating button state...");
    NSParameterAssert([sender isKindOfClass:[UIButton class]]);
    [self setActiveStoreSection:sender];
    if ([sender isKindOfClass:[UIButton class]]) {
        if (isDisplayingVirtualGoods) {
            [IAP getAllVirtualGoodWithType:All WithBlock:^(NSError *error, NSArray *array) {
                [collectionItems setArray:array];
                [self loadImagesForItems];
            }];
        }
        else if (isDisplayingUserInventory) {
            [btnVirtualItems setSelected:NO];
            [btnMyItems setSelected:YES];
            [btnBuyCoins setSelected:NO];
            [IAP getAllVirtualGoodWithType:Non_0_Quantity WithBlock:^(NSError *error, NSArray *array) {
                [collectionItems setArray:array];
                [self loadImagesForItems];
            }];
        }
        else if (isDisplayingVirtualCurrency) {
            [btnVirtualItems setSelected:NO];
            [btnMyItems setSelected:NO];
            [btnBuyCoins setSelected:YES];
            [IAP getAllVirtualCurrenciesWithBlock:^(NSError *error, NSArray *array) {
                [collectionItems setArray:array];
                [self loadImagesForItems];
            }];
        }
    }
    [self.storeItemView reloadData];
}

#pragma mark UICollectionView datasource methods
- (NSInteger)collectionView:(UICollectionView *)storeView numberOfItemsInSection:(NSInteger)section {
    // simple count of the collectionItems
    NSLog(@"Number of items in section: %d", [collectionItems count]);
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
    
}

- (void)collectionView:(UICollectionView *)storeView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect the item (might not need this for our purposes)
}

- (CGSize)collectionView:(UICollectionView *)storeView layout:(UICollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 125);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)storeView layout:(UICollectionViewLayout *)layout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
