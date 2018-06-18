import Foundation

class SearchResult {
    var name: String
    var address: String
    var description: String
    
    init(name: String, address: String, description: String) {
        self.name = name
        self.address = address
        self.description = description
    }
}
