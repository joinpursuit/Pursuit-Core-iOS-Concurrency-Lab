//
//  CountryAPI.swift
//  Concurrency
//
//  Created by Cameron Rivera on 12/5/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import Foundation
import UIKit

enum NetworkingError: Error{
    case badURL(String)
    case invalidData
    case networkClientError(Error)
    case invalidStatusCode(Int)
    case decodingError(Error)
    case noResponse
    case noImageFound
}

struct CountryAPI {
    
    static func obtainCountries(completion: @escaping (Result<[CountryInfo], NetworkingError>) -> ()) {
        let countryAPIURL = "https://restcountries.eu/rest/v2/name/united"
        // Start by creating URL
        guard let fileURL = URL(string: countryAPIURL) else {
            completion(.failure(.badURL(countryAPIURL)))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: fileURL) { (data,response,error) in
            
            // Unwrap your data.
            guard let unwrappedData = data else {
                completion(.failure(.invalidData))
                return
            }
            // Unwrap you error.
            if let unwrappedError = error{
                completion(.failure(.networkClientError(unwrappedError)))
                return
            }
            
            // unwrap your response as a HTTPURLResponse
            guard let unwrappedResponse = response as? HTTPURLResponse else{
                completion(.failure(.noResponse))
                return
            }
            
            switch unwrappedResponse.statusCode{
            case 200...299:
                break
            default:
                completion(.failure(.invalidStatusCode(unwrappedResponse.statusCode)))
            }
            
            // Decode
            do{
                let countries = try JSONDecoder().decode([CountryInfo].self, from: unwrappedData)
                completion(.success(countries))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        dataTask.resume()
    }
    
    static func obtainCountryFlag(_ countryCode: String, completion: @escaping (Result<UIImage?,NetworkingError>) -> ()){
        DispatchQueue.global(qos: .userInitiated).async {
            var code: String = ""
            if countryCode == "uk"{
                code = "vg"
            } else {
                code = countryCode
            }
            
            
            let flagURL = "https://www.countryflags.io/\(code)/flat/64.png"
            // URL
            guard let fileURL = URL(string: flagURL) else {
                completion(.failure(.badURL(flagURL)))
                return
            }
            
            // Get some data using URLSession this is asynchronous by default
            let dataTask = URLSession.shared.dataTask(with: fileURL) { (data, response, error) in
                
                guard let unwrappedData = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                if let unwrappedError = error {
                    completion(.failure(.networkClientError(unwrappedError)))
                }
                
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    completion(.failure(.noResponse))
                    return
                }
                
                switch unwrappedResponse.statusCode{
                case 200...299:
                    break
                default:
                    completion(.failure(.invalidStatusCode(unwrappedResponse.statusCode)))
                }
                
                guard let image = UIImage(data: unwrappedData) else {
                    completion(.failure(.noImageFound))
                    return
                }
                completion(.success(image))
                
            }
            dataTask.resume()
        }
    }
}
