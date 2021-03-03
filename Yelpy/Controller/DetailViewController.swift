//
//  DetailViewController.swift
//  Yelpy
//
//  Created by Richard Basdeo on 3/3/21.
//

import UIKit
import MapKit
import AlamofireImage

class DetailViewController: UIViewController {
    
    var businessChosen: BusinessObject?
    var userCoordinates: CLLocationCoordinate2D?
    @IBOutlet weak var tableView: UITableView!
    let k = K()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "name_Review_Title_Image_TableViewCell", bundle: nil), forCellReuseIdentifier: k.titleCell)
    }
    
    
    
    func returnStarRatingString (rating: Float) -> UIImage {
        
        switch rating {
        case 0.0:
            return UIImage(named: "extra_large_0")!
        case 1.0:
            return UIImage(named: "extra_large_1")!
        case 1.5:
            return UIImage(named: "extra_large_1_half")!
        case 2.0:
            return UIImage(named: "extra_large_2")!
        case 2.5:
            return UIImage(named: "extra_large_2_half")!
        case 3.0:
            return UIImage(named: "extra_large_3")!
        case 3.5:
            return UIImage(named: "extra_large_3_half")!
        case 4.0:
            return UIImage(named: "extra_large_4")!
        case 4.5:
            return UIImage(named: "extra_large_4_half")!
        case 5.0:
            return UIImage(named: "extra_large_5")!
        default:
            return UIImage(named: "extra_large_0")!
        }
    }
    
    
    
    
}

    

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var business: BusinessObject?
       
        if let aBusiness = businessChosen {
            business = aBusiness
        }
        else {
            let returnCell = UITableViewCell()
            returnCell.textLabel?.text = "No business object passed"
            return returnCell
        }
        
        var returnCell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: k.titleCell) as! name_Review_Title_Image_TableViewCell
            cell.businessNameLabel.text = business!.businessName
            cell.starRatingImageView.image = returnStarRatingString(rating: business!.businessRating)
            cell.ratingCountLabel.text = String(business!.businessRating)
            if let URL = URL(string: business!.businessImage_url){
                cell.backgroundImage.af.setImage(withURL: URL)
            }
            
            returnCell = cell
        default:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Not completed yet"
            return cell
        }
        
        return returnCell
    }
}
