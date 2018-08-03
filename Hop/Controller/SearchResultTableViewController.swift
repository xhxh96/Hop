import UIKit
import CoreLocation

let client_id = "NAT0ERZ20UEDFBBYWC3LFXTT0QPGH2GU4WEZ1PNI3QO22GRD"
let client_secret = "YVG0G3PFL2CFDOMIQLGJTMLXSQ0VGP3FOAPEY2UUUEAUC0FZ"

class SearchResultTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchKeyword: String?
    var cafeResults = [JSON]()
    var currentLocation: CLLocationCoordinate2D?
    var counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //searchForCoffee()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.fetchFromFourSquare(keyword: searchKeyword, location: currentLocation) { (data) in
            self.cafeResults = data["response"]["group"]["results"].arrayValue
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.tableView.reloadData()
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

    
    
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafeResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! SearchResultTableViewCell
        
        let name = cafeResults[indexPath.row]["venue"]["name"].string
        let address = cafeResults[indexPath.row]["venue"]["location"]["formattedAddress"][0].string
        
        guard let thumbnailURL = generateThumbnailURL(at: indexPath) else {
            cell.updateLabel(thumbnail: nil, name: name, address: address)
            return cell
        }
        
        NetworkController.shared.fetchThumbnail(url: thumbnailURL) { (image) in
            DispatchQueue.main.async {
                if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath != indexPath {
                    return
                }
                cell.updateLabel(thumbnail: image, name: name, address: address)
            }
        }
        return cell
    }
    
    func generateThumbnailURL(at indexPath: IndexPath) -> URL? {
        if let prefixURL = cafeResults[indexPath.row]["photo"]["prefix"].string, let suffixURL = cafeResults[indexPath.row]["photo"]["suffix"].string, let imageURL = URL(string: prefixURL + "90x90" + suffixURL) {
            
            return imageURL
        }
        else {
            return nil
        }
    }
    
    func fetchSearchResult() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var searchKeyword: String?
        
        if (searchBar.text?.isEmpty)! {
            searchKeyword = nil
        }
        else {
            searchKeyword = searchBar.text
        }
        
        NetworkController.shared.fetchFromFourSquare(keyword: searchKeyword, location: currentLocation) { (data) in
            self.cafeResults = data["response"]["group"]["results"].arrayValue
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cafeDetails" {
            let cafeTableViewController = segue.destination as! CafeTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedCafe = cafeResults[indexPath.row]
            cafeTableViewController.selectedCafe = selectedCafe
        }
    }
}

extension SearchResultTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchSearchResult()
        searchBar.resignFirstResponder()
    }
}
