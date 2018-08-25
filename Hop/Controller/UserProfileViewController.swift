import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet weak var welcomeTextLabel: UILabel!
    @IBOutlet weak var memberSinceTextLabel: UILabel!
    @IBOutlet weak var reviewsTextLabel: UILabel!
    @IBOutlet weak var viewAllReviewButton: UIButton!
    
    var reviews: [HopperReview]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabel() {
        welcomeTextLabel.text = "Hello, \(NetworkSession.shared.user!.userId)"
        
        let date = Date(timeIntervalSince1970: NetworkSession.shared.user!.accountCreatedOn)
        let dateFormatter = DateFormatter.init()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateStyle = .medium
        memberSinceTextLabel.text = "Member since: \(dateFormatter.string(from: date))"
        reviewsTextLabel.text = "Reviews Submitted: \(NetworkSession.shared.user!.reviewCount)"
        
        if NetworkSession.shared.user!.reviewCount > 0 {
            viewAllReviewButton.isHidden = false
        }
        else {
            viewAllReviewButton.isHidden = true
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewAllReviewsTapped(_ sender: UIButton) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.fetchHopperReviewForProfile(user: NetworkSession.shared.user!, with: NetworkSession.shared.token!) { (HopperReview) in
            if let hopperReview = HopperReview {
                self.reviews = hopperReview
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.performSegue(withIdentifier: "userReviews", sender: nil)
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "userReviews" {
            let profileReviewTableViewController = segue.destination as! ProfileReviewTableViewController
            profileReviewTableViewController.reviews = reviews
        }
    }
 

}
