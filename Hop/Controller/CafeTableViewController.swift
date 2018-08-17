import UIKit
import MapKit

class CafeTableViewController: UITableViewController, CLLocationManagerDelegate {
    var selectedCafe: JSON!
    var cafeObject: Cafe!
    var bloggerReview: [BloggerReview]?
    var hopperReview: [HopperReview]?
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet var bloggerRatingStars: [UIImageView]!
    @IBOutlet var hopperRatingStars: [UIImageView]!
    @IBOutlet var amenitiesIndicator: [UIImageView]!
    
    @IBOutlet weak var sliderContentView: UIView!
    @IBOutlet weak var sliderScrollView: UIScrollView!
    @IBOutlet weak var sliderPageControl: UIPageControl!
    @IBOutlet weak var bloggerReviewScrollView: UIScrollView!
    @IBOutlet weak var bloggerReviewPageControl: UIPageControl!
    @IBOutlet weak var bloggerReviewShowAllButton: UIButton!
    @IBOutlet weak var hopperReviewScrollView: UIScrollView!
    @IBOutlet weak var hopperReviewPageControl: UIPageControl!
    @IBOutlet weak var hopperReviewShowAllButton: UIButton!
    @IBOutlet var shopHourLabels: [UILabel]!
    @IBOutlet weak var actionCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        
        mapView.delegate = self
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let activityViewController = ActivityViewController(message: "Loading...")
        present(activityViewController, animated: true) {
            NetworkController.shared.fetchCafeFromDatabase(cafe: self.selectedCafe, with: NetworkSession.shared.token!) { (cafe) in
                self.cafeObject = cafe
                
                DispatchQueue.main.async {
                    self.title = self.cafeObject.name
                    self.updateSlider()
                    self.updateLabel()
                    self.updateRating()
                    self.updateAmenities()
                    self.updateMap()
                    
                    // autoSlider Timer
                    Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.autoSlider), userInfo: nil, repeats: true)
                }
                
