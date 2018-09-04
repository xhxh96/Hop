import UIKit

class AppInfoViewController: UIViewController {
    @IBOutlet weak var buildTextField: UILabel!
    @IBOutlet weak var versionTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLabel() {
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        buildTextField.text = build
        versionTextField.text = version
        
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
