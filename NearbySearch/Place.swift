//
//  Place.swift
//  NearbySearch
//
//  Created by Mohamed Eshawy on 2/27/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import Foundation
class Place {
    var lat : String?
    var lng : String?
    var image : URL?
    var name : String?
    var rating : Float?
    
    init(lat : String,lng : String,image:URL,name : String,rating : Float) {
        self.lat = lat
        self.lng = lng
        self.image=image
        self.name=name
        self.rating=rating
    }
}
