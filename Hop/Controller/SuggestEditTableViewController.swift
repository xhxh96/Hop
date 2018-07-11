import UIKit

class SuggestEditTableViewController: UITableViewController {
    @IBOutlet weak var cafeNameTextField: UITextField!
    @IBOutlet weak var cafeAddressTextField: UITextField!
    @IBOutlet weak var cafePostalCodeTextField: UITextField!
    
    var cafeObject: Cafe!
    let amenitiesIndexSection = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        cafeNameTextField.text = cafeObject.name
        cafeAddressTextField.text = cafeObject.address
        cafePostalCodeTextField.text = cafeObject.postalCode
        
        
        for index in 0..<cafeObject.amenities.count {
            let indexPath = IndexPath(row: index, section: amenitiesIndexSection)
            let cell = tableView.cellForRow(at: indexPath)
            
            if cafeObject.amenities[index] {
                cell?.accessoryType = .checkmark
            }
            else {
                cell?.accessoryType = .none
            }
        }
        tableView.reloadData()
    }
    
    func submitEdit(cafe: Cafe, completion: ((Error?) -> Void)?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url: String = "https://hopdbserver.herokuapp.com/cafe/data"
        
        guard let requestURL = URL(string: url) else {
            print("Invalid request")
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder.init()
        
        do {
            let data = try jsonEncoder.encode(cafe)
            request.httpBody = data
            print("JSONData:", String(data: request.httpBody!, encoding: .utf8) ?? "JSON object is not created")
        }
        catch {
            completion?(error)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion?(error!)
                return
            }
            
            if let data = data, let acknowledgment = String(data: data, encoding: .utf8) {
                print("SUGGEST EDIT SERVER Response: ", acknowledgment)
            }
            else {
                print("SUGGEST EDIT SERVER WARNING: No data response received from server.")
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                let alertController = UIAlertController(title: "Thanks For Your Updates", message: "Your updates will be reviewed and verified by our staffs.", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(dismissAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == amenitiesIndexSection {
            let cell = tableView.cellForRow(at: indexPath)
            
            if cafeObject.amenities[indexPath.row] {
                cafeObject.amenities[indexPath.row] = false
                cell?.accessoryType = .none
            }
            else {
                cafeObject.amenities[indexPath.row] = true
                cell?.accessoryType = .checkmark
            }
            tableView.reloadData()
        }
        else {
            return
        }
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        submitEdit(cafe: cafeObject) { (error) in
            if let error = error {
                print("error present")
                fatalError(error.localizedDescription)
            }
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
