import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeNetworkSession()
    }
    
    func initializeNetworkSession() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if let UserSession = UserDefaults.standard.value(forKey: "UserSession") as? [String: String] {
            let userId = UserSession["userId"]!
            let userPassword = UserSession["userPassword"]!
            
            NetworkController.shared.fetchLoginToken(account: UserLogin(userId: userId, password: userPassword)) { (tokenResponse) in
                if let tokenResponse = tokenResponse, tokenResponse.success {
                    NetworkSession.shared.initializeSession(user: tokenResponse.data, token: tokenResponse.token)
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.performSegue(withIdentifier: "mainPage", sender: nil)
                    }
                }
            }
        }
        else {
            NetworkController.shared.fetchNoLoginToken { (token) in
                NetworkSession.shared.token = token
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.performSegue(withIdentifier: "mainPage", sender: nil)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
