import UIKit
import MapKit

enum ScrollView: Int {
    case slider
    case bloggerReview
    case hopperReview
    
    static let count: Int = {
        var max: Int = 0
        while let _ = ScrollView(rawValue: max) {
            max += 1
        }
        return max
    }()
}


class CafeTableViewController: UITableViewController {
    var selectedCafe: JSON!
    var cafeObject: Cafe!
    var rawCafeHours = [JSON]()
    var databaseCafeData: JSON!
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var updateScrollView = [Bool].init(repeating: false, count: ScrollView.count)
    
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var bloggerRatingStars: [UIImageView]!
    @IBOutlet var hopperRatingStars: [UIImageView]!
    
    
    @IBOutlet weak var sliderContentView: UIView!
    @IBOutlet weak var sliderScrollView: UIScrollView!
    @IBOutlet weak var sliderPageControl: UIPageControl!
    @IBOutlet weak var bloggerReviewScrollView: UIScrollView!
    @IBOutlet weak var bloggerReviewPageControl: UIPageControl!
    @IBOutlet weak var bloggerReviewShowAllButton: UIButton!
    @IBOutlet weak var hopperReviewScrollView: UIScrollView!
    @IBOutlet weak var hopperReviewPageControl: UIPageControl!
    @IBOutlet weak var hopperReviewShowAllButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        mapView.delegate = self
        
        fetchCafeFromDatabase { (cafe) in
            print(cafe)
            self.cafeObject = cafe
            //self.cafeObject = cafe
            DispatchQueue.main.async {
                self.updateLabel(cafeObject: cafe)
                self.updateMap(cafeObject: cafe)
            }
            
        }
        
        fetchBloggerReviewFromDatabase { (bloggerReview) in
            DispatchQueue.main.async {
                self.updateBloggerReview(reviews: bloggerReview)
            }
        }
        
        // autoSlider Timer
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(autoSlider), userInfo: nil, repeats: true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if updateScrollView[ScrollView.slider.rawValue] == false {
            updateSlider()
            updateScrollView[ScrollView.slider.rawValue] = true
        }
        
