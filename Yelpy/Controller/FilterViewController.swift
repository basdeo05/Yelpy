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
    let k = K()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (UserDefaults.standard.bool(forKey: k.oneMileFilter)){
            oneMileOutlet.isOn = true
        }
        if (UserDefaults.standard.bool(forKey: k.threeMileFilter)){
            threeMileOutlet.isOn = true
        }
        if (UserDefaults.standard.bool(forKey: k.fiveMileFilter)){
            fiveMileOutlet.isOn = true
        }
        if (UserDefaults.standard.bool(forKey: k.openNowFilter)){
            openNowOutlet.isOn = true
        }
        if (UserDefaults.standard.integer(forKey: k.priceFilter) > 0){
            priceOutlet.selectedSegmentIndex = UserDefaults.standard.integer(forKey: k.priceFilter)
        }

        
        
        
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        
        UserDefaults.standard.set(oneMileOutlet.isOn, forKey: k.oneMileFilter)
        UserDefaults.standard.set(threeMileOutlet.isOn, forKey: k.threeMileFilter)
        UserDefaults.standard.set(fiveMileOutlet.isOn, forKey: k.fiveMileFilter)
        UserDefaults.standard.set(openNowOutlet.isOn, forKey: k.openNowFilter)
        UserDefaults.standard.set(priceOutlet.selectedSegmentIndex, forKey: k.priceFilter)
        
        if (oneMileOutlet.isOn ||
                threeMileOutlet.isOn ||
                fiveMileOutlet.isOn ||
                openNowOutlet.isOn ||
                priceOutlet.selectedSegmentIndex != 0){
            
            UserDefaults.standard.set(true, forKey: k.hasFilterBeenApplied)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    //This is how to pass data between view controllers using delegation
//    override func viewWillDisappear(_ animated: Bool) {
//
//        if let filterChosen = filter {
//            delegate?.setData(filterRecieved: filterChosen)
//        }
//
//    }
//  var delegate: recieveFilterProtocol?
}
