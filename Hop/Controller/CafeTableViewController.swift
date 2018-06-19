import UIKit
import MapKit

class CafeTableViewController: UITableViewController {
    var selectedCafe: JSON!
    var cafeObject: Cafe!
    var rawCafeHours = [JSON]()
    
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var bloggerReviewStars: [UIImageView]!
    @IBOutlet var hopperReviewStars: [UIImageView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        mapView.delegate = self
        
        cafeObject = createCafeObject()
        updateLabel()
        updateMap()
        updateReviewStatus()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createCafeObject() -> Cafe {
        let cafeName = selectedCafe["venue"]["name"].string
        let cafeAddress = selectedCafe["venue"]["location"]["formattedAddress"][0].string
        let bloggerReview = 3.0
        let hopperReview = 1.0
        let latitude = selectedCafe["venue"]["location"]["lat"].double
        let longitude = selectedCafe["venue"]["location"]["lng"].double
        
        return Cafe(name: cafeName!, address: cafeAddress!, bloggerReview: bloggerReview, hopperReview: hopperReview, latitude: latitude!, longitude: longitude!)
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
    
    func updateReviewStatus() {
        if let rating = cafeObject.bloggerReview {
            for index in 0..<Int(rating) {
                bloggerReviewStars[index].alpha = 1
            }
        }
        
        if let rating = cafeObject.hopperReview {
            for index in 0..<Int(rating) {
                hopperReviewStars[index].alpha = 1
            }
        }
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
