//
//  Restaurant.swift
//  FoodPin
//
//  Created by Ron Yi on 2018/5/6.
//  Copyright © 2018年 Ron Yi. All rights reserved.
//

import Foundation

class Restaurant {
    var name = ""
    var type = ""
    var location = ""
    var phone = ""
    var image = ""
    var isVisited = false
    var rating = ""
    
    
    init(name: String, type: String, location: String, phone: String, image: String,isVisited: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.image = image
        self.isVisited = isVisited
        
    }
}
