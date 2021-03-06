//
//  openAndCloseTableViewCell.swift
//  Yelpy
//
//  Created by Richard Basdeo on 3/3/21.
//

import UIKit

class openAndCloseTableViewCell: UITableViewCell {

    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = 22
    }
    
    func convertTimeString(time: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var stringTime = String(time)
        stringTime.insert(":", at: stringTime.index(stringTime.startIndex, offsetBy: 2))
        let date = dateFormatter.date(from: stringTime)
        
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date!)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
