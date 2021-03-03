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
    let detailBrain = DetailBrain()
    var timer = Timer()
    var counter = 0
    var dataReturned = false
    var photoString = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let business = businessChosen {
            photoString = business.businessImage_url
            detailBrain.url += business.businessID
            detailBrain.performDetailApiRequest()
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "name_Review_Title_Image_TableViewCell", bundle: nil), forCellReuseIdentifier: k.titleCell)
        detailBrain.delegate = self
        
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
    
    @objc func updateImage(){

        if let photos = detailBrain.businessDetailObject?.businessPhotos {
            if (counter == photos.count - 1) {
                counter = 0
                photoString = photos[counter]
            }
            else {
                counter += 1
                photoString = photos[counter]
            }
        }
        tableView.reloadData()
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
            
            if dataReturned == true{
                if let URL = URL(string: photoString){
                    cell.backgroundImage.af.setImage(withURL: URL)
                }
            }
            else {
                if let URL = URL(string: photoString){
                    cell.backgroundImage.af.setImage(withURL: URL)
                }
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

extension DetailViewController: HomeBrainDelegate{
    func updateUI(_ homeBrain: HomeBrain) {
        
        dataReturned = true
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateImage), userInfo: nil, repeats: true)
        }
    }
    
    func didFailWithError(error: Error) {
        print ("There was a error somewhere")
    }
}
