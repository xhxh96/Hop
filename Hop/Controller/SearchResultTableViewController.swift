import UIKit
import CoreLocation

class SearchResultTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchKeyword: String?
    var cafeResults = [JSON]()
    var currentLocation: CLLocationCoordinate2D?
    var searchByKeyword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.fetchFromFourSquare(searchByKeyword: &searchByKeyword, keyword: searchKeyword, location: currentLocation) { (data) in
            
            if self.searchByKeyword {
                self.cafeResults = data.arrayValue
            }
            else {
                self.cafeResults = data["response"]["group"]["results"].arrayValue
            }
            
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
        
        var name: String
        var address: String
        
        if searchByKeyword {
            name = cafeResults[indexPath.row]["name"].string!
            address = cafeResults[indexPath.row]["address"].string!
        }
        else {
            name = cafeResults[indexPath.row]["venue"]["name"].string!
            address = cafeResults[indexPath.row]["venue"]["location"]["formattedAddress"][0].string!
        }
        
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
        if searchByKeyword, let url = cafeResults[indexPath.row]["thumbnail"].string {
            return URL(string: url)
        }
        else if let prefixURL = cafeResults[indexPath.row]["photo"]["prefix"].string, let suffixURL = cafeResults[indexPath.row]["photo"]["suffix"].string, let imageURL = URL(string: prefixURL + "90x90" + suffixURL) {
            
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
        
        NetworkController.shared.fetchFromFourSquare(searchByKeyword: &searchByKeyword, keyword: searchKeyword, location: currentLocation) { (data) in
            
            if self.searchByKeyword {
                self.cafeResults = data.arrayValue
            }
            else {
                self.cafeResults = data["response"]["group"]["results"].arrayValue
            }
            
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
            
            if searchByKeyword {
                cafeTableViewController.selectedCafeId = selectedCafe["fsVenueId"].string
            }
            else {
                cafeTableViewController.selectedCafeId = selectedCafe["venue"]["id"].string
            }
        }
    }
}

extension SearchResultTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchSearchResult()
        searchBar.resignFirstResponder()
    }
}
