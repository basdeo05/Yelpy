//
//  JsonParse.swift
//  Yelpy
//
//  Created by Richard Basdeo on 2/17/21.
//

import Foundation
struct yelpReturnedBusinesses: Codable {
    
    let businesses: [businesses]
    
}

struct businesses: Codable {
    
    let rating: Float
    let review_count: Int
    let name: String
    let image_url: String
    let categories: [categories]
}

struct categories: Codable {
    let alias: String
    let title: String
}
