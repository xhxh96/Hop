import Foundation

struct HopperReview: Codable {
    var fsVenueId: String
    var userId: String
    var reviewDate: TimeInterval
    var rating: Int
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case fsVenueId
        case userId = "reviewerId"
        case reviewDate
        case rating
        case content
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        fsVenueId = try valueContainer.decode(String.self, forKey: CodingKeys.fsVenueId)
        userId = try valueContainer.decode(String.self, forKey: CodingKeys.userId)
        reviewDate = try valueContainer.decode(TimeInterval.self, forKey: CodingKeys.reviewDate)
        rating = try valueContainer.decode(Int.self, forKey: CodingKeys.rating)
        content = try valueContainer.decode(String.self, forKey: CodingKeys.content)
    }
    
    init(fsVenueId: String, userId: String, reviewDate: TimeInterval, rating: Int, content: String) {
        self.fsVenueId = fsVenueId
        self.userId = userId
        self.reviewDate = reviewDate
        self.rating = rating
        self.content = content
    }
}

struct BloggerReview: Codable {
    var reviewSite: String
    var reviewerName: String
    var reviewDate: String
    var extract: String
    var url: URL
    
    enum CodingKeys: String, CodingKey {
        case reviewSite
        case reviewerName
        case reviewDate
        case extract
        case url
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        reviewSite = try valueContainer.decode(String.self, forKey: CodingKeys.reviewSite)
        reviewerName = try valueContainer.decode(String.self, forKey: CodingKeys.reviewerName)
        reviewDate = try valueContainer.decode(String.self, forKey: CodingKeys.reviewDate)
        extract = try valueContainer.decode(String.self, forKey: CodingKeys.extract)
        url = try valueContainer.decode(URL.self, forKey: CodingKeys.url)
    }
}
