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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.showsUserLocation = true
        centerUserLocation()
        
    }
    
    
    func centerUserLocation() {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                                 latitudinalMeters: zoomInRegion,
                                                 longitudinalMeters: zoomInRegion)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
}



extension MapViewController: CLLocationManagerDelegate {
    
}

extension MapViewController: MKMapViewDelegate {
    
}
