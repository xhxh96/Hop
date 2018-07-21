import UIKit

class LoginViewController: UIViewController {
    var token: String?

    @IBOutlet weak var emailAddressTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginWithoutAccount(_ sender: UIButton) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.fetchNoLoginToken { (token) in
            self.token = token
            
            guard let _ = token else {
                return
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "searchView", sender: nil)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchView" {
            let searchViewController = segue.destination as! SearchViewController
            searchViewController.token = token
        }
    }
}
