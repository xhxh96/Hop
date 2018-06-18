import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var cafeThumbnail: UIImageView!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(thumbnailData: Data?, name: String?, address: String?) {
        cafeThumbnail.image = UIImage(data: thumbnailData!)
        cafeNameLabel.text = name
        cafeAddressLabel.text = address
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
