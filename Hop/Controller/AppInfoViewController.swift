import UIKit

class AppInfoViewController: UIViewController {
    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var buildTextField: UILabel!
    @IBOutlet weak var versionTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tap.numberOfTapsRequired = 4
        view.addGestureRecognizer(tap)
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
    
    @IBAction func tap(_ sender: UIGestureRecognizer) {
        UIView.animate(withDuration: 5, animations: {
            let scaleTransform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            let rotateTransform = CGAffineTransform(rotationAngle: .pi)
            
            let transform = scaleTransform.concatenating(rotateTransform)
            self.appIcon.transform = transform
            
        }) { (_) in
            UIView.animate(withDuration: 2, animations: {
                self.appIcon.transform = CGAffineTransform.identity
            })
        }
    }
}
