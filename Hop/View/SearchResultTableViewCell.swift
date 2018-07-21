import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var cafeThumbnail: UIImageView!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateLabel(thumbnail: UIImage?, name: String?, address: String?) {
        cafeNameLabel.text = name
        cafeAddressLabel.text = address
        
        if let thumbnail = thumbnail {
            cafeThumbnail.image = thumbnail
        }
        else {
            cafeThumbnail.image = UIImage(named: "thumbnail-placeholder")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
