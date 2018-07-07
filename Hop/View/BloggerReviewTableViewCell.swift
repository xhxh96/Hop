//
//  BloggerReviewTableViewCell.swift
//  Hop
//
//  Created by XIANHAO on 7/7/18.
//  Copyright © 2018 NUS. All rights reserved.
//

import UIKit

class BloggerReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bloggerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(reviews: BloggerReview) {
        reviewContentLabel.text = reviews.extract
        bloggerNameLabel.text = reviews.reviewSite
        dateLabel.text = reviews.reviewDate
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
