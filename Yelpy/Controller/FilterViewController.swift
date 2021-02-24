//
//  FilterViewController.swift
//  Yelpy
//
//  Created by Richard Basdeo on 2/24/21.
//

import UIKit

class FilterViewController: UIViewController {

    /*
    distance: 1 mile, 3 miles, 5 miles
     -have to convert meters to miles
     
    price:
     -1, 2, 3, 4 = $, $$, $$$, $$$$
     
    open_now:
    boolean
    */
    
    @IBOutlet weak var oneMileOutlet: UISwitch!
    @IBOutlet weak var threeMileOutlet: UISwitch!
    @IBOutlet weak var fiveMileOutlet: UISwitch!
    @IBOutlet weak var openNowOutlet: UISwitch!
    @IBOutlet weak var priceOutlet: UISegmentedControl!
    var filter: FilterObject?
    var delegate: recieveFilterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let filterChosen = filter {
            delegate?.setData(filterRecieved: filterChosen)
        }
        
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        
        filter = FilterObject(oneMile: oneMileOutlet.isOn,
                                  threeMile: threeMileOutlet.isOn,
                                  fiveMile: fiveMileOutlet.isOn,
                                  openNow: openNowOutlet.isOn,
                                  price: priceOutlet.selectedSegmentIndex)

        dismiss(animated: true, completion: nil)
    }
}
