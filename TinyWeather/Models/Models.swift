//
//  Models.swift
//  TinyWeather
//
//  Created by Eric Qian on 26/11/2015.
//  Copyright © 2015 Eric Qian. All rights reserved.
//

import Foundation

protocol ModelProtocol {
    init(responseData: [String: AnyObject])
}

struct CurrentWeatherInfoModel: ModelProtocol {
    var summary = ""
    var temperatureCelsius = ""
    var temperatureFahrenheit = ""
    init(responseData: [String : AnyObject]) {
        if let currentWeather = responseData["currently"] as? [String : AnyObject] {
            summary = currentWeather["summary"] as! String
            let temperature = currentWeather["temperature"] as! NSNumber
            temperatureFahrenheit = String(format: "%.1f", temperature.floatValue)
            let temperatureC = (temperature.floatValue - 32) / 1.8
            temperatureCelsius = String(format: "%.1f", temperatureC)
        }
    }
}