import Foundation

struct Cafe: Codable {
    var name: String
    var databaseId: String
    var fsVenueId: String
    var bloggerRating: Int?
    var hopperRating: Int?
    var priceRange: Int?
    var images: [String]
    var url: URL?
    var contactNo: String?
    var contactEmail: String?
    var address: String
    var postalCode: String
    var latitude: Double
    var longitude: Double
    var amenities: [String: Int]
    
    enum CodingKeys: String, CodingKey {
        case name
        case databaseId = "_id"
        case fsVenueId
        case bloggerRating
        case hopperRating
        case priceRange
        case images
        case url
        case contactNo
        case contactEmail
        case address
        case postalCode
        case latitude
        case longitude
        case amenities
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        databaseId = try valueContainer.decode(String.self, forKey: CodingKeys.databaseId)
        fsVenueId = try valueContainer.decode(String.self, forKey: CodingKeys.fsVenueId)
        bloggerRating = try? valueContainer.decode(Int.self, forKey: CodingKeys.bloggerRating)
        hopperRating = try? valueContainer.decode(Int.self, forKey: CodingKeys.hopperRating)
        priceRange = try? valueContainer.decode(Int.self, forKey: CodingKeys.priceRange)
        images = try valueContainer.decode([String].self, forKey: CodingKeys.images)
        url = try? valueContainer.decode(URL.self, forKey: CodingKeys.url)
        contactNo = try? valueContainer.decode(String.self, forKey: CodingKeys.contactNo)
        contactEmail = try? valueContainer.decode(String.self, forKey: CodingKeys.contactEmail)
        address = try valueContainer.decode(String.self, forKey: CodingKeys.address)
        postalCode = try valueContainer.decode(String.self, forKey: CodingKeys.postalCode)
        latitude = try valueContainer.decode(Double.self, forKey: CodingKeys.latitude)
        longitude = try valueContainer.decode(Double.self, forKey: CodingKeys.longitude)
        amenities = try valueContainer.decode([String: Int].self, forKey: CodingKeys.amenities)
    }
    
    func serializeAmenities() -> [Int] {
        var amenitiesArray = [Int].init(repeating: 0, count: 10)
        
        for key in amenities.keys {
            switch key {
            case "cardPayment":
                amenitiesArray[0] = amenities["cardPayment"]!
            case "halal":
                amenitiesArray[1] = amenities["halal"]!
            case "studying":
                amenitiesArray[2] = amenities["studying"]!
            case "parking":
                amenitiesArray[3] = amenities["parking"]!
            case "reservations":
                amenitiesArray[4] = amenities["reservations"]!
            case "powerSocket":
                amenitiesArray[5] = amenities["powerSocket"]!
            case "transit":
                amenitiesArray[6] = amenities["transit"]!
            case "vegetarian":
                amenitiesArray[7] = amenities["vegetarian"]!
            case "water":
                amenitiesArray[8] = amenities["water"]!
            case "wifi":
                amenitiesArray[9] = amenities["wifi"]!
            default:
                break
            }
        }
        return amenitiesArray
    }
    
    mutating func deserializeAmenities(with amenitiesArray: [Int]) {
        for index in 0..<amenitiesArray.count {
            switch index {
            case 0:
                amenities["cardPayment"] = amenitiesArray[0]
            case 1:
                amenities["halal"] = amenitiesArray[1]
            case 2:
                amenities["studying"] = amenitiesArray[2]
            case 3:
                amenities["parking"] = amenitiesArray[3]
            case 4:
                amenities["reservations"] = amenitiesArray[4]
            case 5:
                amenities["powerSocket"] = amenitiesArray[5]
            case 6:
                amenities["transit"] = amenitiesArray[6]
            case 7:
                amenities["vegetarian"] = amenitiesArray[7]
            case 8:
                amenities["water"] = amenitiesArray[8]
            case 9:
                amenities["wifi"] = amenitiesArray[9]
            default:
                break
            }
        }
    }
}
