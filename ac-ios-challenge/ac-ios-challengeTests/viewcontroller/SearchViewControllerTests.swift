//
//  SearchViewControllerTests.swift
//  ac-ios-challenge
//
//  Created by Wesley Silva Santos on 6/15/16.
//  Copyright © 2016 1up. All rights reserved.
//

import XCTest
import UIKit
@testable import ac_ios_challenge

class SearchViewControllerTests: XCTestCase {
    
    var viewController:SearchViewController!
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMutipleResultSearch() {
        viewController.getPlaces("Spring")
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            XCTAssertTrue(self.viewController.places.count >= 1)
        }
    }
    
    func testUniqueResultSearch() {
        viewController.getPlaces("Spain")
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            XCTAssertTrue(self.viewController.places.count == 1)
        }
    }
}
