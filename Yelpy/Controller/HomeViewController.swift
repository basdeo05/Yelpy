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
            let stringLon = String(lon)
            let stringLat = String(lat)
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
