import Foundation

struct User: Codable {
    var userId: String
    var password: String
    var firstName: String
    var lastName: String
    //var profilePhoto: URL?
    //var accountType: Int
    var contact: [String: String]
    var reviewCount: Int
    var accountCreatedOn: TimeInterval
    var savedCafes: [SavedCafe]?
    //var reward: [String: Int]
    
    enum CodingKeys: String, CodingKey {
        case userId
        case password
        case firstName
        case lastName
        //case accountType
        case contact
        case reviewCount
        case accountCreatedOn
        case savedCafes
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        userId = try valueContainer.decode(String.self, forKey: CodingKeys.userId)
        password = try valueContainer.decode(String.self, forKey: CodingKeys.password)
        firstName = try valueContainer.decode(String.self, forKey: CodingKeys.firstName)
        lastName = try valueContainer.decode(String.self, forKey: CodingKeys.lastName)
        //accountType = try valueContainer.decode(Int.self, forKey: CodingKeys.accountType)
        contact = try valueContainer.decode([String: String].self, forKey: CodingKeys.contact)
        reviewCount = try valueContainer.decode(Int.self, forKey: CodingKeys.reviewCount)
        accountCreatedOn = try valueContainer.decode(TimeInterval.self, forKey: CodingKeys.accountCreatedOn)
        savedCafes = try? valueContainer.decode([SavedCafe].self, forKey: CodingKeys.savedCafes)
    }
    
    init(userId: String, password: String, firstName: String, lastName: String, contact: [String: String], reviewCount: Int, accountCreatedOn: Date) {
        self.userId = userId
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.contact = contact
        self.reviewCount = reviewCount
        self.accountCreatedOn = accountCreatedOn.timeIntervalSince1970
        self.savedCafes = nil
    }
}


struct UserLogin: Codable {
    var userId: String
    var password: String
}
