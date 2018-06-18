import UIKit
import CoreLocation

let client_id = "NAT0ERZ20UEDFBBYWC3LFXTT0QPGH2GU4WEZ1PNI3QO22GRD"
let client_secret = "YVG0G3PFL2CFDOMIQLGJTMLXSQ0VGP3FOAPEY2UUUEAUC0FZ"

class SearchResultTableViewController: UITableViewController {
    //var searchResults: [SearchResult] = [SearchResult(name: "Cafe A", address: "Address A", description: "Description A"), SearchResult(name: "Cafe B", address: "Address B", description: "Description B")]

    var searchKeyword: String?
    var searchResults = [JSON]()
    var currentLocation:CLLocationCoordinate2D!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchForCoffee()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! SearchResultTableViewCell
        
        cell.cafeNameLabel.text = searchResults[indexPath.row]["venue"]["name"].string
        
        /*
        var addressString = String.init()
        
        for i in 0...searchResults[indexPath.row]["venue"]["location"]["formattedAddress"].count {
            addressString += (searchResults[indexPath.row]["venue"]["location"]["formattedAddress"][i].string! + " ")
        }
         */
        
        cell.cafeAddressLabel.text = searchResults[indexPath.row]["venue"]["location"]["formattedAddress"][0].string
        
        return cell
    }
    
    func searchForCoffee() {
        let formattedSearchInput = searchKeyword?.replacingOccurrences(of: " ", with: "-")
        // to implement guard for input in URL
        let url = "https://api.foursquare.com/v2/search/recommendations?near=\(formattedSearchInput ?? "Singapore")&v=20180617&categoryId=4bf58dd8d48988d16d941735&limit=15&client_id=\(client_id)&client_secret=\(client_secret)"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            
            let json = JSON(data: data!)
            self.searchResults = json["response"]["group"]["results"].arrayValue
            
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        })
        
        task.resume()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
