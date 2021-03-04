//
//  MapTableViewCell.swift
//  Yelpy
//
//  Created by Richard Basdeo on 3/4/21.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    var zoomInLocation: Double = 10000
    var directionsArray: [MKDirections] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func centerMap (userLocation: CLLocationCoordinate2D){
        let region = MKCoordinateRegion(center: userLocation,
                                        latitudinalMeters: zoomInLocation,
                                        longitudinalMeters: zoomInLocation)
        mapView.setRegion(region, animated: true)
    }
}

extension MapTableViewCell: MKMapViewDelegate {
    
}

