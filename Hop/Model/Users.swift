import Foundation

class User {
    var userID: String
    var firstName: String
    var lastName: String
    var emailAddress: String
    var password: String
    
    init(userID: String, firstName: String, lastName: String, emailAddress: String, password: String) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.password = password
    }
}
