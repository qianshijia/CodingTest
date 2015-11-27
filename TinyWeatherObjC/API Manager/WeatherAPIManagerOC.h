//
//  WeatherAPIManager.h
//  TinyWeather
//
//  Created by Shijia Qian on 27/11/2015.
//  Copyright © 2015 Eric Qian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentWeatherInfoModelOC.h"

@interface WeatherAPIRequestOC : NSObject

@property (nonatomic, copy, readonly) NSString * _Nonnull APIPath;

- (instancetype _Nonnull)initWithLat:(NSString * _Nonnull)latitude andLong:(NSString * _Nonnull)longitude;

@end

@interface WeatherAPIManagerOC : NSObject

@property (nonatomic, copy, readonly) NSString * _Nonnull baseURLString;

- (instancetype _Nonnull)initWithBaseURLString:(NSString * _Nonnull)baseURLStr;

- (void)getWeatherInfoWithRequest:(WeatherAPIRequestOC * _Nonnull)request
                          success:(void (^ _Nullable)(CurrentWeatherInfoModelOC * _Nonnull response))success
                          failure:(void (^ _Nullable)(NSError * _Nullable error))failure;

@end
