import Foundation

class Reviews {
    var name: String
    var description: String
    var date: Date
    var url: URL?
    
    init(name: String, description: String, date: Date, url: URL?) {
        self.name = name
        self.description = description
        self.date = date
        
        if let url = url {
            self.url = url
        }
        else {
            self.url = nil
        }
    }
}