        /*
        if updateScrollView[ScrollView.bloggerReview.rawValue] == false {
            updateBloggerReview()
            updateScrollView[ScrollView.bloggerReview.rawValue] = true
        }
        
        if updateScrollView[ScrollView.hopperReview.rawValue] == false {
            updateHopperReview()
            updateScrollView[ScrollView.hopperReview.rawValue] = true
        }
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Function
    func fetchCafeFromDatabase(completion: @escaping (Cafe) -> Void) {
        let venueId = selectedCafe["venue"]["id"].string
        let url: String = "https://hopdbserver.herokuapp.com/cafe/data?fsVenueId=\(venueId!)"
        print(url)
        
        guard let requestURL = URL(string: url) else {
            print("Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) {data, response, error -> Void in
            let jsonDecoder = JSONDecoder.init()
            if let data = data, let cafeObject = try? jsonDecoder.decode(Cafe.self, from: data) {
                completion(cafeObject)
            }
            else {
                print("No JSON Object found, or unable to map JSON Object to model")
                return
            }
        }
        
        task.resume()
    }
    
    func fetchBloggerReviewFromDatabase(completion: @escaping ([BloggerReview]) -> Void) {
        let venueId = selectedCafe["venue"]["id"].string
        let url: String = "https://hopdbserver.herokuapp.com/cafe/review/blogger&fsVenueId=\(venueId!)"
        
        guard let requestURL = URL(string: url) else {
            print("Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder.init()
            if let data = data, let bloggerReview = try? jsonDecoder.decode([BloggerReview].self, from: data) {
                completion(bloggerReview)
            }
            else {
                print("No JSON Object found, or unable to map JSON Object to model")
                return
            }
        }
        task.resume()
    }
    
    func fetchHopperReviewFromDatabase(completion: @escaping ([HopperReview]) -> Void) {
        let venueId = selectedCafe["venue"]["id"].string
        let url: String = "https://hopdbserver.herokuapp.com/cafe/review/hopper&fsVenueId=\(venueId!)"
        
        guard let requestURL = URL(string: url) else {
            print("Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder.init()
            if let data = data, let hopperReview = try? jsonDecoder.decode([HopperReview].self, from: data) {
                completion(hopperReview)
            }
            else {
                print("No JSON Object found, or unable to map JSON Object to model")
                return
            }
        }
        task.resume()
    }

    func updateLabel(cafeObject: Cafe) {
        cafeNameLabel.text = cafeObject.name
        cafeAddressLabel.text = cafeObject.address
    }
    
    func updateMap(cafeObject: Cafe) {
        let latitude = cafeObject.latitude
        let longitude = cafeObject.longitude
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let regionRadius: CLLocationDistance = 250
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        let mapAnnotation = MapAnnotation(title: cafeNameLabel.text!, address: cafeAddressLabel.text!, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(mapAnnotation)
    }
    
    func updateRating() {
        if let rating = cafeObject.bloggerRating {
            for index in 0..<Int(rating) {
                bloggerRatingStars[index].alpha = 1
            }
        }
        
        if let rating = cafeObject.hopperRating {
            for index in 0..<Int(rating) {
                hopperRatingStars[index].alpha = 1
            }
        }
    }
    
    
    // Replace 3 with cafeObject.image.count
    func updateSlider() {
        sliderPageControl.numberOfPages = 3
        
        for index in 0..<3 {
            frame.origin.x = sliderScrollView.frame.size.width * CGFloat(index)
            frame.size = sliderScrollView.frame.size
            
            let image = UIImageView(frame: frame)
            image.contentMode = .scaleAspectFill
            
            let images = ["dummy-0", "dummy-1", "dummy-2"]
            image.image = UIImage(named: images[index])
            
            /*
            let imageURL = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CmRaAAAA10yYfIiZtWt0FxqBn7v78NTbvTdBrAM46zxZEDyQN41PBNyEuUkJZWrgGoERINRLeVzqse51GXkbwvp5wqQnj70afEJ5-KUxAwqT50O2baJyu1BSb-P40LLzyYY6tOsxEhDvmPR9Y9hREBx9pf5nUp9gGhQ160aZhbv28YeRQSp_rUtyBVG-xg&key=AIzaSyBC27_6Izl4kLVnVH4mU2O588Kn8eL-uXg")
            
            let imageData = try? Data(contentsOf: imageURL!)
            image.image = UIImage(data: imageData!)
             */
 
            
            sliderScrollView.addSubview(image)
        }
        sliderScrollView.contentSize = CGSize(width: sliderScrollView.frame.size.width * CGFloat(3), height: sliderScrollView.frame.size.height)
        sliderScrollView.delegate = self
        sliderPageControl.currentPage = 0
    }
    
    
    func updateBloggerReview(reviews: [BloggerReview]) {
        guard reviews.count > 0 else {
            bloggerReviewPageControl.isHidden = true
            bloggerReviewShowAllButton.isHidden = true
            frame.origin.x = 0
            frame.size = bloggerReviewScrollView.frame.size
            
            let titleLabelFrame = CGRect(x: frame.origin.x, y: 0, width: frame.width, height: frame.height)
            let titleLabel = UILabel(frame: titleLabelFrame)
            titleLabel.text = "No reviews from bloggers for this café yet ..."
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            bloggerReviewScrollView.addSubview(titleLabel)
            
            return
        }
        
        bloggerReviewPageControl.numberOfPages = reviews.count
        
        for index in 0..<reviews.count {
            frame.origin.x = bloggerReviewScrollView.frame.size.width * CGFloat(index)
            frame.size = bloggerReviewScrollView.frame.size
            
            //title label
            let titleLabelFrame = CGRect(x: frame.origin.x, y: 0, width: frame.width, height: frame.height/2)
            let titleLabel = UILabel(frame: titleLabelFrame)
            titleLabel.text = reviews[index].reviewSite
            titleLabel.numberOfLines = 1
            titleLabel.textAlignment = .center
            bloggerReviewScrollView.addSubview(titleLabel)
            
            //descriptions label
            let descriptionLabelFrame = CGRect(x: frame.origin.x, y: frame.height / 2, width: frame.width, height: frame.height / 2)
            let descriptionLabel = UILabel(frame: descriptionLabelFrame)
            descriptionLabel.text = reviews[index].extract
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textAlignment = .justified
            descriptionLabel.font = UIFont.systemFont(ofSize: 12)
            bloggerReviewScrollView.addSubview(descriptionLabel)
        }
        bloggerReviewScrollView.contentSize = CGSize(width: bloggerReviewScrollView.frame.size.width * CGFloat(reviews.count), height: bloggerReviewScrollView.frame.size.height)
        bloggerReviewScrollView.delegate = self
    }
    
    
     func updateHopperReview(reviews: [HopperReview]) {
        guard reviews.count > 0 else {
            hopperReviewPageControl.isHidden = true
            hopperReviewShowAllButton.isHidden = true
            frame.origin.x = 0
            frame.size = hopperReviewScrollView.frame.size
            
            let titleLabelFrame = CGRect(x: frame.origin.x, y: 0, width: frame.width, height: frame.height)
            let titleLabel = UILabel(frame: titleLabelFrame)
            titleLabel.text = "No reviews from bloggers for this café yet ..."
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            hopperReviewScrollView.addSubview(titleLabel)
            
            return
        }
        
        hopperReviewPageControl.numberOfPages = reviews.count
        
        for index in 0..<reviews.count {
            frame.origin.x = hopperReviewScrollView.frame.size.width * CGFloat(index)
            frame.size = hopperReviewScrollView.frame.size
            
            //title label
            let titleLabelFrame = CGRect(x: frame.origin.x, y: 0, width: frame.width, height: frame.height/4)
            let titleLabel = UILabel(frame: titleLabelFrame)
            titleLabel.text = reviews[index].userId
            titleLabel.numberOfLines = 1
            titleLabel.textAlignment = .center
            hopperReviewScrollView.addSubview(titleLabel)
            
            //descriptions label
            let descriptionLabelFrame = CGRect(x: frame.origin.x, y: frame.height / 2, width: frame.width, height: frame.height / 2)
            let descriptionLabel = UILabel(frame: descriptionLabelFrame)
            descriptionLabel.text = reviews[index].content
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textAlignment = .justified
            descriptionLabel.font = UIFont.systemFont(ofSize: 10)
            hopperReviewScrollView.addSubview(descriptionLabel)
        }
        hopperReviewScrollView.contentSize = CGSize(width: hopperReviewScrollView.frame.size.width * CGFloat(reviews.count), height: hopperReviewScrollView.frame.size.height)
        hopperReviewScrollView.delegate = self
    }
    
 
    
    @objc func autoSlider() {
        let maxWidth: CGFloat = sliderScrollView.frame.width * CGFloat(3)
        let contentOffset: CGFloat = sliderScrollView.contentOffset.x
        var slideToX = sliderScrollView.frame.width + contentOffset
        
        if  sliderScrollView.frame.width + contentOffset >= maxWidth {
            slideToX = 0
        }
        
        sliderScrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width: sliderScrollView.frame.width, height:sliderScrollView.frame.height), animated: true)
    }
    
    func listOpeningHours() {
        let venueId = selectedCafe["venue"]["id"].string!
        
        let url = "https://api.foursquare.com/v2/venues/\(venueId)/hours?client_id=\(client_id)&client_secret=\(client_secret)"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            
            let json = JSON(data: data!)
            print(json)
            self.rawCafeHours = json["response"]["hours"]["timeframes"].arrayValue
        })
        
        task.resume()
    }
 
    
    // MARK: - Delegates
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        
        switch scrollView {
        case sliderScrollView:
            sliderPageControl.currentPage = Int(pageNumber)
        case bloggerReviewScrollView:
            bloggerReviewPageControl.currentPage = Int(pageNumber)
        case hopperReviewScrollView:
            hopperReviewPageControl.currentPage = Int(pageNumber)
        default:
            break
        }
    }

    
    // MARK: - Action Outlets
    @IBAction func pageChanged(_ sender: UIPageControl) {
        let pageNumber = sender.currentPage
        
        if sender == sliderPageControl {
            var frame = sliderScrollView.frame
            frame.origin.x = frame.size.width * CGFloat(pageNumber)
            frame.origin.y = 0
            sliderScrollView.scrollRectToVisible(frame, animated: true)
        }
        else if sender == bloggerReviewPageControl {
            var frame = bloggerReviewScrollView.frame
            frame.origin.x = frame.size.width * CGFloat(pageNumber)
            frame.origin.y = 0
            bloggerReviewScrollView.scrollRectToVisible(frame, animated: true)
        }
        else if sender == hopperReviewPageControl {
            var frame = hopperReviewScrollView.frame
            frame.origin.x = frame.size.width * CGFloat(pageNumber)
            frame.origin.y = 0
            hopperReviewScrollView.scrollRectToVisible(frame, animated: true)
        }
    }
    
    @IBAction func unwindToCafeTableViewController(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "hopperReview" {
            //let hopperReviewTableViewController = segue.destination as! HopperReviewTableViewController
            //hopperReviewTableViewController.reviews = hopperReviews
        }
        else if segue.identifier == "submitReview" {
            let navigationController = segue.destination as? UINavigationController
            let submitReviewTableViewController = navigationController?.viewControllers.first as! SubmitReviewTableViewController
            submitReviewTableViewController.cafeObject = cafeObject
        }
    }
}

extension CafeTableViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapAnnotation else {
            return nil
        }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            //view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! MapAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
