//
//  NetworkEror.swift
//  concurrencylab
//
//  Created by Ahad Islam on 11/14/19.
//  Copyright © 2019 Ahad Islam. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badResponse(Error)
    case noResponse
    case noData
}
