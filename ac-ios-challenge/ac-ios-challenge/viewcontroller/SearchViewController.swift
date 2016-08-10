//
//  SearchViewController.swift
//  ac-ios-challenge
//
//  Created by Wesley Silva Santos on 6/14/16.
//  Copyright © 2016 1up. All rights reserved.
//

import UIKit
import AFNetworking

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    var places:[Place] = [Place]();
    var sectionCount = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        if places.count == 0 {
            self.tableView.hidden = true;
        }
        
        let image : UIImage = UIImage(named: "PinIcon")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.places.count > 1 {
            sectionCount = 2
        } else {
            sectionCount = 1
        }
        
        return sectionCount
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionCount == 2 {
            if section == 0 {
                return 1
            } else {
                return self.places.count
            }
        } else {
            return self.places.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        if sectionCount == 2 {
            if indexPath.section == 0 {
                cell.textLabel?.text = "Display All on Map"
            } else {
                if self.places.count > 0 {
                    let place:Place = self.places[indexPath.row]
                    cell.textLabel?.text = place.name
                }
            }
        } else {
            if self.places.count > 0 {
                let place:Place = self.places[indexPath.row]
                cell.textLabel?.text = place.name
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("map_show", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "map_show" {
            let mapShowViewController:MapShowViewController = segue.destinationViewController as! MapShowViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            var placesToSend:[Place] = [Place]();
            
            if sectionCount == 2 {
                if(indexPath.section == 0) {
                    placesToSend = self.places
                } else {
                    let selectedPlace:Place = self.places[indexPath.row];
                    placesToSend.append(selectedPlace)
                }
            } else {
                let selectedPlace:Place = self.places[indexPath.row];
                placesToSend.append(selectedPlace)
            }
            mapShowViewController.places = placesToSend
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty {
            let decodedSearch = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            getPlaces(decodedSearch)
        } else {
            places = [Place]();
            configureTable()
        }
    }
    
    func getPlaces(placeName: String) {
        places = [Place]();
        let url = String.init(format: "http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", placeName)
        let manager = AFHTTPSessionManager()
        
        manager.GET(url,
            parameters: nil,
            progress: nil,
            success: { (dataTask: NSURLSessionDataTask, responseObject: AnyObject?) in
                guard let value = responseObject as? [String: AnyObject], rows = value["results"] as? [[String: AnyObject]]
                    else {
                        return
                }
                
                for roomDict in rows {
                    print(roomDict)
                    self.places.append(Place(json: roomDict)!)
                }
                                    
                self.configureTable()
            },
            failure: { (dataTask: NSURLSessionDataTask?,error: NSError) in
                print("Error: " + error.localizedDescription)
            }
        )
    }
    
    func configureTable() {
        if self.places.count > 0 {
            self.tableView.hidden = false
        } else {
            self.tableView.hidden = true
        }
        
        self.tableView.reloadData()
    }
}
