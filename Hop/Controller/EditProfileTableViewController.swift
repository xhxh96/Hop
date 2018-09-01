import UIKit

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var contactNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateTextField() {
        firstNameTextField.text = NetworkSession.shared.user?.firstName
        lastNameTextField.text = NetworkSession.shared.user?.lastName
        emailAddressTextField.text = NetworkSession.shared.user?.contact["email"]
        contactNumberTextField.text = NetworkSession.shared.user?.contact["phone"]
    }
    
    func checkPassword() {
        guard let password = passwordTextField.text else {
            return
        }
        
        if password.count < 6 {
            let alertController = UIAlertController(title: "Password Does Not Fulfill Requirement", message: "Password must be at least 6 characters long.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.passwordTextField.text = String.init()
            }
            alertController.addAction(dismissAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func checkRePassword() {
        if passwordTextField.text != rePasswordTextField.text {
            let alertController = UIAlertController(title: "Passwords Do Not Match", message: "Password does not match the confirm password. Please check and retype passwords.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.rePasswordTextField.text = String.init()
            }
            alertController.addAction(dismissAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case passwordTextField:
            rePasswordTextField.becomeFirstResponder()
        default:
            break
        }
        return true
    }

    @IBAction func passwordEditingDidEnd(_ sender: UITextField) {
        checkPassword()
    }
    
    @IBAction func rePasswordEditingEnd(_ sender: UITextField) {
        checkRePassword()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        var updatedData = [String: String].init()
        
        updatedData["userId"] = NetworkSession.shared.user?.userId
        
        if let firstName = firstNameTextField.text, !firstName.isEmpty {
            NetworkSession.shared.user?.firstName = firstName
            updatedData["firstName"] = firstName
        }
        
        if let lastName = lastNameTextField.text, !lastName.isEmpty {
            NetworkSession.shared.user?.lastName = lastName
            updatedData["lastName"] = lastName
        }
        
        if let emailAddress = emailAddressTextField.text, !emailAddress.isEmpty {
            NetworkSession.shared.user?.contact["email"] = emailAddress
            updatedData["contact.email"] = emailAddress
        }
        
        if let contact = contactNumberTextField.text, !contact.isEmpty {
            NetworkSession.shared.user?.contact["phone"] = contact
            updatedData["contact.phone"] = contact
        }
        
        if let password = rePasswordTextField.text, !password.isEmpty {
            updatedData["password"] = password
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.updateProfile(updated: updatedData) { (response) in
            if let response = response, let status = response.statusCode {
                switch status {
                case 400:
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        let alertController = UIAlertController(title: "Update Profile Error", message: "Your request could not be completed. Please try again later.", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(dismissAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                default:
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        let alertController = UIAlertController(title: "Profile Updated", message: "Your profile has been successfully updated", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(dismissAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    let alertController = UIAlertController(title: "Update Profile Error", message: "Your request could not be completed. Please try again later.", preferredStyle: .alert)
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
