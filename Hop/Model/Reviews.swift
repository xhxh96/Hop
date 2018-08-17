import Foundation

struct HopperReview: Codable {
    var fsVenueId: String
    var reviewId: String?
    var cafeName: String
    var userId: String
    var reviewDate: TimeInterval
    var rating: Int
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case fsVenueId
        case reviewId = "_id"
        case cafeName
        case userId = "reviewerId"
        case reviewDate
        case rating
        case content
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        fsVenueId = try valueContainer.decode(String.self, forKey: CodingKeys.fsVenueId)
        reviewId = try? valueContainer.decode(String.self, forKey: CodingKeys.reviewId)
        cafeName = try valueContainer.decode(String.self, forKey: CodingKeys.cafeName)
        userId = try valueContainer.decode(String.self, forKey: CodingKeys.userId)
        reviewDate = try valueContainer.decode(TimeInterval.self, forKey: CodingKeys.reviewDate)
        rating = try valueContainer.decode(Int.self, forKey: CodingKeys.rating)
        content = try valueContainer.decode(String.self, forKey: CodingKeys.content)
    }
    
    init(fsVenueId: String, cafeName: String, userId: String, reviewDate: TimeInterval, rating: Int, content: String) {
        self.fsVenueId = fsVenueId
        self.cafeName = cafeName
        self.userId = userId
        self.reviewDate = reviewDate
        self.rating = rating
        self.content = content
    }
}

struct BloggerReview: Codable {
    var title: String
    var reviewSite: String
    var reviewerName: String?
    var reviewDate: String?
    var extract: String
    var url: URL
    
    enum CodingKeys: String, CodingKey {
        case title
        case reviewSite
        case reviewerName
        case reviewDate
        case extract
        case url
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        reviewSite = try valueContainer.decode(String.self, forKey: CodingKeys.reviewSite)
        reviewerName = try? valueContainer.decode(String.self, forKey: CodingKeys.reviewerName)
        reviewDate = try? valueContainer.decode(String.self, forKey: CodingKeys.reviewDate)
        extract = try valueContainer.decode(String.self, forKey: CodingKeys.extract)
        url = try valueContainer.decode(URL.self, forKey: CodingKeys.url)
    }
    
    static func removeNewLine(review: inout BloggerReview) {
        review.extract = review.extract.replacingOccurrences(of: "\n", with: "")
    }
}
