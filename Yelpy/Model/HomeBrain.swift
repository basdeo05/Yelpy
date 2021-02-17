//
//  HomeBrain.swift
//  Yelpy
//
//  Created by Richard Basdeo on 2/17/21.
//

import Foundation
class HomeBrain {
    
    //my api key
    let api_key = "CP9_jrQkdu75k7PrDjMeIdmxai0GAAI75xNNshYwCQelUs5eIoDu8qk9YzAcNBj7F_MlJVT1jK8C0fYgmqGDEahMkG3sbjs2GyQXStsgnmDqyGpSUE-WldpbwrIqYHYx"
    
    func perfromApiReqest (lattitude: String, longtitude: String){
        
        //create the url
        let theURL = "https://api.yelp.com/v3/businesses/search?latitude=\(lattitude)&longitude=\(longtitude)"
        
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
                    let returnedData = String(data: safeData, encoding: .utf8)
                    print(returnedData)
                }
            }
            //perform the request
            task.resume()
        }
    }
}
