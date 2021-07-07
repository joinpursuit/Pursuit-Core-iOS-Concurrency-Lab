//
//  CurrencyModel.swift
//  ConcurrencyLab
//
//  Created by Sam Roman on 9/3/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import Foundation
import UIKit

struct ConversionRates: Codable {
    var rates: Rates
    
    static func getRates(from data: Data) -> Rates? {
        do {
            let rates = try JSONDecoder().decode(Rates.self, from: data)
            return rates
        } catch let decodeError {
            fatalError("Could not decode \(decodeError)")
        }
}
}

struct Rates: Codable {
    let USD:Double
    let TZS:Double
    let AED:Double
    let GBP:Double
    let MXN:Double
}




struct CurrencyAPIClient {
    static let shared = CurrencyAPIClient()
    
    enum FetchUserErrors: Error {
        case remoteResponseError
        case noDataError
        case badDecodeError
        case badURLError
        case badHttpResponseCode
    }
    
    func fetchData(completionHandler: @escaping (Result<Rates, Error>) -> () ) {
        let urlString = "http://data.fixer.io/api/latest?access_key=a17aef5ece92cf36d9c5963f7f4babf1&format=1"
        guard let url = URL(string: urlString) else {fatalError()}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {completionHandler(.failure(FetchUserErrors.remoteResponseError))
                return
            }
            
            guard let data = data else {completionHandler(.failure(FetchUserErrors.noDataError))
                return
            }
            
            guard let rates = ConversionRates.getRates(from: data) else {completionHandler(.failure(FetchUserErrors.badDecodeError))
                return
            }
            
            completionHandler(.success(rates))}.resume()
}

}

