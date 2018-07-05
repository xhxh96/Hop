import Foundation

class HopperReview: Codable {
    var fsVenueId: String
    var userId: String
    var reviewDate: String
    var rating: Int
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case fsVenueId
        case userId = "reviewerId"
        case reviewDate
        case rating
        case content
    }
    
    required init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        fsVenueId = try valueContainer.decode(String.self, forKey: CodingKeys.fsVenueId)
        userId = try valueContainer.decode(String.self, forKey: CodingKeys.userId)
        reviewDate = try valueContainer.decode(String.self, forKey: CodingKeys.reviewDate)
        rating = try valueContainer.decode(Int.self, forKey: CodingKeys.rating)
        content = try valueContainer.decode(String.self, forKey: CodingKeys.content)
    }
    
    init(fsVenueId: String, userId: String, reviewDate: String, rating: Int, content: String) {
        self.fsVenueId = fsVenueId
        self.userId = userId
        self.reviewDate = reviewDate
        self.rating = rating
        self.content = content
    }
}
