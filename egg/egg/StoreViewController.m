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

@implementation StoreViewController
@synthesize collectionItems,
            btnBuyCoins,
            btnMyItems,
            btnVirtualItems;

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
    self.collectionItems = [[NSMutableArray alloc] init];
    [self.storeItemView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"storeCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateCollectionItems:(NSArray *)newItems {
    [collectionItems setArray:newItems];
}

#pragma mark IBActions for Delegate
- (IBAction)goBack:(id)sender {
    NSLog(@"delegate said goBack. Dismissing...");
    [self.delegate storeViewControllerDidGoBack:self];
}

- (IBAction)changeSection:(id)sender {
    NSLog(@"delegate said changeSection. Updating button state...");
    NSParameterAssert([sender isKindOfClass:[UIButton class]]);
    if ([sender isKindOfClass:[UIButton class]]) {
        NSLog(@"###### INSIDE BUTTON PRESS METHOD, CALLING IAP CLASS #######");
        if (sender == btnVirtualItems) {
            // virtual goods
            [btnVirtualItems setSelected:YES];
            [btnMyItems setSelected:NO];
            [btnBuyCoins setSelected:NO];
            [IAP getAllVirtualGoodWithType:All WithBlock:^(NSError *error, NSArray *array) {
                NSLog(@"set collectionItems");
                [collectionItems setArray:array];
            }];
            NSLog(@"IAP Goods count: %d", [collectionItems count]);
        }
        else if (sender == btnMyItems) {
            // user inventory
            [btnVirtualItems setSelected:NO];
            [btnMyItems setSelected:YES];
            [btnBuyCoins setSelected:NO];
            [IAP getAllVirtualGoodWithType:Non_0_Quantity WithBlock:^(NSError *error, NSArray *array) {
                NSLog(@"set collectionItems");
                [collectionItems setArray:array];
            }];
            NSLog(@"IAP Inventory Count: %d", [collectionItems count]);
        }
        else if (sender == btnBuyCoins) {
            // virtual currency
            [btnVirtualItems setSelected:NO];
            [btnMyItems setSelected:NO];
            [btnBuyCoins setSelected:YES];
            [IAP getAllVirtualCurrenciesWithBlock:^(NSError *error, NSArray *array) {
                NSLog(@"set collectionItems");
                [self.collectionItems setArray:array];
            }];
            NSLog(@"IAP currency count: %d", [collectionItems count]);
        }
    }
}

#pragma mark UICollectionView datasource methods
- (NSInteger)collectionView:(UICollectionView *)storeView numberOfItemsInSection:(NSInteger)section {
    // simple count of the collectionItems
    return [collectionItems count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)storeView {
    // this is hard-coded because we have 3 buttons (virtual items, my items, & buy coins)
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)storeView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [storeView dequeueReusableCellWithReuseIdentifier:@"storeCell" forIndexPath:indexPath];
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
    return CGSizeMake(200, 200);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)storeView layout:(UICollectionViewLayout *)layout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
