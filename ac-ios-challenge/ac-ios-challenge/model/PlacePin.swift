//
//  PlacePin.swift
//  ac-ios-challenge
//
//  Created by Wesley Silva Santos on 6/15/16.
//  Copyright © 2016 1up. All rights reserved.
//

import MapKit

class PlacePin: NSObject, MKAnnotation {
    let place:Place?
    let title: String?
    let subtitle: String?
    let placeId: String?
    let myCoordinate: CLLocationCoordinate2D?
    
    init(place: Place) {
        self.place = place
        self.title = self.place!.name
        self.placeId = self.place!.placeId
        self.myCoordinate = CLLocationCoordinate2D(
            latitude: self.place!.latitude!,
            longitude: self.place!.longitude!
        )
        self.subtitle = String( format: "(\(self.place!.latitude!)  \(self.place!.longitude!))")
        
        super.init()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return myCoordinate!
    }
    
}
