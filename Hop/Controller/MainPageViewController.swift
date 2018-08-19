import UIKit
import CoreLocation

class MainPageViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager.init()
    var currentLocation: CLLocationCoordinate2D?
    var cafe: Cafe!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cafeImage: UIImageView!
    @IBOutlet weak var cafeName: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var signInLogOutButton: UIButton!
    
    @IBOutlet var bloggerRating: [UIImageView]!
    @IBOutlet var hopperRating: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let activityViewController = ActivityViewController(message: "Loading...")
        present(activityViewController, animated: true) {
            NetworkController.shared.fetchNoLoginToken { (token) in
                NetworkSession.shared.token = token
                
                NetworkController.shared.fetchCafeOfTheDay(with: NetworkSession.shared.token!) { (cafe) in
                    self.cafe = cafe
                    let imageURL = URL(string: cafe.images.first!)
                    let imageData = try? Data(contentsOf: imageURL!)
                    DispatchQueue.main.async {
                        self.setupInterface(image: imageData, cafe: self.cafe)
                        self.updateSearchButton()
                        activityViewController.dismiss(animated: true, completion: nil)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchButton() {
        if !CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            searchButton.isEnabled = false
        }
        else {
            searchButton.isEnabled = true
        }
    }
    
    func setupInterface(image: Data?, cafe: Cafe) {
        // Setup café of the day card
        if let image = image {
            cafeImage.image = UIImage(data: image)
        }
        cafeName.text = cafe.name
        
        // Setup function buttons
        if NetworkSession.shared.guest {
            profileButton.isHidden = true
            signInLogOutButton.setTitle("Sign In", for: .normal)
        }
        else {
            profileButton.isHidden = false
            signInLogOutButton.setTitle("Sign Out", for: .normal)
        }
        
        // Setup ratings in café of the day card
        if let rating = cafe.bloggerRating {
            if rating != -1 {
                for index in 0..<Int(rating) {
                    bloggerRating[index].alpha = 1
                }
            }
        }
        
        if let rating = cafe.hopperRating {
            if rating != -1 {
                for index in 0..<Int(rating) {
                    hopperRating[index].alpha = 1
                }
            }
        }
        
        // Setup café imageView
        cafeImage.layer.cornerRadius = 20.0
        cafeImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        
        // Setup today's date
        let dateFormatter = DateFormatter.init()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateStyle = .long
        dateLabel.text = dateFormatter.string(from: Date.init())
        
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func signInLogOutTapped(_ sender: UIButton) {
        if NetworkSession.shared.guest {
            performSegue(withIdentifier: "loginPage", sender: nil)
        }
        else {
            NetworkSession.shared.initialize()
            self.viewDidAppear(true)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beginSearch" {
            
            let navigationController = segue.destination as? UINavigationController
            let searchResultTableViewController = navigationController?.viewControllers.first as? SearchResultTableViewController
            
            if let location = locationManager.location {
                currentLocation = location.coordinate
            }
            searchResultTableViewController?.currentLocation = currentLocation
        }
    }
}
