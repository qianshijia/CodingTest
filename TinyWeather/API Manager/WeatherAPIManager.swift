//
//  WeatherAPIManager.swift
//  TinyWeather
//
//  Created by Eric Qian on 26/11/2015.
//  Copyright © 2015 Eric Qian. All rights reserved.
//

import Foundation

struct WeatherAPIRequest {
    let APIKey = "b34898f66f4edd80f7b91fbd41d457e4"
    let path = "forecast"
    var latitude: String
    var longitude: String
    var APIPath: String {
        get {
            return "/" + path + "/" + APIKey + "/" + latitude + "," + longitude
        }
    }
    
    init(lat: String, long: String) {
        latitude = lat
        longitude = long
    }
}

class WeatherAPIManager
{
    var baseURLString: String
    
    init(baseURL: String) {
        baseURLString = baseURL
    }
    
    func getWeatherInfo(withRequest request: WeatherAPIRequest,
        success: (responseObject: CurrentWeatherInfoModel?) -> Void,
        failure: (error: NSError?) -> Void) {
            let session = NSURLSession.sharedSession()
            if let requestURL = NSURL(string: baseURLString + request.APIPath) {
                let dataTask = session.dataTaskWithURL(requestURL) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    if let localError = error {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            failure(error: localError)
                        })
                    } else {
                        if let responseData = data {
                            // got response data
                            do {
                                if let jsonResponse = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject] {
                                    let WeatherModel = CurrentWeatherInfoModel(responseData: jsonResponse)
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        success(responseObject: WeatherModel)
                                    })
                                } else {
                                    let localError = NSError(domain: "Invalid JSON response", code: 998, userInfo: nil)
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        failure(error: localError)
                                    })
                                }
                            } catch {
                                let localError = NSError(domain: "Invalid JSON response", code: 998, userInfo: nil)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    failure(error: localError)
                                })
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // no response data
                                success(responseObject: nil)
                            })
                        }
                    }
                    
                }
                dataTask.resume()
            } else {
                let localError = NSError(domain: "Invalid URL", code: 999, userInfo: nil)
                failure(error: localError)
            }
    }
}