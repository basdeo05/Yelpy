//
//  name_Review_Title_Image_TableViewCell.swift
//  Yelpy
//
//  Created by Richard Basdeo on 3/3/21.
//

import UIKit

class name_Review_Title_Image_TableViewCell: UITableViewCell {

    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var starRatingImageView: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        businessNameLabel.textColor = .white
        ratingCountLabel.textColor = .white
        backgroundImage.layer.cornerRadius = 22
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}