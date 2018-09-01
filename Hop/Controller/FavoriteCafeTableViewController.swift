import UIKit

class FavoriteCafeTableViewController: UITableViewController {
    var favoriteCafe: [SavedCafe]!

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
        return favoriteCafe.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCafeCell", for: indexPath)
        
        cell.textLabel?.text = favoriteCafe[indexPath.row].name
        
        let imageURL = URL(string: favoriteCafe[indexPath.row].thumbnail ?? String.init())
        
        if let imageURL = imageURL, let imageData = try? Data(contentsOf: imageURL) {
            cell.imageView?.image = UIImage(data: imageData)
        }

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            NetworkController.shared.removeFromFavorite(venueId: favoriteCafe[indexPath.row].fsVenueId, userId: NetworkSession.shared.user!.userId, with: NetworkSession.shared.token!) { (response) in
                if let response = response, response.success {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        NetworkSession.shared.user?.savedCafes?.remove(at: indexPath.row)
                        self.favoriteCafe.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        let alertController = UIAlertController(title: "Deletion Error", message: "Your favorited cafe could not be deleted. Please try again later.", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(dismissAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
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
