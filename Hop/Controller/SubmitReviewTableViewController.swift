import UIKit
import HCSStarRatingView

class SubmitReviewTableViewController: UITableViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var ratingSlider: HCSStarRatingView!
    @IBOutlet weak var reviewTextView: UITextView!
    
    var cafe: Cafe?
    var review: HopperReview?
    
    let dateLabelIndexPath = IndexPath(row: 1, section: 0)
    let datePickerIndexPath = IndexPath(row: 2, section: 0)
    let reviewTextViewIndexPath = IndexPath(row: 1, section: 1)
    
    let dateFormatter = DateFormatter.init()
    
    var datePickerIsShown: Bool = false {
        didSet {
            datePicker.isHidden = !datePickerIsShown
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabel() {
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateStyle = .medium
        
        if let cafe = cafe {
            titleLabel.text = cafe.name
            dateLabel.text = dateFormatter.string(from: Date.init())
        }
            
        else if let review = review {
            titleLabel.text = review.cafeName
            dateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: review.reviewDate))
            ratingSlider.value = CGFloat(review.rating)
            reviewTextView.text = review.content
        }
        
    }
    
    func updateDateView() {
        datePicker.maximumDate = Date.init()
        dateLabel.text = dateFormatter.string(from: datePicker.date)
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
        
        if let cafe = cafe {
            let review = HopperReview(fsVenueId: cafe.fsVenueId, cafeName: cafe.name, userId: (NetworkSession.shared.user?.userId)!, reviewDate: datePicker.date.timeIntervalSince1970, rating: Int(ratingSlider.value), content: reviewTextView.text)
            
            NetworkController.shared.submitReview(review: review, with: NetworkSession.shared.token!) { (response) in
                if let response = response, response.success {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        let alertController = UIAlertController(title: "Thanks For Your Review", message: "Your review has been successfully submitted.", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(dismissAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Submission Error", message: "Your review could not be submitted. Please try again later.", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(dismissAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
        else if let review = review {
            //let updatedReview = HopperReview(fsVenueId: review.fsVenueId, cafeName: review.cafeName, userId: NetworkSession.shared.user!.userId, reviewDate: datePicker.date.timeIntervalSince1970, rating: Int(ratingSlider.value), content: reviewTextView.text)
            var updatedReview = review
            updatedReview.reviewDate = datePicker.date.timeIntervalSince1970
            updatedReview.rating = Int(ratingSlider.value)
            updatedReview.content = reviewTextView.text
            
            NetworkController.shared.updateReview(review: updatedReview, with: NetworkSession.shared.token!) { (response) in
                if let response = response, response.success {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        let alertController = UIAlertController(title: "Thanks For Your Review", message: "Your review has been successfully submitted.", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(dismissAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Submission Error", message: "Your review could not be submitted. Please try again later.", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(dismissAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
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
