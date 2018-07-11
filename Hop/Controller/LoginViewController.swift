import UIKit

class LoginViewController: UIViewController {
    var token: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchNoLoginToken(completion: @escaping (String?) -> Void) {
        let url: String = "https://hopdbserver.herokuapp.com/nouserlogin"
        
        guard let requestURL = URL(string: url) else {
            print("FETCH LOGIN TOKEN ERROR: Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder.init()
            if let data = data{
                let jsonObject = try! jsonDecoder.decode([String: String].self, from: data)
                completion(jsonObject["token"])
            }
            else {
                print("FETCH LOGIN TOKEN WARNING: No JSON Object found")
                completion(nil)
            }
        }
        task.resume()
    }

    @IBAction func loginWithoutAccount(_ sender: UIButton) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        fetchNoLoginToken { (token) in
            self.token = token
            
            guard let _ = token else {
                return
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "LoginToInitialViewController", sender: nil)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToInitialViewController" {
            let initialViewController = segue.destination as! InitialViewController
            initialViewController.token = token
        }
    }
}
