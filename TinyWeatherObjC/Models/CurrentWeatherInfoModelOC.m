//
//  CurrentWeatherInfoModelOC.m
//  TinyWeather
//
//  Created by Shijia Qian on 27/11/2015.
//  Copyright © 2015 Eric Qian. All rights reserved.
//

#import "CurrentWeatherInfoModelOC.h"

@implementation CurrentWeatherInfoModelOC

- (instancetype _Nonnull)initWithResponseData:(NSDictionary * _Nonnull)responseData
{
    if (self = [super init]) {
        NSDictionary *currentWeather = responseData[@"currently"];
        _summary = currentWeather[@"summary"];
        NSNumber *temperature = currentWeather[@"temperature"];
        _temperatureFahrenheit = [NSString stringWithFormat:@"%02.f", temperature.floatValue];
        _temperatureCelsius = [NSString stringWithFormat:@"%02.f", (temperature.floatValue - 32) / 1.8];
    }
    return self;
}

@end
