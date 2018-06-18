import UIKit

enum Amenities: Int {
    case cardPayment
    case halal
    case openBooking
    case parking
    case phoneBooking
    case powerPlug
    case transit
    case vegetarian
    case water
    case wifi
    
    static let count: Int = {
        var max: Int = 0
        while let _ = Amenities(rawValue: max) {
            max += 1
        }
        return max
    }()
}

class Cafe {
    //var images: [UIImage]
    var name: String
    var address: String
    var bloggerReview: Double?
    var hopperReview: Double?
    //var priceRange: Int
    //var amenities: [Bool]
    var latitude: Double
    var longitude: Double
    
    init(name: String, address: String, bloggerReview: Double?, hopperReview: Double?, latitude: Double, longitude: Double) {
        //self.images = images
        self.name = name
        self.address = address
        self.bloggerReview = bloggerReview
        self.hopperReview = hopperReview
        //self.priceRange = priceRange
        //self.amenities = amenities
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func getAmenities(cardPayment: Bool, halal: Bool, openBooking: Bool, parking: Bool, phoneBooking: Bool, powerPlug: Bool, transit: Bool, vegetarian: Bool, water: Bool, wifi: Bool) -> [Bool] {
        var amenities = Array(repeating: false, count: Amenities.count)
        
        amenities[Amenities.cardPayment.rawValue] = cardPayment
        amenities[Amenities.halal.rawValue] = halal
        amenities[Amenities.openBooking.rawValue] = openBooking
        amenities[Amenities.parking.rawValue] = parking
        amenities[Amenities.phoneBooking.rawValue] = phoneBooking
        amenities[Amenities.powerPlug.rawValue] = powerPlug
        amenities[Amenities.transit.rawValue] = transit
        amenities[Amenities.vegetarian.rawValue] = vegetarian
        amenities[Amenities.water.rawValue] = water
        amenities[Amenities.wifi.rawValue] = wifi
        
        return amenities
    }
}
