//
//  FBFriendCell.m
//  egg
//
//  Created by Benny Davidovitz on 1/7/13.
//  Copyright (c) 2013 Applicasa. All rights reserved.
//

#import "FBFriendCell.h"
#import "User.h"

@implementation FBFriendCell
@synthesize imageView,nameLabel,inviteButton;

static UIImage *addImage = nil;
static UIImage *addedImage = nil;

- (IBAction)inviteAction:(id)sender {
    UITableView *myTableView = (UITableView *)[self superview];
    id<UITableViewDelegate> tableViewDelegate = myTableView.delegate;
    NSIndexPath *myIndexPath = [myTableView indexPathForCell:self];
    [tableViewDelegate tableView:myTableView didSelectRowAtIndexPath:myIndexPath];
}

- (void) loadImageViewWithURL:(NSURL *)url{
    @autoreleasepool {
        [url getCachedImageWithBlock:^(NSError *error, UIImage *image) {
            if (!error)
                [imageView setImage:image];
        }];
    }
}


- (void) setCellContenetWithLiObjFBFriend:(LiObjFBFriend *)liObjFBFriend{
    [self performSelectorInBackground:@selector(loadImageViewWithURL:) withObject:liObjFBFriend.facebookImage];
    
    [nameLabel setText:liObjFBFriend.facebookName];
    
    if (liObjFBFriend.user.userID == nil){
        if (!addImage)
            addImage = [UIImage imageNamed:@"add"];
        [inviteButton setImage:addImage forState:UIControlStateNormal];
    } else {
        if (!addedImage)
            addedImage = [UIImage imageNamed:@"added"];
        [inviteButton setImage:addedImage forState:UIControlStateNormal];
    }
}

@end
