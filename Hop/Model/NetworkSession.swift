import Foundation

struct NetworkSession {
    static var shared = NetworkSession.init(guest: true, user: nil, token: nil)
    
    var guest: Bool
    var user: User?
    var token: String?
}
