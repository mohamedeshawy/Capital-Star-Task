//
//  ViewController.swift
//  NearbySearch
//
//  Created by Mohamed Eshawy on 2/27/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//      AIzaSyDspiSWqWph6jEZKhsA7VmnyvN6O4UWe3w


import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import HCSStarRatingView

class ViewController: UIViewController {
    var place : Place?
    var originTitle : String?
    var destinationTitle : String?
    var currentLocation : CLLocationCoordinate2D?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let origin = currentLocation,let resturantLat = place?.lat,let resturantLng = place?.lng,let urlImage = place?.image,let resturantName = place?.name ,let resturantRating = place?.rating else {
            print("nil")
            return
        }
        Alamofire.request(urlImage, method: .get).responseImage { response in
            if let image : UIImage = response.result.value {
                self.imageView.image = image
            }
        }
        let urlDistance = URL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(origin.latitude),\(origin.longitude)&destinations=\(resturantLat),\(resturantLng)&key=AIzaSyBok6vv9jhn_OeJOwi6eVOZG5KJH4hBaDY")
        guard let url = urlDistance else {
            print("url is nil")
            return
        }
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseJson(json: json)
            case .failure(let error):
                print(error)
            }
        }
        nameLabel.text = resturantName
        ratingView.value = CGFloat(resturantRating)
        ratingView.isEnabled = false
    }
    func parseJson (json:JSON) {
        self.distanceLabel.text = "\(json["rows"].array![0]["elements"].array![0]["distance"]["text"]),\(json["rows"].array![0]["elements"].array![0]["duration"]["text"]) with Driving"
        self.originTitle = json["origin_addresses"].array![0].stringValue
        self.destinationTitle = json["destination_addresses"].array![0].stringValue
    }
}

