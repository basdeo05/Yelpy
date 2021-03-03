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

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let zoomInRegion:Double = 1000
    var restaurantsCoordinates = [CLLocationCoordinate2D]()
    let homeBrain = HomeBrain()
    let k = K()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeBrain.delegate = self

        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        homeBrain.numberOfBusinessToDisplay = UserDefaults.standard.integer(forKey: k.businessCount)
        print ("Business Count: \(homeBrain.numberOfBusinessToDisplay)")
        centerUserLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeBrain.numberOfBusinessToDisplay = UserDefaults.standard.integer(forKey: k.businessCount)
        print ("Business Count: \(homeBrain.numberOfBusinessToDisplay)")
        centerUserLocation()
    }
    
    func centerUserLocation() {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                                 latitudinalMeters: zoomInRegion,
                                                 longitudinalMeters: zoomInRegion)
            homeBrain.perfromApiReqest(lattitude: String(location.latitude), longtitude: String(location.longitude))
            mapView.setRegion(region, animated: true)
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
