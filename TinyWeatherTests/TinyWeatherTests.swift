//
//  TinyWeatherTests.swift
//  TinyWeatherTests
//
//  Created by Shijia Qian on 26/11/2015.
//  Copyright © 2015 Eric Qian. All rights reserved.
//

import XCTest

class TinyWeatherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAPIRequest() {
        let mocLat = "-33.0", mocLong = "150.0"
        let request = WeatherAPIRequest(lat: mocLat, long: mocLong)
        let expectation = "/forecast/b34898f66f4edd80f7b91fbd41d457e4/-33.0,150.0"
        XCTAssert(request.APIPath == expectation)
    }
    
    func testWeatherModel() {
        let mocJSONResponse = ["currently": [
                               "summary": "MockSummary",
                                "temperature": NSNumber(float: 75.0)
            ]]
        let model = CurrentWeatherInfoModel(responseData: mocJSONResponse)
        XCTAssert(model.summary == "MockSummary");
        XCTAssert(model.temperatureFahrenheit == "75.0")
        let temperatureCelsius = (75.0 - 32) / 1.8
        XCTAssert(model.temperatureCelsius == String(format: "%.1f", temperatureCelsius))
    }
}
