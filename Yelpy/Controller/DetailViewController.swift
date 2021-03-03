//
//  DetailViewController.swift
//  Yelpy
//
//  Created by Richard Basdeo on 3/3/21.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    var businessChosen: BusinessObject?
    var userCoordinates: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let business = businessChosen, let coordinate = userCoordinates {
            print ("Business Chosen: \(business.businessName)")
            print ("User coordinates long: \(coordinate.longitude), lat: \(coordinate.latitude)")
        }
    }
}
