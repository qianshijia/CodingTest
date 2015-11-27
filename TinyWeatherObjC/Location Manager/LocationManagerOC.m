//
//  LocationManagerOC.m
//  TinyWeather
//
//  Created by Shijia Qian on 27/11/2015.
//  Copyright © 2015 Eric Qian. All rights reserved.
//

#import "LocationManagerOC.h"

@interface LocationManagerOC() <CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
}

@end

@implementation LocationManagerOC

+ (instancetype _Nonnull)sharedManager
{
    static LocationManagerOC *shared;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shared = [[LocationManagerOC alloc] init];
    });
    return shared;
}

- (instancetype)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.delegate = self;
    }
    return self;
}

- (void)startUpdatingLocation
{
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}

- (void)stop
{
    self.delegate = nil;
    [_locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = [locations lastObject];
    if (self.delegate && loc) {
        _lastKnownLocation = loc;
        [self.delegate didUpdateLocationWithLat:loc.coordinate.latitude andLong:loc.coordinate.longitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.delegate) {
        [self.delegate didFailToGetLocation];
    }
}

@end
