//
//  CountryInfo.swift
//  Concurrency
//
//  Created by Cameron Rivera on 12/5/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import Foundation

struct CountryInfo: Decodable {
    var name: String
    var capital: String
    var population: Int
    var topLevelDomain: [String]
    var currencies: [MoneyInfo]
}

struct MoneyInfo: Decodable{
    var code: String
    var name: String
    var symbol: String
}
