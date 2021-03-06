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
        businessNameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ratingCountLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        backgroundImage.layer.cornerRadius = 22
    }
    
    func setStarRatingString (rating: Float){
        
        switch rating {
        case 0.0:
            starRatingImageView.image = UIImage(named: "extra_large_0")!
        case 1.0:
            starRatingImageView.image = UIImage(named: "extra_large_1")!
        case 1.5:
            starRatingImageView.image = UIImage(named: "extra_large_1_half")!
        case 2.0:
            starRatingImageView.image = UIImage(named: "extra_large_2")!
        case 2.5:
            starRatingImageView.image = UIImage(named: "extra_large_2_half")!
        case 3.0:
            starRatingImageView.image = UIImage(named: "extra_large_3")!
        case 3.5:
            starRatingImageView.image = UIImage(named: "extra_large_3_half")!
        case 4.0:
            starRatingImageView.image = UIImage(named: "extra_large_4")!
        case 4.5:
            starRatingImageView.image = UIImage(named: "extra_large_4_half")!
        case 5.0:
            starRatingImageView.image = UIImage(named: "extra_large_5")!
        default:
            starRatingImageView.image = UIImage(named: "extra_large_0")!
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
