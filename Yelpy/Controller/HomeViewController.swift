//
//  ViewController.swift
//  Yelpy
//
//  Created by Richard Basdeo on 2/17/21.
//

import UIKit
import CoreLocation

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
        let cell = UITableViewCell()
        cell.textLabel?.text = homeBrain.allBusiness[indexPath.row].businessName
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
