//
//  ViewController.swift
//  Yelpy
//
//  Created by Richard Basdeo on 2/17/21.
//

import UIKit
import CoreLocation
import AlamofireImage

class HomeViewController: UIViewController {

    //connect controller to model
    let homeBrain = HomeBrain()
    //Create location object
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var stringLon = ""
    var stringLat = ""
    var shouldContinousScroll = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set location delegate to self
        locationManager.delegate = self
        
        //request permission from user to get thier location
        locationManager.requestWhenInUseAuthorization()
        
        //get users current location
        locationManager.requestLocation()
        
        tableView.delegate = self
        tableView.dataSource = self
        homeBrain.delegate = self
        searchBar.delegate = self
        
        //register custom cell with tableView
        tableView.register(UINib(nibName: "BusinessCell", bundle: nil), forCellReuseIdentifier: "BusinessCell")
        
    }
}

//get current user location
extension HomeViewController: CLLocationManagerDelegate {
    
    //returns an array of locations
    //get the last location which is the most current location
    //provide my location to the api
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            stringLon = String(lon)
            stringLat = String(lat)
            homeBrain.perfromApiReqest(lattitude: stringLat, longtitude: stringLon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}

//customize the table view
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeBrain.allBusiness.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        cell.businessNameLabel.text = homeBrain.allBusiness[indexPath.row].businessName
        cell.categoryLabel.text = homeBrain.allBusiness[indexPath.row].businessAlias
        cell.numberOfReviewsLabel.text = String(homeBrain.allBusiness[indexPath.row].businessReview_count)
        cell.phoneNumberLabel.text = homeBrain.allBusiness[indexPath.row].businessPhoneNumber
        
        switch homeBrain.allBusiness[indexPath.row].businessRating {
        case 0.0:
            cell.starRatingImage.image = UIImage(named: "extra_large_0")
        case 1.0:
            cell.starRatingImage.image = UIImage(named: "extra_large_1")
        case 1.5:
            cell.starRatingImage.image = UIImage(named: "extra_large_1_half")
        case 2.0:
            cell.starRatingImage.image = UIImage(named: "extra_large_2")
        case 2.5:
            cell.starRatingImage.image = UIImage(named: "extra_large_2_half")
        case 3.0:
            cell.starRatingImage.image = UIImage(named: "extra_large_3")
        case 3.5:
            cell.starRatingImage.image = UIImage(named: "extra_large_3_half")
        case 4.0:
            cell.starRatingImage.image = UIImage(named: "extra_large_4")
        case 4.5:
            cell.starRatingImage.image = UIImage(named: "extra_large_4_half")
        case 5.0:
            cell.starRatingImage.image = UIImage(named: "extra_large_5")
        default:
            cell.starRatingImage.image = UIImage(named: "extra_large_0")
        }
        
        if let imageUrl = URL(string: homeBrain.allBusiness[indexPath.row].businessImage_url){
            cell.busninessPictureImageView.af.setImage(withURL: imageUrl)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        //print (indexPath.row)
        if (indexPath.row  == homeBrain.allBusiness.count - 1 && shouldContinousScroll == true) {
            homeBrain.numberOfBusinessToDisplay += 5
            homeBrain.perfromApiReqest(lattitude: stringLat, longtitude: stringLon)
            }

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
}

//delegates to pass data from home brain
extension HomeViewController: HomeBrainDelegate {
    func updateUI (_ homeBrain: HomeBrain) {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print ("There was an error !")
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    //Search button clicked function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //get rid of keyboard
        searchBar.endEditing(true)
        
        //if no text get rif of keyboard and hide cancel button
        if (searchBar.text == ""){
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
        }
        
        else {
            
            //get search bar text
            if let searchBatText = searchBar.text {
                
                //hold results
                var tempArray  = [BusinessObject]()
                
                //go through array and see if any matches
                for aBusiness in homeBrain.allBusiness {
                    
                    //if matches put the business in the temp array
                    if (aBusiness.businessName.contains(searchBatText) ||
                            aBusiness.businessAlias.contains(searchBatText)){
                        tempArray.append(aBusiness)
                    }
                }
                
                //get rid of keyboard
                searchBar.endEditing(true)
                
                //get rid of all business
                homeBrain.allBusiness.removeAll()
                
                //set all business to business that match the result
                homeBrain.allBusiness = tempArray
                
                //stop continous scrolling because will onnly have a set results
                shouldContinousScroll = false
                
                //reload tableview and go to starting cell
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    
                }
                
            }
        }
    }
    
    //update results per character
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        //if no text get rif of keyboard and hide cancel button
        if (searchBar.text == ""){
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
            homeBrain.perfromApiReqest(lattitude: stringLat, longtitude: stringLon)
        }
        
        else {
            
            //get search bar text
            if let searchBatText = searchBar.text {
                
                //hold results
                var tempArray = [BusinessObject]()
                
                //go through array and see if any matches
                for aBusiness in homeBrain.allBusiness {
                    
                    //if matches put the business in the temp array
                    if (aBusiness.businessName.contains(searchBatText) ||
                            aBusiness.businessAlias.contains(searchBatText)){
                        tempArray.append(aBusiness)
                    }
                }
                
                //get rid of all business
                homeBrain.allBusiness.removeAll()
                
                //set all business to business that match the result
                homeBrain.allBusiness = tempArray
                
                //stop continous scrolling because will onnly have a set results
                shouldContinousScroll = false
                
                //reload tableview and go to starting cell
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if (self.homeBrain.allBusiness.count > 0){
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                    
                }
                
            }
        }
    }
    
    
    
    //if user clicked cancel button clear textfield
    //get rid of keyboard
    //get original list of businesses
    //let user to continue endless scroll
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        homeBrain.perfromApiReqest(lattitude: stringLat, longtitude: stringLon)
        shouldContinousScroll = true
    }
    
    //once start editing show cancel button
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    //only begin searching when there are business in the array
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if (homeBrain.allBusiness.count == 0){
            return false
        }
        return true
    }
    
}
