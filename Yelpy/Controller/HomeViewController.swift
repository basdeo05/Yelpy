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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set location delegate to self
        locationManager.delegate = self
        
        //request permission from user to get thier location
        locationManager.requestWhenInUseAuthorization()
        
        //get users current location
        locationManager.requestLocation()
        
    }
}

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
            //weatherManger.fetchWeather(longitutde: lon, Latitude: lat)
            print ("Longitute: \(lon), latitutde: \(lat)")
            homeBrain.perfromApiReqest(lattitude: stringLat, longtitude: stringLon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}

