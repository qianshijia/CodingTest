//
//  WeatherAPIManager.m
//  TinyWeather
//
//  Created by Shijia Qian on 27/11/2015.
//  Copyright © 2015 Eric Qian. All rights reserved.
//

#import "WeatherAPIManagerOC.h"

@implementation WeatherAPIRequestOC

static NSString *const APIKey = @"b34898f66f4edd80f7b91fbd41d457e4";
static NSString *const path = @"forecast";

- (instancetype)initWithLat:(NSString *)latitude andLong:(NSString *)longitude
{
    if (self = [super init]) {
        _APIPath = [NSString stringWithFormat:@"/%@/%@/%@,%@", path, APIKey, latitude, longitude];
    }
    return self;
}

@end

@implementation WeatherAPIManagerOC

- (instancetype)initWithBaseURLString:(NSString *)baseURLStr
{
    if (self = [super init]) {
        _baseURLString = [baseURLStr copy];
    }
    return self;
}

- (void)getWeatherInfoWithRequest:(WeatherAPIRequestOC *)request
                          success:(void (^)(CurrentWeatherInfoModelOC * _Nonnull))success
                          failure:(void (^)(NSError * _Nullable))failure
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseURLString, request.APIPath]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:requestURL
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                if (error) {
                                                    if (failure) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            failure(error);
                                                        });
                                                    }
                                                } else {
                                                    BOOL errored = YES;
                                                    if (data) {
                                                        NSError *parseError;
                                                        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                     options:NSJSONReadingAllowFragments
                                                                                                                       error:&parseError];
                                                        if (!parseError) {
                                                            errored = NO;
                                                            CurrentWeatherInfoModelOC *responseModel = [[CurrentWeatherInfoModelOC alloc] initWithResponseData:responseJSON];
                                                            if (success) {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    success(responseModel);
                                                                });
                                                            }
                                                        }
                                                    }
                                                    if (errored) {
                                                        if (failure) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                failure([NSError errorWithDomain:@"Invalid JSON response" code:998 userInfo:nil]);
                                                            });
                                                        }
                                                    }
                                                }
                                            }];
    [dataTask resume];
}


@end
