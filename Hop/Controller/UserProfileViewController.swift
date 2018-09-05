import UIKit
import ScalingCarousel

class favoriteCafeCell: ScalingCarouselCell {
    
}

class UserProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var welcomeTextLabel: UILabel!
    @IBOutlet weak var memberSinceTextLabel: UILabel!
    @IBOutlet weak var reviewsTextLabel: UILabel!
    @IBOutlet weak var viewAllReviewButton: UIButton!
    @IBOutlet weak var viewAllCafeButton: UIButton!
    @IBOutlet weak var carousel: ScalingCarouselView!
    
    var reviews: [HopperReview]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        updateImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        carousel.deviceRotated()
    }
    
    func updateLabel() {
        welcomeTextLabel.text = "Hello, \(NetworkSession.shared.user!.userId)"
        
        let date = Date(timeIntervalSince1970: NetworkSession.shared.user!.accountCreatedOn)
        let dateFormatter = DateFormatter.init()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateStyle = .medium
        memberSinceTextLabel.text = "Member since: \(dateFormatter.string(from: date))"
        reviewsTextLabel.text = "Reviews Submitted: \(NetworkSession.shared.user!.reviewCount)"
        
        if NetworkSession.shared.user!.reviewCount > 0 {
            viewAllReviewButton.isHidden = false
        }
        else {
            viewAllReviewButton.isHidden = true
        }
        
        if let favoriteCafeCount = NetworkSession.shared.user!.savedCafes?.count, favoriteCafeCount > 0 {
            viewAllCafeButton.isHidden = false
        }
        else {
            viewAllCafeButton.isHidden = true
        }
    }
    
    func updateImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(_:)))
        profileImage.addGestureRecognizer(tap)
        
        if let imageData = UserDefaults.standard.value(forKey: "ProfileImage") as? Data {
            profileImage.image = UIImage(data: imageData)
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewAllReviewsTapped(_ sender: UIButton) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.fetchHopperReviewForProfile(user: NetworkSession.shared.user!, with: NetworkSession.shared.token!) { (HopperReview) in
            if let hopperReview = HopperReview {
                self.reviews = hopperReview
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.performSegue(withIdentifier: "userReviews", sender: nil)
                }
            }
        }
    }
    
    @IBAction func profileImageTapped(_ gesture: UIGestureRecognizer) {
        let imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NetworkSession.shared.user?.savedCafes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCafeCell", for: indexPath)
        
        if let carouselCell = cell as? ScalingCarouselCell {
            let views = carouselCell.mainView.subviews
            
            for view in views {
                if let labelView = view as? UILabel {
                    labelView.text = NetworkSession.shared.user!.savedCafes![indexPath.row].name
                }
                
                if let imageView = view as? UIImageView {
                    let imageURL = URL(string: NetworkSession.shared.user?.savedCafes?[indexPath.row].thumbnail ?? "")
                    let imageData = try? Data(contentsOf: imageURL!)
                    
                    guard let data = imageData else {
                        continue
                    }
                    imageView.image = UIImage(data: data)
                }
            }
        }
        
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    
    // MARK: - Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carousel.didScroll()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = selectedImage
            let imageData = UIImagePNGRepresentation(selectedImage)
            UserDefaults.standard.set(imageData, forKey: "ProfileImage")
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "userReviews" {
            let profileReviewTableViewController = segue.destination as! ProfileReviewTableViewController
            profileReviewTableViewController.reviews = reviews
        }
        else if segue.identifier == "userFavorite" {
            let favoriteCafeTableViewController = segue.destination as! FavoriteCafeTableViewController
            favoriteCafeTableViewController.favoriteCafe = NetworkSession.shared.user!.savedCafes!
        }
        else if segue.identifier == "favoriteCafeDetails" {
            let navigationController = segue.destination as! UINavigationController
            let cafeTableViewController = navigationController.viewControllers.first as! CafeTableViewController
            let indexPath = (carousel.indexPathsForSelectedItems?.first)!
            let selectedCafe = NetworkSession.shared.user!.savedCafes![indexPath.row]
            cafeTableViewController.selectedCafeId = selectedCafe.fsVenueId
        }
    }

}
