//
//  CountryAPI.swift
//  Concurrency
//
//  Created by Cameron Rivera on 12/5/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import Foundation

enum NetworkingError: Error{
    case badURL(String)
    case invalidData
    case networkClientError(Error)
    case invalidStatusCode(Int)
    case decodingError(Error)
    case noResponse
}

struct CountryAPI {
    
    static func obtainCountries(completion: @escaping (Result<[CountryInfo], NetworkingError>) -> ()) {
        let countryAPIURL = "https://restcountries.eu/rest/v2/name/united"
        // Start by creating URL
        guard let fileURL = URL(string: countryAPIURL) else {
            completion(.failure(.badURL(countryAPIURL)))
            return
        }
        
        // Get Some data using URL Session because this is by default an Asynchronous action.
        let dataTask = URLSession.shared.dataTask(with: fileURL) { (data,response,error) in
            
            // Unwrap your data.
            guard let unwrappedData = data else {
                completion(.failure(.invalidData))
                print("invalid data")
                return
            }
            // Unwrap you error.
            if let unwrappedError = error{
                completion(.failure(.networkClientError(unwrappedError)))
                print("networkClientError")
                return
            }
            
            // unwrap your response as a HTTPURLResponse
            guard let unwrappedResponse = response as? HTTPURLResponse else{
                completion(.failure(.noResponse))
                print("No response")
                return
            }
            
            switch unwrappedResponse.statusCode{
            case 200...299:
                break
            default:
                completion(.failure(.invalidStatusCode(unwrappedResponse.statusCode)))
                print("Status Code Error")
            }
            
            // Now, we have everything we need to decode!
            do{
                let countries = try JSONDecoder().decode([CountryInfo].self, from: unwrappedData)
                completion(.success(countries))
                print("Success!")
            } catch {
                completion(.failure(.decodingError(error)))
                print("Decoding Error")
            }
        }
        dataTask.resume()
    }
}
