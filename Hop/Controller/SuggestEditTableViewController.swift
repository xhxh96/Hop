import UIKit

class SuggestEditTableViewController: UITableViewController {
    @IBOutlet weak var cafeNameTextField: UITextField!
    @IBOutlet weak var cafeAddressTextField: UITextField!
    @IBOutlet weak var cafePostalCodeTextField: UITextField!
    
    var cafe: Cafe!
    var amenities = [Int].init()
    let amenitiesIndexSection = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amenities = cafe.serializeAmenities()
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
        cafeNameTextField.text = cafe.name
        cafeAddressTextField.text = cafe.address
        cafePostalCodeTextField.text = cafe.postalCode
        
        for index in 0..<amenities.count {
            let indexPath = IndexPath(row: index, section: amenitiesIndexSection)
            let cell = tableView.cellForRow(at: indexPath)
            
            if amenities[index] == 2 {
                cell?.accessoryType = .checkmark
            }
            else {
                cell?.accessoryType = .none
            }
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == amenitiesIndexSection {
            let cell = tableView.cellForRow(at: indexPath)
            
            if amenities[indexPath.row] == 2{
                amenities[indexPath.row] = 1
                cell?.accessoryType = .none
            }
            else {
                amenities[indexPath.row] = 2
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        cafe.deserializeAmenities(with: amenities)
        
        NetworkController.shared.submitEdit(cafe: cafe, with: NetworkSession.shared.token!) { (response) in
            if let response = response, response.success {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alertController = UIAlertController(title: "Submission Success", message: "Your updates will be reviewed and verified by our staffs.", preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(dismissAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alertController = UIAlertController(title: "Submission Error", message: "Your updates could not be submitted. Please try again later.", preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(dismissAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
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
