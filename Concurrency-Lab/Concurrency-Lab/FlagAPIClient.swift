//
//  FlagAPIClient.swift
//  Concurrency-Lab
//
//  Created by Yuliia Engman on 12/9/19.
//  Copyright © 2019 Yuliia Engman. All rights reserved.
//

import Foundation

enum NetworkError: Error { // conforming to the Error protocol
    case badURL(String)
    case networkClientError(Error)
    case noResponse
    case noData
    case badStatusCode(Int)
    case decodingError(Error)
}

struct CountryAPIClient {
    
    static func getCountries (completion: @escaping (Result<[Country], NetworkError>) -> ()) {
        
        let countryURL = "https://restcountries.eu/rest/v2/name/united"
        // when we will be using US country code we will have to add additional parameter - keyword: String, or something that we will be able to use keyword to access the US country code
        
        guard let url = URL(string: countryURL) else {
            //let _ = NetworkError.badURL
            completion(.failure(.badURL(countryURL)))
            return
}

        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in

            // check for errors
            if let error = error { // if error is nil there was no network error
                completion(.failure(.networkClientError(error)))
            }

            // downcast to HTTPURLResponse to get access to the statusCode
            guard let urlResponse = response as? HTTPURLResponse else {
                // bad response network error
                completion(.failure(.noResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            // find out what is the status code
            switch urlResponse.statusCode { // statusCode in an Int
            case 200...299: break // everything went well
            default:
                completion(.failure(.badStatusCode(urlResponse.statusCode)))
            }
            // use data to create our Country model
            do {
            let countries = try JSONDecoder().decode([Country].self, from: data)
                completion(.success(countries))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        dataTask.resume()
    }
}
