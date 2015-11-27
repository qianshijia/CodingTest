//
//  LocationManagerOC.h
//  TinyWeather
//
//  Created by Shijia Qian on 27/11/2015.
//  Copyright © 2015 Eric Qian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerOCProtocol <NSObject>

- (void)didUpdateLocationWithLat:(double)latitude andLong:(double)longitude;
- (void)didFailToGetLocation;

@end

@interface LocationManagerOC : NSObject

@property (nonatomic, weak) id<LocationManagerOCProtocol> _Nullable delegate;
@property (nonatomic, strong, readonly) CLLocation * _Nullable lastKnownLocation;

+ (instancetype _Nonnull)sharedManager;

- (void)startUpdatingLocation;
- (void)stop;

@end
