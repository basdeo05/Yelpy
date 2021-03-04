//
//  BusinessCell.swift
//  Yelpy
//
//  Created by Richard Basdeo on 2/17/21.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var starRatingImage: UIImageView!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var busninessPictureImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
