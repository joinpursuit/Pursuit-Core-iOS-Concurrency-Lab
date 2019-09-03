//
//  CountryModel.swift
//  ConcurrencyLab
//
//  Created by Sam Roman on 9/3/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import Foundation
import UIKit



struct Countries: Codable {
    var name: String
    var flag: String
    var capital: String
    var population: Int
    var currencies: [Currency]
    
    static func getInfo(from data: Data) -> [Countries]? {
        do {
            let countries = try JSONDecoder().decode([Countries].self, from: data)
            return countries
        } catch let decodeError {
            fatalError("Could not decode \(decodeError)")
        }
        
}
    
    
}

struct Currency: Codable {
    var code: String
    var name: String
    var symbol: String
    
}



struct CountryAPIClient {
    static let shared = CountryAPIClient()
    
    enum FetchUserErrors: Error {
        case remoteResponseError
        case noDataError
        case badDecodeError
        case badURLError
        case badHttpResponseCode
    }
    
    func fetchData(completionHandler: @escaping (Result<[Countries], Error>) -> () ) {
        let urlString = "https://restcountries.eu/rest/v2/name/united"
        guard let url = URL(string: urlString) else {fatalError()}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {completionHandler(.failure(FetchUserErrors.remoteResponseError))
                return
            }
            
            guard let data = data else {completionHandler(.failure(FetchUserErrors.noDataError))
                return
            }
            
            guard let countries = Countries.getInfo(from: data) else {completionHandler(.failure(FetchUserErrors.badDecodeError))
                return
            }
            
            completionHandler(.success(countries))}.resume()
    }
    
    
    
}




//            guard let urlResponse = response as? HTTPURLResponse else {completionHandler(.failure(FetchUserErrors.badDecodeError))
//                return
//            }
//
//            switch urlResponse.statusCode {
//            case 200...299:
//            completionHandler(.success([Countries]))
//            default:
//                completionHandler(.failure(FetchUserErrors.badHttpResponseCode))

