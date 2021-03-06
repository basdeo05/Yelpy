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
    
    func getDirections(userLocation: CLLocationCoordinate2D, restaurantLocation: CLLocationCoordinate2D){
        
        //create request using helper function
        let request = createRequest(user: userLocation, restaurant: restaurantLocation)
        
        //Give variable the request to make directions
        let directions = MKDirections(request: request)
        
        //Get the directions
        directions.calculate { (response, error) in
            
            if let e = error {
                print ("There was an error getting the directions from your request, \(e)")
                return
            }
            
            if let directionsReceived = response {
                
                for route in directionsReceived.routes {
                    
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    let anotation = MKPointAnnotation()
                    anotation.coordinate = restaurantLocation
                    self.mapView.addAnnotation(anotation)
                    
                }
            }
        }
        
    }
    
    func createRequest(user: CLLocationCoordinate2D, restaurant: CLLocationCoordinate2D ) -> MKDirections.Request {
        //create placemarkers for starting and ending location
        let startingPlacemark = MKPlacemark(coordinate: user)
        let endingPlacemark = MKPlacemark(coordinate: restaurant)
        
        //create the request
        let request = MKDirections.Request()
        
        //give request the starting and ending placemarkers
        request.source = MKMapItem(placemark: startingPlacemark)
        request.destination = MKMapItem(placemark: endingPlacemark)
        
        //tell request what type of directions I want
        request.transportType = .automobile
        
        //Tell request I want alternate routes
        request.requestsAlternateRoutes = false
        
        //return the request
        return request
    }
    
}


extension MapTableViewCell: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = #colorLiteral(red: 0.4874047041, green: 0.882589519, blue: 0.8476431966, alpha: 1)
        renderer.lineWidth = 6
        return renderer
    }
}

