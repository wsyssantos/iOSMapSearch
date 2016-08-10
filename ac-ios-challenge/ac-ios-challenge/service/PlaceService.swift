//
//  PlaceService.swift
//  ac-ios-challenge
//
//  Created by Wesley Silva Santos on 6/15/16.
//  Copyright © 2016 1up. All rights reserved.
//

import UIKit
import CoreData

class PlaceSerivce {
    
    func existPlace(placeId:String) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Place")
        fetchRequest.predicate = NSPredicate(format: "placeId == %@", placeId)
        
        do {
            let place = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            return place.count > 0
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
    }
    
    func addNewPlace(newPlace:Place) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let placeEntity =  NSEntityDescription.entityForName("Place", inManagedObjectContext:managedContext)
        let place = NSManagedObject(entity: placeEntity!, insertIntoManagedObjectContext: managedContext)
        
        place.setValue(newPlace.name, forKey: "name")
        place.setValue(newPlace.placeId, forKey: "placeId")
        place.setValue(newPlace.latitude, forKey: "latitude")
        place.setValue(newPlace.longitude, forKey: "longitude")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deletePlace(place:Place) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Place")
        fetchRequest.predicate = NSPredicate(format: "placeId == %@", place.placeId!)
        
        do {
            let place = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            managedContext.deleteObject(place[0])
            try managedContext.save()
            return true
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
    }
    
}