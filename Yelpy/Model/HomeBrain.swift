//
//  HomeBrain.swift
//  Yelpy
//
//  Created by Richard Basdeo on 2/17/21.
//

import UIKit
import MapKit

protocol HomeBrainDelegate {
    func updateUI (_ homeBrain: HomeBrain)
    func didFailWithError (error: Error)
}

class HomeBrain {
    
    static let sharedInstance = HomeBrain()
    let k = K()
    
    //my api key
    let api_key = "CP9_jrQkdu75k7PrDjMeIdmxai0GAAI75xNNshYwCQelUs5eIoDu8qk9YzAcNBj7F_MlJVT1jK8C0fYgmqGDEahMkG3sbjs2GyQXStsgnmDqyGpSUE-WldpbwrIqYHYx"
    
    //hold all the business after the api call
    var allBusiness = [BusinessObject]()
    
    //delegate
    var delegate: HomeBrainDelegate?
    
    
    var numberOfBusinessToDisplay = 20
    
    //perform api request to get business near my current location
    func perfromApiReqest (lattitude: String, longtitude: String){
        
        //create the url
        var theURL = "https://api.yelp.com/v3/businesses/search?latitude=\(lattitude)&longitude=\(longtitude)&categories=restaurants&limit=\(numberOfBusinessToDisplay)"
        
        
        //check to see if filters are applied
        if (UserDefaults.standard.bool(forKey: k.hasFilterBeenApplied)){

            //check to see if price filter
            if (UserDefaults.standard.integer(forKey: k.priceFilter) > 0){
                theURL += "&price=\(String(UserDefaults.standard.integer(forKey: k.priceFilter)))"
                print(String(UserDefaults.standard.integer(forKey: k.priceFilter)))
            }
            
            if (UserDefaults.standard.bool(forKey: k.fiveMileFilter)){
                theURL += "&radius=8046"
                print(5)
            }
            if (UserDefaults.standard.bool(forKey: k.fiveMileFilter) == false &&
                    UserDefaults.standard.bool(forKey: k.threeMileFilter)){
                theURL += "&radius=4828"
                print(3)
            }
            if (UserDefaults.standard.bool(forKey: k.fiveMileFilter) == false &&
                    UserDefaults.standard.bool(forKey: k.threeMileFilter) == false &&
                    UserDefaults.standard.bool(forKey: k.fiveMileFilter)
            ){
                theURL += "&radius=1610"
                print(1)
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //convert string url to actual url
        if let URL = URL(string: theURL){
            
            //create a request
            var request = URLRequest(url: URL)
            request.setValue("Bearer \(api_key)", forHTTPHeaderField: "Authorization")
            
            //create the "browser"
            let sesseion = URLSession(configuration: .default)
            
            //give the browser a task
            let task = sesseion.dataTask(with: request) { (data, response, error) in
                
                //check to see if there was a error
                if let e = error {
                    print ("There was an error with the api call. \(e)")
                    return
                }
                // if no error parse json
                if let safeData = data {
                    //let returnedData = String(data: safeData, encoding: .utf8)
                    self.parseJson(apiData: safeData)
                    self.delegate?.updateUI(self)
                }
            }
            //perform the request
            task.resume()
        }
    }
    
    func parseJson (apiData: Data) {
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(yelpReturnedBusinesses.self, from: apiData)
            allBusiness.removeAll()
            for object in decodedData.businesses {
                let newObject = BusinessObject(
                    businessName: object.name,
                    businessRating: object.rating,
                    businessReview_count: object.review_count,
                    businessImage_url: object.image_url,
                    businessAlias: object.categories[0].alias.capitalized,
                    businessTitle: object.categories[0].title,
                    businessPhoneNumber: object.phone,
                    businessDistance: object.distance,
                    businessLatitude: object.coordinates.latitude,
                    businessLongitude: object.coordinates.longitude)
                
                allBusiness.append(newObject)
//                print ("\(object.name) : \(object.distance)")
            }
        }
        catch {
            print ("There was an error decoding the data: \(error)")
            delegate?.didFailWithError(error: error)
            return
        }
    }
    
    
    /*
     Completion Handler:
     The result will return an array of business Objects otherwise will return an error
     */
    func loadMoreBusiness(Long: String, Latt: String, completion: () -> ()) {
        numberOfBusinessToDisplay += 10
        perfromApiReqest(lattitude: Latt, longtitude: Long)

    }
    
    func getMapLocations() -> [CLLocationCoordinate2D]{
        
        var temp = [CLLocationCoordinate2D]()
        for business in allBusiness {
            let newCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(business.businessLatitude), longitude: CLLocationDegrees(business.businessLongitude))
            
            temp.append(newCoordinate)
        }
        
        return temp
    }
}
