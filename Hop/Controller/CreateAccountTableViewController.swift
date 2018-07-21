import UIKit

class CreateAccountTableViewController: UITableViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var contactNumberTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkPassword() {
        if passwordTextField.text != rePasswordTextField.text {
            let alertController = UIAlertController(title: "Passwords Do Not Match", message: "Password does not match the confirm password. Please check and retype passwords.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(dismissAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func checkFieldsFilled() {
        if firstNameTextField.text == nil || lastNameTextField.text == nil || emailAddressTextField.text == nil || contactNumberTextField.text == nil || userNameTextField.text == nil || passwordTextField.text == nil || rePasswordTextField.text == nil {
            let alertController = UIAlertController(title: "Missing Fields", message: "Please ensure that all fields are filled in before submitting.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(dismissAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func rePasswordEditingDidEnd(_ sender: UITextField) {
        checkPassword()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let contact = ["email": emailAddressTextField.text!, "phone": contactNumberTextField.text!]
        let account = User(userId: userNameTextField.text!, password: passwordTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, contact: contact, reviewCount: 0)
        
        NetworkController.shared.createAccount(account: account) { (response) in
            if let response = response, let status = response.statusCode {
                switch status {
                case 200:
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        let alertController = UIAlertController(title: "Account Created", message: "Please return to the main page to log in to your account.", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(dismissAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                case 401:
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        let alertController = UIAlertController(title: "Username Already Registered", message: "This username has already been registered. Please try a new username.", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(dismissAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                default: break
                }
            }
            else {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let alertController = UIAlertController(title: "Submission Error", message: "Your request could not be processed. Please try again later.", preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(dismissAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        firstNameTextField.text = String.init()
        lastNameTextField.text = String.init()
        emailAddressTextField.text = String.init()
        contactNumberTextField.text = String.init()
        passwordTextField.text = String.init()
        rePasswordTextField.text = String.init()
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
