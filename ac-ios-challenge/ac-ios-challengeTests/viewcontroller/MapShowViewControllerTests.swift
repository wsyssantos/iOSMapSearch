//
//  MapShowViewControllerTests.swift
//  ac-ios-challenge
//
//  Created by Wesley Silva Santos on 6/15/16.
//  Copyright © 2016 1up. All rights reserved.
//

import XCTest
import UIKit
import MapKit
@testable import ac_ios_challenge

class MapShowViewControllerTests: XCTestCase {
    
    var searchViewController:SearchViewController!
    var mapShowViewController:MapShowViewController!
    
    override func setUp() {
        super.setUp()
        mapShowViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MapShowViewController") as! MapShowViewController
        searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        self.mapShowViewController.mapView = MKMapView.init()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddUniquePin() {
        searchViewController.getPlaces("Spain")
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            XCTAssertTrue(self.searchViewController.places.count == 1)
            self.mapShowViewController.places = self.searchViewController.places
            self.mapShowViewController.addPins()
            let annotations:[MKAnnotation] = self.mapShowViewController.mapView.annotations
            XCTAssertTrue(annotations.count == 1)
        }
    }
    
    func testAddMultiplePins() {
        searchViewController.getPlaces("Spring")
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            XCTAssertTrue(self.searchViewController.places.count > 1)
            self.mapShowViewController.places = self.searchViewController.places
            self.mapShowViewController.addPins()
            let annotations:[MKAnnotation] = self.mapShowViewController.mapView.annotations
            XCTAssertTrue(annotations.count > 1)
        }
    }
    
    func testSavePlaceToDataBase() {
        searchViewController.getPlaces("Spain")
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.mapShowViewController.selectedPlace = self.searchViewController.places.first!
            XCTAssertNotNil(self.mapShowViewController.selectedPlace)
            
            let pin:PlacePin = PlacePin(place: self.mapShowViewController.selectedPlace!)
            self.mapShowViewController.pinTapped(pin);
            
            self.mapShowViewController.placeAction(pin)
            
            let placeService = PlaceSerivce()
            XCTAssertTrue(placeService.existPlace(pin.placeId!))
        }

    }
    
}
