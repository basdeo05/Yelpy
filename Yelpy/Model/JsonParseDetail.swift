//
//  JsonParseDetail.swift
//  Yelpy
//
//  Created by Richard Basdeo on 3/3/21.
//

import Foundation
struct yelpReturnedBusinessDetail: Codable {
    
    let image_url: String
    let display_phone: String
    let location: location
    let photos: [String]
    let price: String
    let hours: [hours]
}

struct location: Codable {
    let display_address: [String]
}

struct hours: Codable {
    let open: [open]
}

struct open: Codable {
    let is_overnight: Bool
    let start: String
    let end: String
    let day: Int
}
