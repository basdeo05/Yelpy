//
//  HomeBrain.swift
//  Yelpy
//
//  Created by Richard Basdeo on 2/17/21.
//

import UIKit

protocol HomeBrainDelegate {
    func updateUI (_ homeBrain: HomeBrain)
    func didFailWithError (error: Error)
}


class HomeBrain {
    
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
        let theURL = "https://api.yelp.com/v3/businesses/search?latitude=\(lattitude)&longitude=\(longtitude)&categories=restaurants&limit=\(numberOfBusinessToDisplay)"
        
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
                    businessPhoneNumber: object.phone)
                
                allBusiness.append(newObject)
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
}
