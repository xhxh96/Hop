import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSearchButton()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchButton() {
        let search = searchInput.text ?? ""
        searchButton.isEnabled = !search.isEmpty
    }
    
    @IBAction func searchValueChanged(_ sender: UITextField) {
        updateSearchButton()
    }
    
    @IBAction func unwindToInitialViewController(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beginSearch" {
            let navigationController = segue.destination as? UINavigationController
            let searchResultTableViewController = navigationController?.viewControllers.first as! SearchResultTableViewController
            let searchKeyword = searchInput.text!
            print(searchKeyword)
            searchResultTableViewController.searchKeyword = searchKeyword
        }
    }
}

