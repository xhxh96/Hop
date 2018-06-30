import UIKit

enum Amenities: Int {
    case cardPayment
    case halal
    case studying
    case parking
    case reservations
    case powerSocket
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
    //var fsVenueId: String
    var images: [String] = ["dummy-0", "dummy-1", "dummy-2"]  // For testing purposes - actual collection will be of URL or Data type
    var name: String
    var address: String
    //var url: URL?
    //var contactNo: String?
    //var contactEmail: String?
    var bloggerRating: Double?
    var hopperRating: Double?
    //var priceRange: Int
    //var amenities: [Bool]
    var latitude: Double
    var longitude: Double
    //var bloggerReviews: [Reviews]
    //var hopperReviews: [Reviews]
    
    init(name: String, address: String, bloggerRating: Double?, hopperRating: Double?, latitude: Double, longitude: Double) {
        //self.images = images
        self.name = name
        self.address = address
        self.bloggerRating = bloggerRating
        self.hopperRating = hopperRating
        //self.priceRange = priceRange
        //self.amenities = amenities
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func getAmenities(cardPayment: Bool, halal: Bool, openBooking: Bool, parking: Bool, phoneBooking: Bool, powerPlug: Bool, transit: Bool, vegetarian: Bool, water: Bool, wifi: Bool) -> [Bool] {
        var amenities = Array(repeating: false, count: Amenities.count)
        
        amenities[Amenities.cardPayment.rawValue] = cardPayment
        amenities[Amenities.halal.rawValue] = halal
        amenities[Amenities.studying.rawValue] = openBooking
        amenities[Amenities.parking.rawValue] = parking
        amenities[Amenities.reservations.rawValue] = phoneBooking
        amenities[Amenities.powerSocket.rawValue] = powerPlug
        amenities[Amenities.transit.rawValue] = transit
        amenities[Amenities.vegetarian.rawValue] = vegetarian
        amenities[Amenities.water.rawValue] = water
        amenities[Amenities.wifi.rawValue] = wifi
        
        return amenities
    }
}
