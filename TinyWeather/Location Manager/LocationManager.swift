//
//  LocationManager.swift
//  TinyWeather
//
//  Created by Eric Qian on 26/11/2015.
//  Copyright © 2015 Eric Qian. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    func didUpdateLocation(lat: Double, long: Double)
    func didFailToGetLocation()
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    //MARK: - Shared manager
    static let sharedManager = LocationManager()
    
    private var locationManager: CLLocationManager
    var delegate: LocationManagerProtocol?
    var lastKnownLocation: CLLocation?
    
    //MARK: - Initializer
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
    }
    
    //MARK: - Start and stop
    func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        delegate = nil
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: - CLLocationManager Delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let del = delegate, loc = locations.last {
            lastKnownLocation = loc
            del.didUpdateLocation(loc.coordinate.latitude, long: loc.coordinate.longitude)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if let del = delegate {
            del.didFailToGetLocation()
        }
    }
    
}