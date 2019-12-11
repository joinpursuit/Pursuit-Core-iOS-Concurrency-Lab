//
//  CountryFetchingService.swift
//  concurrencylab
//
//  Created by Ahad Islam on 11/14/19.
//  Copyright © 2019 Ahad Islam. All rights reserved.
//

import Foundation

class CountryFetchingService {
    static let manager = CountryFetchingService()
    
    func getCountries(completionHandler: @escaping (Result<[Country], Error>) -> Void) {
        NetworkHelper.manager.getData(from: countries) { (result) in
            switch result {
            case let .success(data):
                do {
                    let countries = try JSONDecoder().decode([Country].self, from: data)
                    completionHandler(.success(countries))
                } catch {
                    completionHandler(.failure(error))
                }
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private var countries = "https://restcountries.eu/rest/v2/name/united"
    private init() {}
}
