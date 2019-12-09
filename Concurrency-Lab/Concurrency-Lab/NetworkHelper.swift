//
//  NetworkHelper.swift
//  Concurrency-Lab
//
//  Created by Yuliia Engman on 12/9/19.
//  Copyright © 2019 Yuliia Engman. All rights reserved.
//


/*
 To get data from url - Internet we have to use NetworkHelper.
 NetworkHelper get data from Internet.
 Also, if we add enum cases it also will catch errors!
 In addition, we should creat model for our API (just for countries, for flag we just have url link)
 Also, we making APIClinet, where we create func getCounties (that func will actually give us countries)
 for image, since is it separate url, we can use ImageAPIClient or just make separate file with UIImageView Extension (there we getting data to create an image!)
 The image of the flag we will call directly in the cell file!
 
 Basically, when we are creating functions we want to make them generic, that we will be able to use them in different places
 Therefore, we will use image url in the last step - in my particular scenario - in cell!
 */


import Foundation
// we need to make our NetworkHelper a singleton
// this means there will only ever be one instance of this class
// throughout the application, at no point will someone be able to create a new instance, e.g NetworkHelper() will be a compilert error

enum NetworkError: Error { // conforming to the Error protocol
    case badURL(String)
    case networkClientError(Error)
    case noResponse
    case noData
    case badStatusCode(Int)
    case decodingError(Error)
}

class NetworkHelper {
    // we will create a "shared" instance of NetworkHelper
    static let shared = NetworkHelper()
    private var session: URLSession
    // we will make the default initializer private
    // required in order to be considered a singleton
    // also forbids anyone from creating an instance of NetworkHelper
    private init() {
        session = URLSession(configuration: .default)
    }
    
    func performDataTask(with urlString: String, completion: @escaping (Result<Data, NetworkError>) -> ()) { // Generics allows you to use different type = Any Data type
        
        // creating a URL from the given String
        guard let url = URL(string: urlString) else {
            // handle bad url error case
            completion(.failure(.badURL(urlString)))
            return
        }
        
        //two states on dataTask, resume() and suspended by default
        // suspended simply won't perform network request
        // this ultimatelly leads to debugging errors and time lost if
        // you don't explicitly resume() request
        
        let dataTask = session.dataTask(with: url) {(data, response, error) in
            
            if let error = error {
                completion(.failure(.networkClientError(error)))
            }
            
            // 2. downcast URLResponse (response) to HTTPURLResponse to
            // get access to the statusCode property on HTTPURLResponse
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            // 3. unwrap the data object
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // 4. validate that the status code is in the 200 range otherwise it's a
            // bad status code
            switch urlResponse.statusCode {
            case 200...299: break // everything went well here
            default:
                completion(.failure(.badStatusCode(urlResponse.statusCode)))
                return
            }
            
            // 5. capture data as success case
            completion(.success(data))
        }
        dataTask.resume()
    }
}
