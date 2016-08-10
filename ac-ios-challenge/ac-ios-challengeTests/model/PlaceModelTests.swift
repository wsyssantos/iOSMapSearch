//
//  PlaceModelTests.swift
//  ac-ios-challenge
//
//  Created by Wesley Silva Santos on 6/15/16.
//  Copyright © 2016 1up. All rights reserved.
//

import XCTest
@testable import ac_ios_challenge

class PlaceModelTests: XCTestCase {
    
    var place:Place!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPlaceCreationRightJSON() {
        let json:[String : AnyObject] = [ "formatted_address":"São Paulo", "geometry":["location": ["lat":50.009890, "lng":-20.98999]], "place_id": "DW9D9DWWDPSLKDS0000SDSD;"]
        let place = Place(json: json)
        XCTAssertNotNil(place)
    }
    
    func testPlaceCreationWrongJSON() {
        let json:[String : AnyObject] = [ "formatted_address":"São Paulo", "geometry":["location": ["lat":50.009890, "lng":-20.98999]]]
        let place = Place(json: json)
        XCTAssertNil(place)
    }
    
}
