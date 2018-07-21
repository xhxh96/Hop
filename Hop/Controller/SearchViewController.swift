import UIKit
import CoreLocation

class SearchViewController: UIViewController, CLLocationManagerDelegate {
    var token: String?
    let locationManager = CLLocationManager.init()
    var currentLocation: CLLocationCoordinate2D?
    
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchNearYouButton: UIButton!
    @IBOutlet weak var searchNearYouErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        
        updateSearchNearYouStatus()
        updateSearchButton()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchButton() {
        let search = searchInput.text ?? ""
        searchButton.isEnabled = !search.isEmpty
    }
    
    func updateSearchNearYouStatus() {
        if !CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            searchNearYouButton.isEnabled = false
            searchNearYouErrorLabel.isHidden = false
        }
        else {
            searchNearYouButton.isEnabled = true
            searchNearYouErrorLabel.isHidden = true
        }
    }
    
    @IBAction func searchValueChanged(_ sender: UITextField) {
        updateSearchButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beginSearch" {
            let navigationController = segue.destination as? UINavigationController
            let searchResultTableViewController = navigationController?.viewControllers.first as! SearchResultTableViewController
            let searchKeyword = searchInput.text!
            searchResultTableViewController.searchKeyword = searchKeyword
            searchResultTableViewController.token = token
        }
        else if segue.identifier == "beginNearbySearch" {
            let navigationController = segue.destination as? UINavigationController
            let searchResultTableViewController = navigationController?.viewControllers.first as! SearchResultTableViewController
            
            if let location = locationManager.location {
                currentLocation = location.coordinate
            }
            searchResultTableViewController.currentLocation = currentLocation
        }
    }
}

