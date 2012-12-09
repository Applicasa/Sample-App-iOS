//
//  User+DisplayName.m
//  egg
//
//  Created by Benny Davidovitz on 12/4/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import "User+DisplayName.h"

@implementation User (DisplayName)

- (NSString *) displayName{
    if (self.userFirstName.length || self.userLastName.length)
        return [NSString stringWithFormat:@"%@ %@",self.userFirstName,self.userLastName];
    
    if (self.userName.length)
        return self.userName;
    return @"no-name";
}

@end
