import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet weak var welcomeTextLabel: UILabel!
    @IBOutlet weak var memberSinceTextLabel: UILabel!
    @IBOutlet weak var reviewsTextLabel: UILabel!
    
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
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
