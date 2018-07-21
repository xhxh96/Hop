import Foundation

struct ServerResponse: Codable {
    var success: Bool
    var statusCode: Int?
    var response: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusCode
        case response
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        success = try valueContainer.decode(Bool.self, forKey: CodingKeys.success)
        statusCode = try? valueContainer.decode(Int.self, forKey: CodingKeys.statusCode)
        response = try valueContainer.decode(String.self, forKey: CodingKeys.response)
    }
}

struct TokenResponse: Codable {
    var success: Bool
    var statusCode: Int
    var token: String
}
