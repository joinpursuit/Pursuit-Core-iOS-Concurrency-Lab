//
//  NetworkHelper.swift
//  Concurrency Lab
//
//  Created by Bienbenido Angeles on 12/9/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import Foundation

class NetworkHelper {
    static let shared = NetworkHelper()
    private var session: URLSession
    
    private init(){
        session = URLSession(configuration: .default)
    }
    
    func performDataTask(with urlString: String, completionHandler: @escaping( Result<Data, AppError>) -> ()){
        
        guard let url = URL(string: urlString) else{
            completionHandler(.failure(.badURL(urlString)))
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error{
                completionHandler(.failure(.networkClientError(error)))
            }
            
            guard let urlResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.noResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            switch urlResponse.statusCode{
            case 200...299:
                break
            default:
                completionHandler(.failure(.badStatusCode(urlResponse.statusCode)))
            }
            
            completionHandler(.success(data))
        }
        
        dataTask.resume()
    }
    
}
