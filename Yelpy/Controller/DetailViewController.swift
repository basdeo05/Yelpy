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
        tableView.backgroundColor = #colorLiteral(red: 1, green: 0.8323162198, blue: 0.6345977187, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        tableView.register(UINib(nibName: "name_Review_Title_Image_TableViewCell", bundle: nil), forCellReuseIdentifier: k.titleCell)
        tableView.register(UINib(nibName:"InformationTableViewCell", bundle: nil), forCellReuseIdentifier: k.informationCell)
        tableView.register(UINib(nibName:"openAndCloseTableViewCell", bundle: nil), forCellReuseIdentifier: k.dateCell)
        tableView.register(UINib(nibName: "MapTableViewCell", bundle: nil), forCellReuseIdentifier: k.mapCell)
        
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
        tableView.beginUpdates()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
}

    

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
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
            cell.backgroundColor = .white
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
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: k.informationCell) as! InformationTableViewCell
            cell.backgroundColor = .white
            
            if (dataReturned == true){
                cell.typeLabel.text = "\(detailBrain.businessDetailObject!.businessPrice) ** \(business!.businessTitle)"
                cell.phoneNumberLabel.text = "\(detailBrain.businessDetailObject!.businessPhone)"
                cell.addressLabel.text = ""
                for address in detailBrain.businessDetailObject!.businessLocation {
                    cell.addressLabel.text! += "\(address)\n"
                }
                
                returnCell = cell
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: k.dateCell) as! openAndCloseTableViewCell
            cell.backgroundColor = .white
            if (dataReturned == true){
                
                for hours in detailBrain.businessDetailObject!.businessHours {
                    for opens in hours.open {
                        switch opens.day {
                        case 0:
                            cell.mondayLabel.text = "\(cell.convertTimeString(time: opens.start)) - \(cell.convertTimeString(time: opens.end))"
                        case 1:
                            cell.tuesdayLabel.text = "\(cell.convertTimeString(time: opens.start)) - \(cell.convertTimeString(time: opens.end))"
                        case 2:
                            cell.wednesdayLabel.text = "\(cell.convertTimeString(time: opens.start)) - \(cell.convertTimeString(time: opens.end))"
                        case 3:
                            cell.thursdayLabel.text = "\(cell.convertTimeString(time: opens.start)) - \(cell.convertTimeString(time: opens.end))"
                        case 4:
                            cell.fridayLabel.text = "\(cell.convertTimeString(time: opens.start)) - \(cell.convertTimeString(time: opens.end))"
                        case 5:
                            cell.saturdayLabel.text = "\(cell.convertTimeString(time: opens.start)) - \(cell.convertTimeString(time: opens.end))"
                        case 6:
                            cell.sundayLabel.text = "\(cell.convertTimeString(time: opens.start)) - \(cell.convertTimeString(time: opens.end))"
                        default:
                            cell.mondayLabel.text = "Closed:"
                            cell.tuesdayLabel.text = "Closed:"
                            cell.wednesdayLabel.text = "Closed:"
                            cell.thursdayLabel.text = "Closed:"
                            cell.fridayLabel.text = "Closed:"
                            cell.saturdayLabel.text = "Closed:"
                            cell.sundayLabel.text = "Closed:"
                        }
                    }
                }
                returnCell = cell
            }
        case 3:
            print ("I see case 3")
            let cell = tableView.dequeueReusableCell(withIdentifier: k.mapCell) as! MapTableViewCell
            cell.centerMap(userLocation: userCoordinates!)
            
            
            if (dataReturned == true){
                
                let temp = CLLocationCoordinate2D(latitude: CLLocationDegrees(businessChosen!.businessLatitude)
                                                  , longitude: CLLocationDegrees(businessChosen!.businessLongitude))
                
                cell.getDirections(userLocation: userCoordinates!,
                                   restaurantLocation: temp)
            }
            
            
            returnCell = cell
            
            
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = .white
            cell.textLabel?.text = "Not completed yet"
            return cell
        }
        
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 10

        let maskLayer = CALayer()
        //maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
}

extension DetailViewController: HomeBrainDelegate{
    func updateUI(_ homeBrain: HomeBrain) {
        
        dataReturned = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateImage), userInfo: nil, repeats: true)
        }
    }
    
    func didFailWithError(error: Error) {
        print ("There was a error somewhere")
    }
}
