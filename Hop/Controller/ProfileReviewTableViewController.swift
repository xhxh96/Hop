import UIKit

class ProfileReviewTableViewController: UITableViewController {
    var reviews: [HopperReview]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = true
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ProfileReviewTableViewCell
        
        cell.update(reviews: reviews[indexPath.row])
        
        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            NetworkController.shared.deleteReview(review: reviews[indexPath.row], with: NetworkSession.shared.token!) { (response) in
                if let response = response, response.success {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.reviews.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        let alertController = UIAlertController(title: "Deletion Error", message: "Your review could not be deleted. Please try again later.", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(dismissAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editReview" {
            let navigationController = segue.destination as? UINavigationController
            let submitReviewTableViewController = navigationController?.viewControllers.first as! SubmitReviewTableViewController
            let indexPath = tableView.indexPathForSelectedRow
            submitReviewTableViewController.review = reviews[(indexPath?.row)!]
            
        }
    }
    

}
