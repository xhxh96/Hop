import UIKit
import CoreLocation

class MainPageViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager.init()
    var currentLocation: CLLocationCoordinate2D?
    var cafe: Cafe!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cafeImage: UIImageView!
    @IBOutlet weak var cafeName: UILabel!
    @IBOutlet weak var cafeTextDescription: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupInterface()
        
        NetworkController.shared.fetchCafeOfTheDay(with: NetworkSession.shared.token!) { (cafe) in
            self.cafe = cafe
            let imageURL = URL(string: cafe.images.first!)
            let imageData = try? Data(contentsOf: imageURL!)
            DispatchQueue.main.async {
                self.cafeImage.image = UIImage(data: imageData!)
                self.cafeName.text = cafe.name
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSearchButton()
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
    
    func setupInterface() {
        if NetworkSession.shared.guest {
            profileButton.isHidden = true
        }
        
        cafeImage.layer.cornerRadius = 20.0
        cafeImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
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
        else if segue.identifier == "logout" {
            NetworkSession.shared.guest = true
            NetworkSession.shared.token = nil
            NetworkSession.shared.user = nil
        }
    }
 

}
