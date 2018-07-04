import Foundation

class HopperReview: Codable {
    var userID: String
    var userName: String
    var reviewDate: String
    var extract: String
    
    enum CodingKeys: String, CodingKey {
        case userID
        case userName
        case reviewDate
        case extract
    }
    
    required init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        userID = try valueContainer.decode(String.self, forKey: CodingKeys.userID)
        userName = try valueContainer.decode(String.self, forKey: CodingKeys.userName)
        reviewDate = try valueContainer.decode(String.self, forKey: CodingKeys.reviewDate)
        extract = try valueContainer.decode(String.self, forKey: CodingKeys.extract)
    }
}
