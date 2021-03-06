//
//  MapViewController.swift
//  Yelpy
//
//  Created by Richard Basdeo on 3/2/21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    //outlet to mapView
    @IBOutlet weak var mapView: MKMapView!
    
    //create instance of locationManger
    let locationManager = CLLocationManager()
    
    //how much I want the map to zoom in
    let zoomInRegion:Double = 1000
    
    //holds all the coordinates of the restaurants that need to be displayed
    //Will be populate later
    var restaurantsCoordinates = [CLLocationCoordinate2D]()
    
    //homebrain object
    let homeBrain = HomeBrain()
    
    //access to my constants file
    let k = K()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeBrain.delegate = self

        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        
        //get all the restaurants in currently displayed on home page
        homeBrain.allBusiness = HomeBrain.sharedInstance.allBusiness
        
        //center map on user
        centerUserLocation()
        
        //show annotations of all the restaurants
        updateMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeBrain.allBusiness = HomeBrain.sharedInstance.allBusiness
        centerUserLocation()
        updateMap()
    }
    
    func centerUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                                 latitudinalMeters: zoomInRegion,
                                                 longitudinalMeters: zoomInRegion)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func updateMap() {
        restaurantsCoordinates = homeBrain.getMapLocations()
        var counter = 0
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        
        for restaurant in restaurantsCoordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude,
                                                           longitude: restaurant.longitude)
            annotation.title = homeBrain.allBusiness[counter].businessName
            counter += 1
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}


extension MapViewController: HomeBrainDelegate {
    func updateUI(_ homeBrain: HomeBrain) {
        restaurantsCoordinates = homeBrain.getMapLocations()
        var counter = 0
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        
        for restaurant in restaurantsCoordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude,
                                                           longitude: restaurant.longitude)
            annotation.title = homeBrain.allBusiness[counter].businessName
            counter += 1
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print ("Error in map")
    }
    
    
}

extension MapViewController: CLLocationManagerDelegate {
}

extension MapViewController: MKMapViewDelegate {
    
}