                NetworkController.shared.fetchBloggerReviewFromDatabase(cafe: self.selectedCafe, with: NetworkSession.shared.token!, completion: { (bloggerReview) in
                    self.bloggerReview = bloggerReview
                    
                    DispatchQueue.main.async {
                        self.updateBloggerReview()
                    }
                    
                    NetworkController.shared.fetchHopperReviewFromDatabase(cafe: self.selectedCafe, with: NetworkSession.shared.token!, completion: { (hopperReview) in
                        self.hopperReview = hopperReview
                        DispatchQueue.main.async {
                            self.updateHopperReview()
                            activityViewController.dismiss(animated: true, completion: nil)
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    })
                })
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Function
    func updateLabel() {
        cafeNameLabel.text = cafeObject.name
        cafeAddressLabel.text = cafeObject.address
        
        priceRangeLabel.text = cafeObject.priceRange == -1 ? "No data available" :  String(repeating: "💲", count: cafeObject.priceRange)
        priceRangeLabel.font = cafeObject.priceRange == -1 ? UIFont.systemFont(ofSize: 17) : UIFont.systemFont(ofSize: 25)
        
        websiteButton.isHidden = cafeObject.url == nil ? true : false
        
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        
        for index in 0..<cafeObject.shopHours.count {
            if cafeObject.shopHours[index].isOpened{
                shopHourLabels[index].text = "\(cafeObject.shopHours[index].open) - \(cafeObject.shopHours[index].closed)"
            }
            else {
                shopHourLabels[index].text = "Closed"
            }
            
            if index == dayOfWeek - 1 {
                shopHourLabels[index].font = UIFont.boldSystemFont(ofSize: 17)
            }
        }
        
    }
    
    func updateMap() {
        let latitude = cafeObject.latitude
        let longitude = cafeObject.longitude
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let regionRadius: CLLocationDistance = 250
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        let mapAnnotation = MapAnnotation(title: cafeObject.name, address: cafeObject.address, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(mapAnnotation)
    }
    
    func updateRating() {
        if let rating = cafeObject.bloggerRating {
            guard rating != -1 else {
                return
            }
            
            for index in 0..<Int(rating) {
                bloggerRatingStars[index].alpha = 1
            }
        }
        
        
        if let rating = cafeObject.hopperRating {
            guard rating != -1 else {
                return
            }
            
            for index in 0..<Int(rating) {
                hopperRatingStars[index].alpha = 1
            }
        }
    }
    
    func updateAmenities() {
        let amenities = cafeObject.serializeAmenities()
        
        for index in 0..<amenities.count {
            if amenities[index] == 2 {
                amenitiesIndicator[index].alpha = 1
            }
            else {
                amenitiesIndicator[index].alpha = 0.2
            }
        }
    }
    
    func updateSlider() {
        sliderPageControl.numberOfPages = cafeObject.images.count
        
        for index in 0..<cafeObject.images.count {
            frame.origin.x = sliderScrollView.frame.size.width * CGFloat(index)
            frame.size = sliderScrollView.frame.size
            
            let image = UIImageView(frame: frame)
            image.contentMode = .scaleAspectFill
            
            let imageURL = URL(string: cafeObject.images[index])
            let imageData = try? Data(contentsOf: imageURL!)
            image.image = UIImage(data: imageData!)
            
            sliderScrollView.addSubview(image)
        }
        sliderScrollView.contentSize = CGSize(width: sliderScrollView.frame.size.width * CGFloat(cafeObject.images.count), height: sliderScrollView.frame.size.height)
        sliderScrollView.delegate = self
        sliderPageControl.currentPage = 0
    }
    
    
    func updateBloggerReview() {
        guard var reviews = bloggerReview, reviews.count > 0 else {
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
            
            BloggerReview.removeNewLine(review: &bloggerReview![index])
            BloggerReview.removeNewLine(review: &reviews[index])
            
            //title label
            let titleLabelFrame = CGRect(x: frame.origin.x, y: 0, width: frame.width, height: frame.height/2)
            let titleLabel = UILabel(frame: titleLabelFrame)
            titleLabel.text = reviews[index].title
            titleLabel.numberOfLines = 1
            titleLabel.textAlignment = .center
            bloggerReviewScrollView.addSubview(titleLabel)
            
            //description label
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
    
    
     func updateHopperReview() {
        guard let reviews = hopperReview, reviews.count > 0 else {
            hopperReviewPageControl.isHidden = true
            hopperReviewShowAllButton.isHidden = true
            frame.origin.x = 0
            frame.size = hopperReviewScrollView.frame.size
            
            let titleLabelFrame = CGRect(x: frame.origin.x, y: 0, width: frame.width, height: frame.height)
            let titleLabel = UILabel(frame: titleLabelFrame)
            titleLabel.text = "No reviews from hoppers for this café yet ..."
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
            
            //description label
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
        let maxWidth: CGFloat = sliderScrollView.frame.width * CGFloat(cafeObject.images.count)
        let contentOffset: CGFloat = sliderScrollView.contentOffset.x
        var slideToX = sliderScrollView.frame.width + contentOffset
        
        if  sliderScrollView.frame.width + contentOffset >= maxWidth {
            slideToX = 0
        }
        
        sliderScrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width: sliderScrollView.frame.width, height:sliderScrollView.frame.height), animated: true)
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
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalRows = super.tableView(tableView, numberOfRowsInSection: section)
        
        let rows = NetworkSession.shared.guest ? totalRows - 1 : totalRows
        
        return rows
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "hopperReview" {
            let hopperReviewTableViewController = segue.destination as! HopperReviewTableViewController
            hopperReviewTableViewController.reviews = hopperReview!
        }
        else if segue.identifier == "bloggerReview" {
            let bloggerReviewTableViewController = segue.destination as! BloggerReviewTableViewController
            bloggerReviewTableViewController.reviews = bloggerReview!
        }
        else if segue.identifier == "submitReview" {
            let navigationController = segue.destination as? UINavigationController
            let submitReviewTableViewController = navigationController?.viewControllers.first as! SubmitReviewTableViewController
            submitReviewTableViewController.cafeObject = cafeObject
        }
        else if segue.identifier == "suggestEdit" {
            let navigationController = segue.destination as? UINavigationController
            let suggestEditTableViewController = navigationController?.viewControllers.first as! SuggestEditTableViewController
            suggestEditTableViewController.cafeObject = cafeObject
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
