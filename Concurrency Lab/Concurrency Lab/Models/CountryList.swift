//
//  CountryList.swift
//  Concurrency Lab
//
//  Created by Bienbenido Angeles on 12/9/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import Foundation

struct CountryList: Decodable {
    var name: String
    var alpha2Code: String
    var capital: String
    var subregion: String
    var region: String
    var population: Int
    var currencies: [Currencies]
}

struct Currencies:Decodable {
    var code: String
    var name: String
    var symbol: String
}
