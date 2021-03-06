//
//  ViewController.swift
//  Yelpy
//
//  Created by Richard Basdeo on 2/17/21.
//

import UIKit
import CoreLocation
import AlamofireImage

//Creating protocol to pass data between viewControllers using delegation
protocol recieveFilterProtocol {
    func UpdateUI()
}

class HomeViewController: UIViewController {

    //connect controller to model
    let homeBrain = HomeBrain()
    //Create location object
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButtonOutlet: UIButton!
    var filterButtonOriginalHeight: CGFloat!
    var filterButtonOriginalWidth: CGFloat!
    var shouldBounce = true
    
    
    var stringLon = ""
    var stringLat = ""
    var shouldContinousScroll = true
    
    let k = K()
    
    var shouldAnimate = true
    
    var tappedBusiness: BusinessObject?


    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchBar.searchTextField.textColor = .black
        
        //Set location delegate to self
        locationManager.delegate = self
        
        //request permission from user to get thier location
        locationManager.requestWhenInUseAuthorization()
        
        if let location = locationManager.location?.coordinate {
            let lon = location.longitude
            let lat = location.latitude
            stringLon = String(lon)
            stringLat = String(lat)
            homeBrain.perfromApiReqest(lattitude: stringLat, longtitude: stringLon)
        }
        else {
        //get users current location
        locationManager.requestLocation()
        }
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        homeBrain.delegate = self
        searchBar.delegate = self
        
        //register custom cell with tableView
        tableView.register(UINib(nibName: "BusinessCell", bundle: nil), forCellReuseIdentifier: "BusinessCell")
        
        //Get the original height and width of my button
        filterButtonOriginalWidth = filterButtonOutlet.frame.width
        filterButtonOriginalHeight = filterButtonOutlet.frame.height
        
        //make sure button is off screen so user dont see it
        filterButtonOutlet.frame = CGRect(x: filterButtonOutlet.frame.origin.x + view.bounds.width,
                                          y: filterButtonOutlet.frame.origin.y,
                                          width: filterButtonOutlet.frame.width,
                                          height: filterButtonOutlet.frame.height)
        
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (shouldAnimate){
            //when the view appers start showing the button
            UIView.animate(withDuration: 1,
                           delay: 0,
                           options: .curveEaseIn) {
                
                self.filterButtonOutlet.setTitle("Loading Data....", for: .normal)
                self.filterButtonOutlet.frame = CGRect(x: (self.filterButtonOutlet.frame.origin.x - self.view.bounds.width),
                                                       y: self.filterButtonOutlet.frame.origin.y,
                                                       width: self.filterButtonOutlet.frame.width,
                                                       height: self.filterButtonOutlet.frame.height)
                
                //Once the button is shown start making it bounce
            } completion: { (_) in
                self.shouldAnimate = false
                self.bouncingButton()
            }
        }
    }
    
    
    
    
    
    

    
    
    
    
    
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: k.homeToFilter, sender: self)
    }
    
    
    
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == k.homeToFilter){
        let destinationVC = segue.destination as! FilterViewController
        destinationVC.delegate = self
        }
       
        
        else if (segue.identifier == k.homeToDetail){
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.businessChosen = tappedBusiness
            
            let userLong = Float(stringLon)
            let userLat = Float(stringLat)
            
            if let long = userLong, let lat = userLat {
                
                destinationVC.userCoordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
            }
        }
    }
    
    
    
    
    
  
    
    
    //give animation to tableView
    func animateTable (){
        //reload table
        tableView.reloadData()
        
        //get all visible cells
        let visibleCells = tableView.visibleCells
        
        
        //get tableViewHeight
        let tableViewheight = tableView.bounds.size.height
        
        
        //go through each cell and move it down to tableviewHeight
        for cell in visibleCells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewheight)
        }
        
        
        //need to animate back to position
        //need counter so to happens after one anther
        var delayCounter = 0
        for cell in visibleCells {
            
            
            UIView.animate(withDuration: 4.0,
                           delay: Double(delayCounter) * 0.05,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                
                
                cell.transform = CGAffineTransform.identity
                
            }
            delayCounter += 1
        }
    }
    
    
    
    
    //bounce the button
    func bouncingButton () {
        
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 2,
                       options: .curveEaseOut) {
            
            self.filterButtonOutlet.bounds = CGRect(x: self.filterButtonOutlet.bounds.origin.x - 50,
                                               y: self.filterButtonOutlet.bounds.origin.y,
                                               width: self.filterButtonOriginalWidth + 80,
                                               height: self.filterButtonOriginalHeight)
            
        } completion: { (_) in
            
            
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 2,
                           options: .curveEaseOut) {
                
                self.filterButtonOutlet.bounds = CGRect(x: self.filterButtonOutlet.bounds.origin.x + 50,
                                                   y: self.filterButtonOutlet.bounds.origin.y,
                                                   width: self.filterButtonOriginalWidth,
                                                   height: self.filterButtonOriginalHeight)
                
            } completion: { (_) in
                
                if (self.shouldBounce){
                    self.bouncingButton()
                }
            }
        }
    }
}












