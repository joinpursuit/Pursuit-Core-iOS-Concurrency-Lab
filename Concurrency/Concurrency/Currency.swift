//
//  Currency.swift
//  Concurrency
//
//  Created by Cameron Rivera on 12/6/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import Foundation

struct Currency: Decodable{
    let rates: ExchangeRate
}

struct ExchangeRate: Decodable{
    let USD: Double
    let TZS: Double
    let AED: Double
    let GBP: Double
    let MXN: Double
}
