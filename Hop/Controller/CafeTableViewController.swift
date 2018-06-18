import UIKit
import MapKit

class CafeTableViewController: UITableViewController {
    var selectedCafe: JSON!

    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        updateLabel()
        updateMap()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateLabel() {
        cafeNameLabel.text = selectedCafe["venue"]["name"].string
        cafeAddressLabel.text = selectedCafe["venue"]["location"]["formattedAddress"][0].string
    }
    
    func updateMap() {
        let latitude = selectedCafe["venue"]["location"]["lat"].double
        let longitude = selectedCafe["venue"]["location"]["lng"].double
        
        let location = CLLocation(latitude: latitude!, longitude: longitude!)
        let regionRadius: CLLocationDistance = 250
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        let mapAnnotation = MapAnnotation(title: cafeNameLabel.text!, address: cafeAddressLabel.text!, coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(mapAnnotation)
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