//MARK:: Location Manager
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
            stringLon = String(lon)
            stringLat = String(lat)
            homeBrain.perfromApiReqest(lattitude: stringLat, longtitude: stringLon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}

















//MARK:: TableView
//customize the table view
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeBrain.allBusiness.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        cell.businessNameLabel.text = homeBrain.allBusiness[indexPath.row].businessName
        cell.categoryLabel.text = homeBrain.allBusiness[indexPath.row].businessAlias
        cell.numberOfReviewsLabel.text = String(homeBrain.allBusiness[indexPath.row].businessReview_count)
        cell.phoneNumberLabel.text = homeBrain.allBusiness[indexPath.row].businessPhoneNumber
        
        switch homeBrain.allBusiness[indexPath.row].businessRating {
        case 0.0:
            cell.starRatingImage.image = UIImage(named: "extra_large_0")
        case 1.0:
            cell.starRatingImage.image = UIImage(named: "extra_large_1")
        case 1.5:
            cell.starRatingImage.image = UIImage(named: "extra_large_1_half")
        case 2.0:
            cell.starRatingImage.image = UIImage(named: "extra_large_2")
        case 2.5:
            cell.starRatingImage.image = UIImage(named: "extra_large_2_half")
        case 3.0:
            cell.starRatingImage.image = UIImage(named: "extra_large_3")
        case 3.5:
            cell.starRatingImage.image = UIImage(named: "extra_large_3_half")
        case 4.0:
            cell.starRatingImage.image = UIImage(named: "extra_large_4")
        case 4.5:
            cell.starRatingImage.image = UIImage(named: "extra_large_4_half")
        case 5.0:
            cell.starRatingImage.image = UIImage(named: "extra_large_5")
        default:
            cell.starRatingImage.image = UIImage(named: "extra_large_0")
        }
        
        if let imageUrl = URL(string: homeBrain.allBusiness[indexPath.row].businessImage_url){
            cell.busninessPictureImageView.af.setImage(withURL: imageUrl)
        }
        
        cell.distanceLabel.text = ("\(String(format: "%.2f", homeBrain.allBusiness[indexPath.row].businessDistance / 1610)) Miles")
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor.darkGray
        spinner.hidesWhenStopped = true
        tableView.tableFooterView = spinner

        //print (indexPath.row)
        if (indexPath.row  == homeBrain.allBusiness.count - 1 && shouldContinousScroll == true) {
            
            spinner.startAnimating()
            homeBrain.loadMoreBusiness(Long: stringLon, Latt: stringLat){
                spinner.stopAnimating()
                }
            }

    }
    
    
    
    
    
    
    
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tappedBusiness = homeBrain.allBusiness[indexPath.row]
        performSegue(withIdentifier: k.homeToDetail, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}















