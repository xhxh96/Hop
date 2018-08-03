import Foundation
import MapKit

class NetworkController {
    static let shared = NetworkController.init()
    
    let client_id = "NAT0ERZ20UEDFBBYWC3LFXTT0QPGH2GU4WEZ1PNI3QO22GRD"
    let client_secret = "YVG0G3PFL2CFDOMIQLGJTMLXSQ0VGP3FOAPEY2UUUEAUC0FZ"
    
    let baseURL = URL(string: "https://hopdbserver.herokuapp.com/")
    
    func fetchNoLoginToken(completion: @escaping (String?) -> Void) {
        let url = baseURL?.appendingPathComponent("nouserlogin")
        
        guard let requestURL = url else {
            print("FETCH LOGIN TOKEN ERROR: Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder.init()
            if let data = data{
                let jsonObject = try! jsonDecoder.decode(TokenResponse.self, from: data)
                completion(jsonObject.token)
            }
            else {
                print("FETCH LOGIN TOKEN WARNING: No JSON Object found")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchLoginToken(account: UserLogin, completion: @escaping (TokenResponse?) -> Void) {
        let url = baseURL?.appendingPathComponent("login")
        
        guard let requestURL = url else {
            print("LOGGING IN ERROR: Invalid request")
            return
        }
        
        let jsonEncoder = JSONEncoder.init()
        let data = try? jsonEncoder.encode(account)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder.init()
            
            if let data = data, let tokenResponse = try? jsonDecoder.decode(TokenResponse.self, from: data) {
                completion(tokenResponse)
            }
            else {
                print("LOGGING IN WARNING: No JSON Object found, or unable to map JSON Object to model")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchFromFourSquare(keyword searchKeyword: String?, location currentLocation: CLLocationCoordinate2D?, completion: @escaping (JSON) -> Void) {
        var url: String
        let formattedSearchInput = searchKeyword?.replacingOccurrences(of: " ", with: "-")
        // to implement guard for input in URL
        
        if let searchExist = formattedSearchInput {
            url = "https://api.foursquare.com/v2/search/recommendations?near=\(searchExist)&radius=1500&v=20180617&categoryId=4bf58dd8d48988d16d941735&limit=15&client_id=\(client_id)&client_secret=\(client_secret)"
        }
        else {
            url = "https://api.foursquare.com/v2/search/recommendations?ll=\(currentLocation!.latitude),\(currentLocation!.longitude)&radius=1500&v=20180617&categoryId=4bf58dd8d48988d16d941735&limit=15&client_id=\(client_id)&client_secret=\(client_secret)"
        }
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            let json = JSON(data: data!)
            completion(json)
            })
        
        task.resume()
    }
    
    func fetchThumbnail(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            }
            else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchCafeOfTheDay(with token: String, completion: @escaping (Cafe) -> Void) {
        let url: String = "https://hopdbserver.herokuapp.com/cafe/random?token=\(token)"
        
        guard let requestURL = URL(string: url) else {
            print("FETCH CAFE DATA ERROR: Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder.init()
            if let data = data {
                let cafeObject = try! jsonDecoder.decode(Cafe.self, from: data)
                completion(cafeObject)
            }
        }
        task.resume()
    }
    
    func fetchCafeFromDatabase(cafe selectedCafe: JSON, with token: String, completion: @escaping (Cafe) -> Void) {
        let venueId = selectedCafe["venue"]["id"].string
        let url: String = "https://hopdbserver.herokuapp.com/cafe/data?fsVenueId=\(venueId!)&token=\(token)"
        print("Cafe Database URL: \(url)")
        
        guard let requestURL = URL(string: url) else {
            print("FETCH CAFE DATA ERROR: Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) {data, response, error -> Void in
            let jsonDecoder = JSONDecoder.init()
            if let data = data {
                let cafeObject = try! jsonDecoder.decode(Cafe.self, from: data)
                completion(cafeObject)
            }
            else {
                print("FETCH CAFE DATA WARNING: No JSON Object found, or unable to map JSON Object to model")
                return
            }
        }
        
        task.resume()
    }
    
    func fetchBloggerReviewFromDatabase(cafe selectedCafe: JSON, with token: String, completion: @escaping ([BloggerReview]?) -> Void) {
        let venueId = selectedCafe["venue"]["id"].string
        let url: String = "https://hopdbserver.herokuapp.com/cafe/review/blogger?fsVenueId=\(venueId!)&token=\(token)"
        
        guard let requestURL = URL(string: url) else {
            print("FETCH BLOGGER REVIEW ERROR: Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder.init()
            if let data = data, let bloggerReview = try? jsonDecoder.decode([BloggerReview].self, from: data) {
                completion(bloggerReview)
            }
            else {
                print("FETCH BLOGGER REVIEW WARNING: No JSON Object found, or unable to map JSON Object to model")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchHopperReviewFromDatabase(cafe selectedCafe: JSON, with token: String, completion: @escaping ([HopperReview]?) -> Void) {
        let venueId = selectedCafe["venue"]["id"].string
        let url: String = "https://hopdbserver.herokuapp.com/cafe/review/hopper?fsVenueId=\(venueId!)&token=\(token)"
        print("Hopper Review URL: \(url)")
        
        guard let requestURL = URL(string: url) else {
            print("FETCH HOPPER REVIEW ERROR: Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder.init()
            
            if let data = data, let hopperReview = try? jsonDecoder.decode([HopperReview].self, from: data) {
                completion(hopperReview)
            }
            else {
                print("FETCH HOPPER REVIEW WARNING: No JSON Object found, or unable to map JSON Object to model")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func submitReview(review: HopperReview, with token: String, completion: @escaping (ServerResponse?) -> Void) {
        let url: String = "https://hopdbserver.herokuapp.com/cafe/review/hopper?token=\(token)"
        
        guard let requestURL = URL(string: url) else {
            print("SUBMIT REVIEW ERROR: Invalid request")
            return
        }
        
        let jsonEncoder = JSONEncoder.init()
        let data = try? jsonEncoder.encode(review)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder.init()
            
            if let data = data, let serverResponse = try? jsonDecoder.decode(ServerResponse.self, from: data) {
                completion(serverResponse)
            }
            else {
                print("SUBMIT REVIEW WARNING: No JSON Object found, or unable to map JSON Object to model")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func submitEdit(cafe: Cafe, with token: String, completion: @escaping (ServerResponse?) -> Void) {
        let url: String = "https://hopdbserver.herokuapp.com/cafe/data?token=\(token)"
        
        guard let requestURL = URL(string: url) else {
            print("Invalid request")
            return
        }
        
        let jsonEncoder = JSONEncoder.init()
        let data = try? jsonEncoder.encode(cafe)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder.init()
            
            if let data = data, let serverResponse = try? jsonDecoder.decode(ServerResponse.self, from: data) {
                completion(serverResponse)
            }
            else {
                print("SUGGEST EDIT WARNING: No JSON Object found, or unable to map JSON Object to model")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func createAccount(account: User, completion: @escaping (ServerResponse?) -> Void) {
        let url = baseURL?.appendingPathComponent("newuser")
        
        guard let requestURL = url else {
            print("Invalid request")
            return
        }
        let jsonEncoder = JSONEncoder.init()
        let data = try? jsonEncoder.encode(account)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder.init()
            if let data = data, let serverResponse = try? jsonDecoder.decode(ServerResponse.self, from: data) {
                completion(serverResponse)
            }
            else {
                print("CREATE ACCOUNT WARNING: No JSON Object found, or unable to map JSON Object to model")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func updateProfile(updated account: [String: String], completion: @escaping (ServerResponse?) -> Void) {
        let url = baseURL?.appendingPathComponent("user")
        
        guard let requestURL = url else {
            print("Invalid request")
            return
        }
        
        let jsonEncoder = JSONEncoder.init()
        let data = try? jsonEncoder.encode(account)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder.init()
            if let data = data, let serverResponse = try? jsonDecoder.decode(ServerResponse.self, from: data) {
                completion(serverResponse)
            }
            else {
                print("UPDATE ACCOUNT WARNING: No JSON Object found, or unable to map JSON Object to model")
                completion(nil)
            }
        }
        task.resume()
    }
}
