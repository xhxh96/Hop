import Foundation

class BloggerReview: Codable {
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
    
    required init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        reviewSite = try valueContainer.decode(String.self, forKey: CodingKeys.reviewSite)
        reviewerName = try valueContainer.decode(String.self, forKey: CodingKeys.reviewerName)
        reviewDate = try valueContainer.decode(String.self, forKey: CodingKeys.reviewDate)
        extract = try valueContainer.decode(String.self, forKey: CodingKeys.extract)
        url = try valueContainer.decode(URL.self, forKey: CodingKeys.url)
    }
}