//MARK: HOMEBRAIN Protocol
//delegates to pass data from home brain
extension HomeViewController: HomeBrainDelegate {
    func updateUI (_ homeBrain: HomeBrain) {
        
        HomeBrain.sharedInstance.allBusiness = homeBrain.allBusiness
        DispatchQueue.main.async {
            if (self.shouldBounce){
                self.animateTable()
                self.filterButtonOutlet.setTitle("Filter Results", for: .normal)
                self.shouldBounce = false
            }
            else {
                self.tableView.reloadData()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.shouldContinousScroll = false
            self.homeBrain.numberOfBusinessToDisplay = self.homeBrain.allBusiness.count
            print (self.homeBrain.numberOfBusinessToDisplay)
        }
    }
}


















//MARK:: Search Bar
extension HomeViewController: UISearchBarDelegate {
    
    //Search button clicked function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //get rid of keyboard
        searchBar.endEditing(true)
        
        //if no text get rif of keyboard and hide cancel button
        if (searchBar.text == ""){
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
        }
        
        else {
            
            //get search bar text
            if let searchBatText = searchBar.text {
                
                //hold results
                var tempArray  = [BusinessObject]()
                
                //go through array and see if any matches
                for aBusiness in homeBrain.allBusiness {
                    
                    //if matches put the business in the temp array
                    if (aBusiness.businessName.contains(searchBatText) ||
                            aBusiness.businessAlias.contains(searchBatText)){
                        tempArray.append(aBusiness)
                    }
                }
                
                //get rid of keyboard
                searchBar.endEditing(true)
                
                //get rid of all business
                homeBrain.allBusiness.removeAll()
                
                //set all business to business that match the result
                homeBrain.allBusiness = tempArray
                
                HomeBrain.sharedInstance.allBusiness = homeBrain.allBusiness
                
                //stop continous scrolling because will onnly have a set results
                shouldContinousScroll = false
                
                //reload tableview and go to starting cell
                if (homeBrain.allBusiness.count > 0){
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        
                    }
                }
                else {
                    DispatchQueue.main.async {
                        
                        let alert = UIAlertController(title: "No Results found", message: "", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "Start New Search", style: .default) { (action) in
                            
                            self.homeBrain.perfromApiReqest(lattitude: self.stringLat, longtitude: self.stringLon)
                            searchBar.showsCancelButton = false
                            searchBar.text = ""
                            self.shouldContinousScroll = true
                        }
                        
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)

                    }
                }
            }
        }
    }
    
    //update results per character
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        //if no text get rif of keyboard and hide cancel button
        if (searchBar.text == ""){
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
            homeBrain.perfromApiReqest(lattitude: stringLat, longtitude: stringLon)
        }
        
        else {
            
            //get search bar text
            if let searchBatText = searchBar.text {
                
                //hold results
                var tempArray = [BusinessObject]()
                
                //go through array and see if any matches
                for aBusiness in homeBrain.allBusiness {
                    
                    //if matches put the business in the temp array
                    if (aBusiness.businessName.contains(searchBatText) ||
                            aBusiness.businessAlias.contains(searchBatText)){
                        tempArray.append(aBusiness)
                    }
                }
                
                //get rid of all business
                homeBrain.allBusiness.removeAll()
                
                //set all business to business that match the result
                homeBrain.allBusiness = tempArray
                
                HomeBrain.sharedInstance.allBusiness = homeBrain.allBusiness
                
                //stop continous scrolling because will onnly have a set results
                shouldContinousScroll = false
                
                //reload tableview and go to starting cell
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if (self.homeBrain.allBusiness.count > 0){
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                    
                }
                
            }
        }
    }
    
    
    
    //if user clicked cancel button clear textfield
    //get rid of keyboard
    //get original list of businesses
    //let user to continue endless scroll
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        homeBrain.perfromApiReqest(lattitude: stringLat, longtitude: stringLon)
        shouldContinousScroll = true
    }
    
    //once start editing show cancel button
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    //only begin searching when there are business in the array
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if (homeBrain.allBusiness.count == 0){
            return false
        }
        return true
    }
    
}























////MARK:: Recieve Filter
extension HomeViewController: recieveFilterProtocol{
    func UpdateUI() {
        homeBrain.perfromApiReqest(lattitude: stringLat, longtitude: stringLon)
    }
}
