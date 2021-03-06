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
    
    //Business tapped on by tableView
    var businessChosen: BusinessObject?
    
    //user coordinates from previous tableView
    var userCoordinates: CLLocationCoordinate2D?
    
    //outlet to tableView
    @IBOutlet weak var tableView: UITableView!
    
    //access to my constants firls
    let k = K()
    
    //instance of detail brain
    let detailBrain = DetailBrain()
    
    //instance of time to call update image function
    var timer = Timer()
    
    //counter to choose which image to displayer
    var counter = 0
    
    //Know when to update the tableView
    var dataReturned = false
    
    //String to determing which photo to use
    var photoString = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check to see if a business was segued correctly
        if let business = businessChosen {
            
            //get the original background image
            photoString = business.businessImage_url
            
            //update the detail brain the the restaurant ID i want to use for my api call
            detailBrain.url += business.businessID
            
            //perform api call
            detailBrain.performDetailApiRequest()
        }
        
        //some tableViewConfiguration
        tableView.backgroundColor = #colorLiteral(red: 1, green: 0.8323162198, blue: 0.6345977187, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        //registering custome cells
        tableView.register(UINib(nibName: "name_Review_Title_Image_TableViewCell", bundle: nil), forCellReuseIdentifier: k.titleCell)
        tableView.register(UINib(nibName:"InformationTableViewCell", bundle: nil), forCellReuseIdentifier: k.informationCell)
        tableView.register(UINib(nibName:"openAndCloseTableViewCell", bundle: nil), forCellReuseIdentifier: k.dateCell)
        tableView.register(UINib(nibName: "MapTableViewCell", bundle: nil), forCellReuseIdentifier: k.mapCell)
        
        
        //setting this controller as the delegate to use homeBrainProtocol
        detailBrain.delegate = self
    }
    
    
    //update image function
    @objc func updateImage(){

        //make sure phot url string array is not nil
        //if not update photo string with the new image
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
        
        //I only want to reload the first cell not the whole tableView
        tableView.beginUpdates()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
}

    

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    //I only have 4 custom cells I want to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //make sure I have a chosen business by unwrapping it
        //If I dont create a cell telling user something went wrong.
        var business: BusinessObject?
        if let aBusiness = businessChosen {
            business = aBusiness
        }
        else {
            let returnCell = UITableViewCell()
            returnCell.textLabel?.text = "Something went wrong"
            return returnCell
        }
        
        //If I do have a business  create a return cell that will be set based on which cell is being shown
        var returnCell = UITableViewCell()
        
        
        
        switch indexPath.row {
        
        /*
         First cell
         Set image, title, and ratings based on object passed through segue
         If data has been returned update image with new URL
         */
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: k.titleCell) as! name_Review_Title_Image_TableViewCell
            cell.businessNameLabel.text = business!.businessName
            cell.setStarRatingString(rating: business!.businessRating)
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
            
        /*
         Only if data has been returned update this cell
         Update cell's label with data gotten back from api
         */
            
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
            
            
        /*
         Only if data has been returned update this cell
         Update open and close times with data from the api
         */
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: k.dateCell) as! openAndCloseTableViewCell
            cell.backgroundColor = .white
            if (dataReturned == true){
                
                for hours in detailBrain.businessDetailObject!.businessHours {
                    for opens in hours.open {
                        switch opens.day {
                        case 0:
                            cell.mondayLabel.text = cell.labelText(start: opens.start,
                                                                   end: opens.end,
                                                                   day: opens.day)
                        case 1:
                            cell.tuesdayLabel.text = cell.labelText(start: opens.start,
                                                                    end: opens.end,
                                                                    day: opens.day)
                        case 2:
                            cell.wednesdayLabel.text = cell.labelText(start: opens.start,
                                                                      end: opens.end,
                                                                      day: opens.day)
                        case 3:
                            cell.thursdayLabel.text = cell.labelText(start: opens.start,
                                                                     end: opens.end,
                                                                     day: opens.day)
                        case 4:
                            cell.fridayLabel.text = cell.labelText(start: opens.start,
                                                                   end: opens.end,
                                                                   day: opens.day)
                        case 5:
                            cell.saturdayLabel.text = cell.labelText(start: opens.start,
                                                                     end: opens.end,
                                                                     day: opens.day)
                        case 6:
                            cell.sundayLabel.text = cell.labelText(start: opens.start,
                                                                   end: opens.end,
                                                                   day: opens.day)
                        default:
                            print("Error on certain day")
                        }
                    }
                }
                returnCell = cell
            }
            
            /*
            Map cell
         */
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: k.mapCell) as! MapTableViewCell
            cell.centerMap(userLocation: userCoordinates!)
            
            
            if (dataReturned == true){
                
                let temp = CLLocationCoordinate2D(latitude: CLLocationDegrees(businessChosen!.businessLatitude)
                                                  , longitude: CLLocationDegrees(businessChosen!.businessLongitude))
                
                cell.getDirections(userLocation: userCoordinates!,
                                   restaurantLocation: temp)
            }
            returnCell = cell
            
            
            /*
         Default cell
         */
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = .white
            cell.textLabel?.text = "Not completed yet"
            return cell
        }
        
        return returnCell
    }
    
    //some spacing for cells
    
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


//Data is returned from api request
extension DetailViewController: HomeBrainDelegate{
    func updateUI(_ homeBrain: HomeBrain) {
        
        //When reloading tableView let it know that now certain data is available
        dataReturned = true
        
        //update the tableView
        //start timer to start chaing the images
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateImage), userInfo: nil, repeats: true)
        }
    }
    
    //should create an alert here to tell user something went wrong
    func didFailWithError(error: Error) {
        print ("There was a error somewhere")
    }
}
