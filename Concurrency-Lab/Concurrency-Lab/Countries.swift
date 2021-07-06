//
//  Countries.swift
//  Concurrency-Lab
//
//  Created by Yuliia Engman on 12/8/19.
//  Copyright © 2019 Yuliia Engman. All rights reserved.
//

import Foundation

struct Country: Decodable {
    let name: String
    let alpha2Code: String
    let capital: String
    let population: Int
    let currencies: [Money]
}

struct Money: Decodable {
    let code: String
    let name: String
    let symbol: String
}
