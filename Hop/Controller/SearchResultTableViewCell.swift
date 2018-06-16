//
//  SearchResultTableViewCell.swift
//  Hop
//
//  Created by macOS on 16/6/18.
//  Copyright © 2018 NUS. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var cafeThumbnail: UIImageView!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var cafeDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with searchResult: SearchResult) {
        cafeNameLabel.text = searchResult.name
        cafeAddressLabel.text = searchResult.address
        cafeDescriptionLabel.text = searchResult.description
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
