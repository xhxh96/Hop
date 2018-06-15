//
//  Cafe.swift
//  Hop
//
//  Created by macOS on 14/6/18.
//  Copyright © 2018 NUS. All rights reserved.
//

import Foundation
import UIKit

enum Amenities {
    case cardPayment(Bool)
    case wifi(Bool)
    case power(Bool)
    case parking(Bool)
    case transit(Bool)
    case halal(Bool)
    case vegetarian(Bool)
    case water(Bool)
    case contact(Bool)
    case booking(Bool)
}

class Cafe {
    var images: [UIImage]
    var name: String
    var address: String
    var bloggerReview: Int
    var hopperReview: Int
    var priceRange: Int
    var amenities: [Amenities]
    var locationX: Double
    var locationY: Double
    
    init(images: [UIImage], name: String, address: String, bloggerReview: Int, hopperReview: Int, priceRange: Int, amenities: [Amenities], locationX: Double, locationY: Double) {
        self.images = images
        self.name = name
        self.address = address
        self.bloggerReview = bloggerReview
        self.hopperReview = hopperReview
        self.priceRange = priceRange
        self.amenities = amenities
        self.locationX = locationX
        self.locationY = locationY
    }
}
