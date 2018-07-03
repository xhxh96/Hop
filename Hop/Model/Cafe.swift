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

struct Cafe: Codable {
    var name: String
    var databaseId: String
    var fsVenueId: String
    var bloggerRating: Int?
    var hopperRating: Int?
    var priceRange: Int?
    //var images: [String]
    var url: URL?
    var contactNo: String?
    var contactEmail: String?
    var address: String
    var latitude: Double
    var longitude: Double
    //var amenities: [Bool]
    
    enum CodingKeys: String, CodingKey {
        case name
        case databaseId = "_id"
        case fsVenueId
        case bloggerRating
        case hopperRating
        case priceRange
        //case images
        case url
        case contactNo
        case contactEmail
        case address
        case latitude
        case longitude
        //case amenities
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        databaseId = try valueContainer.decode(String.self, forKey: CodingKeys.databaseId)
        fsVenueId = try valueContainer.decode(String.self, forKey: CodingKeys.fsVenueId)
        bloggerRating = try? valueContainer.decode(Int.self, forKey: CodingKeys.bloggerRating)
        hopperRating = try? valueContainer.decode(Int.self, forKey: CodingKeys.hopperRating)
        priceRange = try? valueContainer.decode(Int.self, forKey: CodingKeys.priceRange)
        url = try? valueContainer.decode(URL.self, forKey: CodingKeys.url)
        contactNo = try? valueContainer.decode(String.self, forKey: CodingKeys.contactNo)
        contactEmail = try? valueContainer.decode(String.self, forKey: CodingKeys.contactEmail)
        address = try valueContainer.decode(String.self, forKey: CodingKeys.address)
        latitude = try valueContainer.decode(Double.self, forKey: CodingKeys.latitude)
        longitude = try valueContainer.decode(Double.self, forKey: CodingKeys.longitude)
    }
    
    
    static func getAmenities(cardPayment: Bool, halal: Bool, openBooking: Bool, parking: Bool, phoneBooking: Bool, powerPlug: Bool, transit: Bool, vegetarian: Bool, water: Bool, wifi: Bool) -> [Bool] {
        var amenities = [Bool].init(repeating: false, count: Amenities.count)
        
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
