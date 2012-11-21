//
// User+Location.m
// Created by Applicasa 
// 8/31/2012
//

#import "LiUserLocation.h"

@implementation LiUserLocation
@synthesize locationAction;

- (void) getCurrentLocationWithBlock:(LiBlockLocationAction)block{
    [LiCore getCurrentLocation:self];
}

- (void) updateCurrentUserToCurrentLocation_Auto:(BOOL)automatically DesireAccuracy:(CLLocationAccuracy)desireAccuracy DistanceFilter:(CLLocationDistance)distanceFilter WithBlock:(LiBlockLocationAction)block{
    [LiCore setDesireAccuracy:desireAccuracy];
    [LiCore setDistanceFilter:distanceFilter];
    self.locationAction = Block_copy(block);
    if (automatically){
        [LiCore startUpdatingUserLocationWithDelegate:self];
    } else {
        [LiCore updateUserLocation:self];
    }
}

- (void) stopAutoUpdate{
    [LiCore stopUpdatingUserLocation];
}

#pragma mark - LiCore Location Delegate
- (void) LiCoreDidFinishGetCurrentLocation:(CLLocation *)location Error:(NSError *)error{
    self.locationAction(error,location,GetLocation);
}

#pragma mark - LiCore Update Location Delegate

- (void) LiCoreDidFailToUpdateLocation:(NSError *)error{
    self.locationAction(error,nil,UpdateLocation);
}

- (void) LiCoreDidUpdateLocation:(CLLocation *)location{
    self.locationAction(nil,location,UpdateLocation);
}

@end
