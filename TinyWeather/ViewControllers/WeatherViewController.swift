//
//  WeatherViewController.swift
//  TinyWeather
//
//  Created by Eric Qian on 26/11/2015.
//  Copyright © 2015 Eric Qian. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController, LocationManagerProtocol {
    lazy var weatherAPIManager: WeatherAPIManager = WeatherAPIManager(baseURL: "https://api.forecast.io")
    var isShowingCelsius = true
    var labelAnimated = false
    var WeatherInfo: CurrentWeatherInfoModel?
    
    //MARK: - IBOutlets
    @IBOutlet weak var tinyWeatherLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tinyWeatherTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tinyWeatherCenterVerticalConstraint: NSLayoutConstraint!
    
    //MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedManager.delegate = self
        LocationManager.sharedManager.startUpdatingLocation()
        // A tap gestire to switch between celsius and Fahrenheit
        let tapGesture = UITapGestureRecognizer(target: self, action: "didTapOnTemperatureLabel:")
        self.temperatureLabel.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Location manager
    func didUpdateLocation(lat: Double, long: Double) {
        LocationManager.sharedManager.stop()
        sendAPIRequest(withLat: lat, andLong: long)
    }
    
    func didFailToGetLocation() {
        showErrorAlert(withMessage: "Get Location Fail", andButtonTitle: nil, action: nil)
    }
    
    //MARK: - Send API request
    private func sendAPIRequest(withLat lat: Double, andLong long: Double) {
        let apiRequest = WeatherAPIRequest(lat: "\(lat)", long: "\(long)")
        weatherAPIManager.getWeatherInfo(withRequest: apiRequest,
            success: { (responseObject: CurrentWeatherInfoModel?) -> Void in
                if let response = responseObject {
                    self.WeatherInfo = response
                    self.setUpLabel(withModel: response, isCelsius: self.isShowingCelsius)
                    self.animateLabels()
                }
            }) { (error: NSError?) -> Void in
                self.showErrorAlert(withMessage: "Get Weather Fail", andButtonTitle: "Retry") { () -> Void in
                        self.sendAPIRequest(withLat: lat, andLong: long)
                }
        }
    }
    
    //MARK: - Tap Gesture
    @objc private func didTapOnTemperatureLabel(gesture: UITapGestureRecognizer) {
        if let model = WeatherInfo {
            isShowingCelsius = !isShowingCelsius
            setUpLabel(withModel: model, isCelsius: isShowingCelsius)
        }
    }
    
    //MARK: - Helper
    private func setUpLabel(withModel model: CurrentWeatherInfoModel, isCelsius: Bool) {
        self.summaryLabel.text = model.summary
        let temperature = isCelsius ? model.temperatureCelsius : model.temperatureFahrenheit
        self.temperatureLabel.text = temperature + (isCelsius ? " C" : " F")
    }
    
    private func animateLabels() {
        if (!labelAnimated) {
            labelAnimated = true
            self.tinyWeatherCenterVerticalConstraint.priority = 500
            self.tinyWeatherTopConstraint.priority = 900
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }) { (completed) -> Void in
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.tinyWeatherLabel.alpha = 0
                        }) { (completed) -> Void in
                            self.tinyWeatherLabel.hidden = true
                            self.summaryLabel.hidden = false
                            self.temperatureLabel.hidden = false
                    }
            }
        }
    }
    
    private func showErrorAlert(withMessage message: String, andButtonTitle title: String?, action: (() -> Void)?) {
        let buttonTitle = title == nil ? "OK" : title!
        let alertView = UIAlertController(title: "Tiny Weather", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default) { (_) -> Void in
            if let act = action {
                act()
            }
        })
        showViewController(alertView, sender: nil)
    }
    
    //MARK: - Status bar style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}