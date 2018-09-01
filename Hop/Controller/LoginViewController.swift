import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdTextField.layer.cornerRadius = 20.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userIdTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    

    @IBAction func loginWithoutAccount(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        guard !(userIdTextField.text?.isEmpty)! || !(passwordTextField.text?.isEmpty)! else {
            return
        }
        
        let account = UserLogin(userId: userIdTextField.text!, password: passwordTextField.text!)
        
        let activityViewController = ActivityViewController(message: "Loading...")
        present(activityViewController, animated: true, completion: nil)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.fetchLoginToken(account: account) { (tokenResponse) in
            if let tokenResponse = tokenResponse {
                switch tokenResponse.statusCode {
                case 402:
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        let alertController = UIAlertController(title: "User Not Found", message: "Please check your User ID and try again.", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                        alertController.addAction(dismissAction)
                        
                        activityViewController.dismiss(animated: true, completion: {
                            self.present(alertController, animated: true, completion: nil)
                        })
                    }
                case 403:
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        let alertController = UIAlertController(title: "Password Error", message: "Please check your password and try again.", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                        alertController.addAction(dismissAction)
                        
                        activityViewController.dismiss(animated: true, completion: {
                            self.present(alertController, animated: true, completion: nil)
                        })
                    }
                default:
                    NetworkSession.shared.initializeSession(user: tokenResponse.data, token: tokenResponse.token)
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        UserDefaults.standard.set(["userId": self.userIdTextField.text!, "userPassword": self.passwordTextField.text!], forKey: "UserSession")
                        activityViewController.dismiss(animated: true, completion: {
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
     */
}
