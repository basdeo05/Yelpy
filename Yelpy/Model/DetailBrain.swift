//
//  DetailBrain.swift
//  Yelpy
//
//  Created by Richard Basdeo on 3/3/21.
//

import Foundation
class DetailBrain : HomeBrain {
    
    var url = "https://api.yelp.com/v3/businesses/"
    
    var businessDetailObject: BusinessDetailObject?
    
    func performDetailApiRequest () {
        
        //convert string url to actual url
        if let URL = URL(string: url){
            
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
                    self.parseDetailData(apiData: safeData)
                    self.delegate?.updateUI(self)
                }
            }
            //perform the request
            task.resume()
        }
    }
    
    func parseDetailData(apiData: Data) {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(yelpReturnedBusinessDetail.self, from: apiData)
            let newBusinessDetailObject = BusinessDetailObject(business_Image: decodedData.image_url,
                                                            businessPhone: decodedData.display_phone,
                                                            businessLocation: decodedData.location.display_address,
                                                            businessPhotos: decodedData.photos,
                                                            businessPrice: decodedData.price,
                                                            businessHours: decodedData.hours)
            
            businessDetailObject = newBusinessDetailObject
        }
        catch{
            print ("There was an error decoding businessDetail: \(error)")
        }
    }
}
