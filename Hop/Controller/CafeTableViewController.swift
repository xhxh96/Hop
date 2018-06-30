import UIKit
import MapKit

class CafeTableViewController: UITableViewController {
    var selectedCafe: JSON!
    var cafeObject: Cafe!
    var rawCafeHours = [JSON]()
    var databaseCafeData = [JSON]()
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var bloggerReviews: [Reviews] = [Reviews(name: "Lady Iron Chef", description: "Lady Iron Chef's description", date: Date.init(), url: nil), Reviews(name: "Daniel Food Diary", description: "Daniel Food Diary's description", date: Date.init(), url: nil)]
    var hopperReviews: [Reviews] = [Reviews(name: "John", description: "John's Review", date: Date.init(), url: nil), Reviews(name: "Mary", description: "Mary's Review", date: Date.init(), url: nil)]
    
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var bloggerRatingStars: [UIImageView]!
    @IBOutlet var hopperRatingStars: [UIImageView]!
    @IBOutlet weak var sliderScrollView: UIScrollView!
    @IBOutlet weak var sliderPageControl: UIPageControl!
    @IBOutlet weak var bloggerReviewScrollView: UIScrollView!
    @IBOutlet weak var bloggerReviewPageControl: UIPageControl!
    @IBOutlet weak var hopperReviewScrollView: UIScrollView!
    @IBOutlet weak var hopperReviewPageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        mapView.delegate = self
        
        print(selectedCafe["venue"]["id"])
        loadCafeFromDatabase(cafeName: selectedCafe["venue"]["name"].string!)
        cafeObject = createCafeObject()
        updateSlider()
        updateLabel()
        updateMap()
        updateRating()
        updateBloggerReview()
        updateHopperReview()
        
        // autoSlider Timer
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(autoSlider), userInfo: nil, repeats: true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Functions
    func loadCafeFromDatabase(cafeName: String) {
        let formattedSearchInput = cafeName.replacingOccurrences(of: " ", with: "%20")
        let url: String = "https://hopdbserver.herokuapp.com/cafe?name=\(formattedSearchInput)"
        print(url)
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            // fix internet connection error
            let json = JSON(data: data!)
            self.databaseCafeData = json.arrayValue
        })
        
        task.resume()
    }
    
    func createCafeObject() -> Cafe {
        let cafeName = selectedCafe["venue"]["name"].string
        let cafeAddress = selectedCafe["venue"]["location"]["formattedAddress"][0].string
        let bloggerRating = 3.0
        let hopperRating = 1.0
        let latitude = selectedCafe["venue"]["location"]["lat"].double
        let longitude = selectedCafe["venue"]["location"]["lng"].double
        
        return Cafe(name: cafeName!, address: cafeAddress!, bloggerRating: bloggerRating, hopperRating: hopperRating, latitude: latitude!, longitude: longitude!)
    }

    func updateLabel() {
        cafeNameLabel.text = cafeObject.name
        cafeAddressLabel.text = cafeObject.address
    }
    
    func updateMap() {
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
    
    func updateSlider() {
        sliderPageControl.numberOfPages = cafeObject.images.count
        
        for index in 0..<cafeObject.images.count {
            frame.origin.x = sliderScrollView.frame.size.width * CGFloat(index)
            print(sliderScrollView.frame.size.width)
            frame.size = sliderScrollView.frame.size
            
            let image = UIImageView(frame: frame)
            image.contentMode = .scaleAspectFill
            image.image = UIImage(named: cafeObject.images[index])
            sliderScrollView.addSubview(image)
        }
        sliderScrollView.contentSize = CGSize(width: sliderScrollView.frame.size.width * CGFloat(cafeObject.images.count), height: sliderScrollView.frame.size.height)
        sliderScrollView.delegate = self
        sliderPageControl.currentPage = 0
    }
    
    func updateBloggerReview() {
        bloggerReviewPageControl.numberOfPages = bloggerReviews.count
        
        for index in 0..<bloggerReviews.count {
            frame.origin.x = bloggerReviewScrollView.frame.size.width * CGFloat(index)
            frame.size = bloggerReviewScrollView.frame.size
            
            //title label
            let titleLabelFrame = CGRect(x: frame.origin.x, y: 0, width: frame.width, height: frame.height/2)
            let titleLabel = UILabel(frame: titleLabelFrame)
            titleLabel.text = bloggerReviews[index].name
            titleLabel.numberOfLines = 1
            titleLabel.textAlignment = .center
            bloggerReviewScrollView.addSubview(titleLabel)
            
            //descriptions label
            let descriptionLabelFrame = CGRect(x: frame.origin.x, y: frame.height / 2, width: frame.width, height: frame.height / 2)
            let descriptionLabel = UILabel(frame: descriptionLabelFrame)
            descriptionLabel.text = bloggerReviews[index].description
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textAlignment = .justified
            bloggerReviewScrollView.addSubview(descriptionLabel)
        }
        bloggerReviewScrollView.contentSize = CGSize(width: bloggerReviewScrollView.frame.size.width * CGFloat(bloggerReviews.count), height: bloggerReviewScrollView.frame.size.height)
        bloggerReviewScrollView.delegate = self
    }
    
    func updateHopperReview() {
        hopperReviewPageControl.numberOfPages = hopperReviews.count
        
        for index in 0..<hopperReviews.count {
            frame.origin.x = hopperReviewScrollView.frame.size.width * CGFloat(index)
            frame.size = hopperReviewScrollView.frame.size
            
            //title label
            let titleLabelFrame = CGRect(x: frame.origin.x, y: 0, width: frame.width, height: frame.height/4)
            let titleLabel = UILabel(frame: titleLabelFrame)
            titleLabel.text = hopperReviews[index].name
            titleLabel.numberOfLines = 1
            hopperReviewScrollView.addSubview(titleLabel)
            
            //descriptions label
            let descriptionLabelFrame = CGRect(x: frame.origin.x, y: frame.height / 2, width: frame.width, height: frame.height / 2)
            let descriptionLabel = UILabel(frame: descriptionLabelFrame)
            descriptionLabel.text = hopperReviews[index].description
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textAlignment = .justified
            hopperReviewScrollView.addSubview(descriptionLabel)
        }
        hopperReviewScrollView.contentSize = CGSize(width: hopperReviewScrollView.frame.size.width * CGFloat(hopperReviews.count), height: hopperReviewScrollView.frame.size.height)
        hopperReviewScrollView.delegate = self
    }
    
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
    
    @objc func autoSlider() {
        let maxWidth: CGFloat = sliderScrollView.frame.width * CGFloat(cafeObject.images.count)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

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
