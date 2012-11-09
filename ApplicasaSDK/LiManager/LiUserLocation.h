//
// LiUserLocation.h
// Created by Applicasa 
// 8/31/2012
//
#import <Foundation/Foundation.h>
#import <LiCore/LiCore.h>
#import "LiBlockQuery.h"

typedef void (^LiBlockLocationAction)(NSError *error, CLLocation *location,Actions action);

@interface LiUserLocation : NSObject <LiCoreLocationDelegate,LiCoreUpdateLocationDelegate>
@property (nonatomic, assign) LiBlockLocationAction locationAction;

- (void) getCurrentLocationWithBlock:(LiBlockLocationAction)block;
- (void) updateCurrentUserToCurrentLocation_Auto:(BOOL)automatically DesireAccuracy:(CLLocationAccuracy)desireAccuracy DistanceFilter:(CLLocationDistance)distanceFilter WithBlock:(LiBlockLocationAction)block;
- (void) stopAutoUpdate;

@end
