//
//  CurrencyAPI.swift
//  Concurrency
//
//  Created by Cameron Rivera on 12/6/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import Foundation

struct CurrencyAPI{
    static func getCurrencies(completion: @escaping (Result<Currency,NetworkingError>) -> ()){
        let currencyURL = "http://data.fixer.io/api/latest?access_key=a17aef5ece92cf36d9c5963f7f4babf1&format=1"
        
        guard let fileURL = URL(string: currencyURL) else {
            completion(.failure(.badURL(currencyURL)))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: fileURL){ (data,response,error) in
            
            // Unwrapped Error
            if let error = error{
                completion(.failure(.networkClientError(error)))
                return
            }
            
            // Unwrapped Data
            guard let data = data else{
                completion(.failure(.invalidData))
                return
            }
            
            // Unwrapped Response
            guard let response = response as? HTTPURLResponse else{
                completion(.failure(.noResponse))
                return
            }
            
            // Get Status Code
            switch response.statusCode{
            case 200...299:
                break
            default:
                completion(.failure(.invalidStatusCode(response.statusCode)))
                return
            }
            
            //Decode
            do{
                    let monies = try JSONDecoder().decode(Currency.self,from: data)
                    completion(.success(monies))
            } catch{
                completion(.failure(.decodingError(error)))
                return
            }
            
        }
        dataTask.resume()
    }
    
    static func getAnExchangeRate(using theString: String, and rate: ExchangeRate) -> Double{
        switch theString{
        case "USD":
            return rate.USD
        case "MXN":
            return rate.MXN
        case "TZS":
            return rate.TZS
        case "AED":
            return rate.AED
        case "GBP":
            return rate.GBP
        default:
            return 0.0
        }
    }
}
