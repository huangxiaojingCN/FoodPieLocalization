//
//  Restaurant.swift
//  FoodPie
//
//  Created by ciggo on 4/3/20.
//  Copyright © 2020 ciggo. All rights reserved.
//

import Foundation

class Restaurant {

    var name: String
    var description: String
    var location: String
    var phone: String
    var type: String
    var image: String
    var isVisited: Bool
    var rating: String

    init(name: String, location: String, phone: String, description: String, type: String, image: String, isVisited: Bool, rating: String = "") {
        self.name = name
        self.location = location
        self.phone = phone
        self.description = description
        self.type = type
        self.image = image
        self.isVisited = isVisited
        self.rating = rating
    }

    convenience init() {
        self.init(name: "", location: "", phone: "", description: "", type: "", image: "", isVisited: false, rating: "")
    }
}
