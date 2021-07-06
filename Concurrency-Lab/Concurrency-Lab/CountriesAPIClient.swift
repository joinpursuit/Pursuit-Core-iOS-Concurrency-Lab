//
//  CountriesAPIClient.swift
//  Concurrency-Lab
//
//  Created by Yuliia Engman on 12/8/19.
//  Copyright © 2019 Yuliia Engman. All rights reserved.
//

import Foundation

struct CountriesAPIClient {
    static func getCountries(completion: @escaping (Result<[Country], NetworkError>) -> ()) {
        let endpointURLString = "https://restcountries.eu/rest/v2/name/united"
        
        NetworkHelper.shared.performDataTask(with: endpointURLString) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                // use data to create our Country model
                do {
                    let countries = try JSONDecoder().decode([Country].self, from: data)
                    completion(.success(countries))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
            

