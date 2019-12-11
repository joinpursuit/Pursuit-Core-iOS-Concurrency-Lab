//
//  NetworkHelper.swift
//  concurrencylab
//
//  Created by Ahad Islam on 11/14/19.
//  Copyright © 2019 Ahad Islam. All rights reserved.
//

import Foundation

struct NetworkHelper {
    
    static let manager = NetworkHelper()
    
    func getData(from urlString: String, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        let dataTask = self.urlSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(.badResponse(error)))
            }
            guard let urlResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.noResponse))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            completionHandler(.success(data))
        }
        
        dataTask.resume()
        
    }
    
    private var urlSession = URLSession(configuration: .default)
    private init() {}
    
}
