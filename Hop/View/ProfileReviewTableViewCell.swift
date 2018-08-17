import UIKit

class ProfileReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(reviews: HopperReview) {
        reviewTitleLabel.text = reviews.cafeName
        reviewContentLabel.text = reviews.content
        
        let date = Date(timeIntervalSince1970: reviews.reviewDate)
        let dateFormatter = DateFormatter.init()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateStyle = .medium
        reviewDateLabel.text = dateFormatter.string(from: date)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
