//
//  MapShowViewController.swift
//  ac-ios-challenge
//
//  Created by Wesley Silva Santos on 6/14/16.
//  Copyright © 2016 1up. All rights reserved.
//

import UIKit
import MapKit

class MapShowViewController: UIViewController, MKMapViewDelegate, UIAlertViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var navRightButton: UIBarButtonItem!
    
    var max_long:Double = 0.0
    var min_long:Double = 0.0
    var max_lat:Double = 0.0
    var min_lat:Double = 0.0

    var addPlace = true
    var places:[Place] = [Place]()
    let placeService:PlaceSerivce = PlaceSerivce()
    var selectedPlace:Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideRightButton()
        self.mapView.delegate = self
        setBarTitle()
        addPins()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func placeAction(sender: AnyObject) {
        if addPlace {
            if placeService.addNewPlace(self.selectedPlace!) {
                navRightButton.title = "Delete"
                addPlace = false
            }
        } else {
            let deleteAlert: UIAlertView = UIAlertView()
            deleteAlert.delegate = self
            deleteAlert.title = "Delete"
            deleteAlert.message = "Are you sure to delete the selected place?"
            deleteAlert.addButtonWithTitle("Delete")
            deleteAlert.addButtonWithTitle("Cancel")
            
            deleteAlert.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
            case 0:
                if self.placeService.deletePlace(self.selectedPlace!) {
                    self.navRightButton.title = "Save"
                    self.addPlace = true
                }
                break;
            case 1:
                break;
            default:
                break;
        }
    }
    
    func setBarTitle() {
        var title = ""
        if self.places.count == 1 {
            title = (self.places.first?.name)!
        } else {
            title = "All Results"
        }
        self.navTitle.title = title
    }
    
    func addPins() {
        initRegion()
        
        for place in self.places {
            let pin = PlacePin(place: place)
            mapView.addAnnotation(pin)
            configRegionArea(place)
        }
        
        calculateRegion()
    }
    
    func hideRightButton() {
        navRightButton.enabled = false
        navRightButton.tintColor = UIColor.clearColor()
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let pinAnnotation:PlacePin = (view.annotation as? PlacePin)!
        pinTapped(pinAnnotation)
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        self.selectedPlace = nil
        hideRightButton()
    }
    
    func pinTapped(pin:PlacePin) {
        if self.places.count == 1 {
            self.selectedPlace = pin.place
            if placeService.existPlace(self.selectedPlace!.placeId!) {
                navRightButton.title = "Delete"
                addPlace = false
            } else {
                navRightButton.title = "Save"
                addPlace = true
            }
            navRightButton.enabled = true
            navRightButton.tintColor = nil
        }
    }
    
    func initRegion() {
        if self.places.count > 0 {
            max_long = (self.places.first?.longitude)!
            min_long = (self.places.first?.longitude)!
            max_lat = (self.places.first?.latitude)!
            min_lat = (self.places.first?.latitude)!
        }
    }
    
    func configRegionArea(place:Place) {
        if place.latitude > max_lat {
            max_lat = place.latitude!
        }
        if place.latitude < min_lat {
            min_lat = place.latitude!
        }
        if place.longitude > max_long {
            max_long = place.longitude!
        }
        if place.longitude < min_long {
            min_long = place.longitude!
        }
    }

    func calculateRegion() {
        let center_long = (max_long + min_long) / 2;
        let center_lat = (max_lat + min_lat) / 2;
        
        var deltaLat = abs(max_lat - min_lat);
        var deltaLong = abs(max_long - min_long);
        
        if deltaLat < 1 {
            deltaLat = 1
        }
        if deltaLong < 1 {
            deltaLong = 1
        }
        
        let location = CLLocationCoordinate2D(
            latitude: center_lat,
            longitude: center_long
        )
        let span = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLong)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}
