//
//  Place.swift
//  ac-ios-challenge
//
//  Created by Wesley Silva Santos on 6/14/16.
//  Copyright © 2016 1up. All rights reserved.
//

import Foundation

class Place {
    var placeId:String?
    var name:String?
    var latitude:Double?
    var longitude:Double?
    
    init?(json:[String: AnyObject]) {
        guard let name = json["formatted_address"] as? String
            else {
                return nil
        }
        self.name = name
        
        guard let geometry = json["geometry"] as? [String: AnyObject], location = geometry["location"] as? [String: AnyObject], latitude = location["lat"] as? Double, longitude = location["lng"] as? Double
            else {
                return nil
        }
        self.latitude = latitude
        self.longitude = longitude
        
        guard let placeId = json["place_id"] as? String
            else {
                return nil
        }
        self.placeId = placeId
    }
}