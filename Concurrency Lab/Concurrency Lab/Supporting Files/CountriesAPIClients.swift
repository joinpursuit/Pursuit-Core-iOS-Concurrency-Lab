//
//  CountriesAPIClients.swift
//  Concurrency Lab
//
//  Created by Bienbenido Angeles on 12/9/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import Foundation

struct CountryListAPI{
    static func getListOfCountries(completion: @escaping (Result<[CountryList],AppError>)->()) -> [CountryList]{
        let endPointURLString = "https://restcountries.eu/rest/v2/name/united"
        let countryList = [CountryList]()
        NetworkHelper.shared.performDataTask(with: endPointURLString) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do{
                    let countryList = try JSONDecoder().decode([CountryList].self, from: data)
                    completion(.success(countryList))
                } catch{
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        return countryList
    }
}



