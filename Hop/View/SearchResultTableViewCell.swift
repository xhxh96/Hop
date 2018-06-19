import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var cafeThumbnail: UIImageView!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(thumbnail: Data?, name: String?, address: String?) {
        if let thumbnail = thumbnail {
            cafeThumbnail.image = UIImage(data: thumbnail)
        }
        cafeNameLabel.text = name
        cafeAddressLabel.text = address
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
