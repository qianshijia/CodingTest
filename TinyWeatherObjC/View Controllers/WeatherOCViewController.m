//
//  WeatherOCViewController.m
//  TinyWeather
//
//  Created by Shijia Qian on 27/11/2015.
//  Copyright © 2015 Eric Qian. All rights reserved.
//

#import "WeatherOCViewController.h"
#import "WeatherAPIManagerOC.h"
#import "LocationManagerOC.h"

@interface WeatherOCViewController () <LocationManagerOCProtocol> {
    BOOL _isShowingCelsius;
    BOOL _labelAnimated;
}

@property (weak, nonatomic) IBOutlet UILabel *tinyWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tinyWeatherLabelCenterVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tinyWeatherLabelTopSpaceConstraint;

@property (nonatomic, strong) CurrentWeatherInfoModelOC *weatherInfo;
@property (nonatomic, strong) WeatherAPIManagerOC *apiManager;

@end

@implementation WeatherOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LocationManagerOC sharedManager].delegate = self;
    [[LocationManagerOC sharedManager] startUpdatingLocation];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTemperatureLabel:)];
    [self.temperatureLabel addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location Manager Delegate
- (void)didUpdateLocationWithLat:(double)latitude andLong:(double)longitude
{
    [[LocationManagerOC sharedManager] stop];
    [self sendAPIRequestWithLat:latitude andLong:longitude];
}

- (void)didFailToGetLocation
{
    [self showErrorAlertWithMessage:@"Get Location Fail" actionButtonTitle:nil andAction:nil];
}

#pragma mark - API request
- (void)sendAPIRequestWithLat:(double)latitude andLong:(double)longitude
{
    WeatherAPIRequestOC *request = [[WeatherAPIRequestOC alloc] initWithLat:[NSString stringWithFormat:@"%lf", latitude] andLong:[NSString stringWithFormat:@"%lf", longitude]];
    [self.apiManager getWeatherInfoWithRequest:request
                                       success:^(CurrentWeatherInfoModelOC * _Nonnull response) {
                                           self.weatherInfo = response;
                                           _isShowingCelsius = YES;
                                           [self setUpLabelWithModel:response isCelsius:_isShowingCelsius];
                                           [self animateLabels];
                                       }
                                       failure:^(NSError * _Nullable error) {
                                           [self showErrorAlertWithMessage:@"Get Weather Fail" actionButtonTitle:@"Retry" andAction:^{
                                               [self sendAPIRequestWithLat:latitude andLong:longitude];
                                           }];
                                       }];
    
}

#pragma mark - Tap Gesture
- (void)didTapOnTemperatureLabel:(UITapGestureRecognizer * _Nonnull)gesture
{
    if (self.weatherInfo) {
        _isShowingCelsius = !_isShowingCelsius;
        [self setUpLabelWithModel:self.weatherInfo isCelsius:_isShowingCelsius];
    }
}

- (void)setUpLabelWithModel:(CurrentWeatherInfoModelOC * _Nonnull)model isCelsius:(BOOL)isCelsius
{
    self.summaryLabel.text = model.summary;
    NSString *temperature = isCelsius ? model.temperatureCelsius: model.temperatureFahrenheit;
    self.temperatureLabel.text = [NSString stringWithFormat:@"%@ %@", temperature, isCelsius ? @"C": @"F"];
}

#pragma mark - Getter
- (WeatherAPIManagerOC *)apiManager
{
    if (!_apiManager) {
        _apiManager = [[WeatherAPIManagerOC alloc] initWithBaseURLString:@"https://api.forecast.io"];
    }
    return _apiManager;
}

#pragma mark - Status Bar Style
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Show Error
-(void)showErrorAlertWithMessage:(NSString * _Nonnull)message actionButtonTitle:(NSString * _Nullable)buttonTitle andAction:(void (^ _Nullable)())alertAction
{
    NSString *btnTitle = buttonTitle ? buttonTitle: @"OK";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tiny Weather"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:btnTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         if (alertAction) {
                                                             alertAction();
                                                         }
                                                     }]];
    [self showViewController:alertController sender:nil];
}

#pragma mark - Animation
- (void)animateLabels
{
    if (!_labelAnimated) {
        _labelAnimated = YES;
        self.tinyWeatherLabelCenterVerticalConstraint.priority = 500;
        self.tinyWeatherLabelTopSpaceConstraint.priority = 900;
        [UIView animateWithDuration:1.f
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5f
                                              animations:^{
                                                  self.tinyWeatherLabel.alpha = 0.f;
                                              }
                                              completion:^(BOOL finished) {
                                                  self.tinyWeatherLabel.hidden = YES;
                                                  self.summaryLabel.hidden = NO;
                                                  self.temperatureLabel.hidden = NO;
                                              }];
                         }];
        
    }
}

@end
