//
//  CurrentWeatherInfoModelOC.h
//  TinyWeather
//
//  Created by Shijia Qian on 27/11/2015.
//  Copyright © 2015 Eric Qian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentWeatherInfoModelOC : NSObject

@property (nonatomic, copy, readonly) NSString * _Nullable summary;
@property (nonatomic, copy, readonly) NSString * _Nullable temperatureCelsius;
@property (nonatomic, copy, readonly) NSString * _Nullable temperatureFahrenheit;

- (instancetype _Nonnull)initWithResponseData:(NSDictionary * _Nonnull)responseData;

@end
