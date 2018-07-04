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
        reviewContentLabel.text = reviews.extract
        hopperUserNameLabel.text = reviews.userName
        dateLabel.text = reviews.reviewDate
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
