import UIKit

class SubmitReviewTableViewController: UITableViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var reviewTextView: UITextView!
    
    var cafeObject: Cafe!
    var userID = "elstonayx"
    
    let dateLabelIndexPath = IndexPath(row: 1, section: 0)
    let datePickerIndexPath = IndexPath(row: 2, section: 0)
    let reviewTextViewIndexPath = IndexPath(row: 1, section: 1)
    
    var datePickerIsShown: Bool = false {
        didSet {
            datePicker.isHidden = !datePickerIsShown
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()

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
        titleLabel.text = cafeObject.name
    }
    
    func updateDateView() {
        datePicker.maximumDate = Date.init()
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateStyle = .medium
        
        dateLabel.text = dateFormatter.string(from: datePicker.date)
    }
    
    func submitReview(review: HopperReview, completion:((Error?) -> Void)?) {
        let url: String = "https://hopdbserver.herokuapp.com/cafe/review"
        
        guard let requestURL = URL(string: url) else {
            print("Invalid request")
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder.init()
        
        do {
            let data = try jsonEncoder.encode(review)
            request.httpBody = data
            print("jsonData:", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        }
        catch {
            completion?(error)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion?(error!)
                return
            }
            
            if let data = data, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            if datePickerIsShown {
                return 165.0
            }
            else {
                return 0
            }
        case reviewTextViewIndexPath:
            return 205.0
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case dateLabelIndexPath:
            if datePickerIsShown {
                datePickerIsShown = false
            }
            else {
                datePickerIsShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let review = HopperReview(fsVenueId: cafeObject.fsVenueId, userId: userID, reviewDate: dateLabel.text!, rating: Int(ratingSlider.value), content: reviewTextView.text)
        submitReview(review: review) { (error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateView()
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
