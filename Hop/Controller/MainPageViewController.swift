import UIKit
import CoreLocation
import ScalingCarousel

class PopularCafeCell: ScalingCarouselCell {
    
}

class MainPageViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let locationManager = CLLocationManager.init()
    var currentLocation: CLLocationCoordinate2D?
    var cafeOfTheDay: Cafe!
    var popularCafes: [Cafe]!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cafeImage: UIImageView!
    @IBOutlet weak var cafeName: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var signInLogOutButton: UIButton!
    
    @IBOutlet var bloggerRating: [UIImageView]!
    @IBOutlet var hopperRating: [UIImageView]!
    
    @IBOutlet weak var carousel: ScalingCarouselView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupLocationManager()
        setupCafeOfTheDay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let activityViewController = ActivityViewController(message: "Loading...")
        present(activityViewController, animated: true) {
            self.setupInterface()
            self.updateSearchButton()
            activityViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        carousel.deviceRotated()
    }
    
    func updateSearchButton() {
        if !CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            searchButton.isEnabled = false
        }
        else {
            searchButton.isEnabled = true
        }
    }
    
    func setupCafeOfTheDay() {
        // Setup image and label
        let imageURL = URL(string: cafeOfTheDay.images.first!)
        let imageData = try? Data(contentsOf: imageURL!)
        
        if let image = imageData {
            cafeImage.image = UIImage(data: image)
        }
        cafeName.text = cafeOfTheDay.name
        
        // Setup ratings in café of the day card
        if let rating = cafeOfTheDay.bloggerRating {
            if rating != -1 {
                for index in 0..<Int(rating) {
                    bloggerRating[index].alpha = 1
                }
            }
        }
        
        if let rating = cafeOfTheDay.hopperRating {
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
    
    func setupInterface() {
        // Setup function buttons
        if NetworkSession.shared.guest {
            profileButton.isHidden = true
            signInLogOutButton.setTitle("Sign In", for: .normal)
        }
        else {
            profileButton.isHidden = false
            signInLogOutButton.setTitle("Sign Out", for: .normal)
        }
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
            NetworkSession.shared.resetSession()
            
            NetworkController.shared.fetchNoLoginToken { (token) in
                NetworkSession.shared.token = token
                UserDefaults.standard.removeObject(forKey: "UserSession")
                
                DispatchQueue.main.async {
                    self.viewDidAppear(true)
                }
            }
        }
    }
    
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularCafes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCafeCell", for: indexPath)
        
        if let carouselCell = cell as? ScalingCarouselCell {
            let views = carouselCell.mainView.subviews
            
            for view in views {
                if let labelView = view as? UILabel {
                    labelView.text = popularCafes[indexPath.row].name
                }
                
                if let imageView = view as? UIImageView {
                    let imageURL = URL(string: popularCafes[indexPath.row].images.first!)
                    let imageData = try? Data(contentsOf: imageURL!)
                    
                    guard let data = imageData else {
                        continue
                    }
                    imageView.image = UIImage(data: data)
                    imageView.layer.cornerRadius = 20.0
                    imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                }
            }
        }
        
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    // MARK: - Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carousel.didScroll()
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
        else if segue.identifier == "popularCafeDetails" {
            let cafeTableViewController = segue.destination as? CafeTableViewController
            let indexPath = (carousel.indexPathsForSelectedItems?.first)!
            let selectedCafe = popularCafes[indexPath.row]
            print(selectedCafe.name)
            cafeTableViewController?.selectedCafeId = selectedCafe.fsVenueId
        }
    }
}
