import Foundation

struct NetworkSession {
    static var shared = NetworkSession.init(guest: true, user: nil, token: nil)
    
    var guest: Bool
    var user: User?
    var token: String?
    
    mutating func resetSession() {
        guest = true
        user = nil
        token = nil
    }
    
    mutating func initializeSession(user: User?, token: String?) {
        guest = false
        self.user = user
        self.token = token
    }
}
