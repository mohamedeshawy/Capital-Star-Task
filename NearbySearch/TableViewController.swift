//
//  TableViewController.swift
//  NearbySearch
//
//  Created by Mohamed Eshawy on 2/27/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController,CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()
    var places : [Place] = []
    var selectedPlace : Place?
    var currentLocation : CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        guard let location = currentLocation else {
            print("location is nil")
            return
        }
        print(location)
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.coordinate.latitude),\(location.coordinate.longitude)&type=restaurant&rankby=distance&key=AIzaSyBok6vv9jhn_OeJOwi6eVOZG5KJH4hBaDY")
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseJson(json: json)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    func parseJson(json:JSON) {
        print("start")
        for (_,subJson):(String, JSON) in json["results"] {
            // Do something you want
            let lat = subJson["geometry"]["location"]["lat"].stringValue
            let lng = subJson["geometry"]["location"]["lng"].stringValue
            let name = subJson["name"].stringValue
            let rating = subJson["rating"].floatValue
            for (_,sub):(String, JSON) in subJson["photos"]{
                let urlImage = URL(string:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(sub["photo_reference"].stringValue)&key=AIzaSyBok6vv9jhn_OeJOwi6eVOZG5KJH4hBaDY" )
                guard let url = urlImage else {
                    print("URL is nil")
                    return
                }
                 let place = Place(lat: lat, lng: lng, image: url, name: name, rating: rating)
                self.places.append(place)
            }
        }
        
    }

    @IBAction func refresh(_ sender: Any) {
        self.locationManager.startUpdatingLocation()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = places[indexPath.row].name
        //cell.imageView?.image = places[indexPath.row].image

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlace = places[indexPath.row]
        self.performSegue(withIdentifier: "getDetails", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let detailsVC = segue.destination as? ViewController
        detailsVC?.place = selectedPlace
        detailsVC?.currentLocation = self.currentLocation?.coordinate
    }
    

}
