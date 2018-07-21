//
//  HopperReviewTableViewCell.swift
//  Hop
//
//  Created by macOS on 1/7/18.
//  Copyright © 2018 NUS. All rights reserved.
//

import UIKit

class HopperReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hopperUserNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(reviews: HopperReview) {
        reviewContentLabel.text = reviews.content
        hopperUserNameLabel.text = reviews.userId
        
        let date = Date(timeIntervalSince1970: reviews.reviewDate)
        let dateFormatter = DateFormatter.init()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateStyle = .medium
        dateLabel.text = dateFormatter.string(from: date)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
