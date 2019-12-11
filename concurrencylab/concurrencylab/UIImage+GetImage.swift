//
//  UIImage+GetImage.swift
//  concurrencylab
//
//  Created by Ahad Islam on 12/10/19.
//  Copyright © 2019 Ahad Islam. All rights reserved.
//

import UIKit

extension UIImage {
    static func getImage(from string: String, completionHandler: @escaping (Result<UIImage, NetworkError>) -> ()) {
        NetworkHelper.manager.getData(from: string) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(.badResponse(error)))
            case .success(let data):
                if let image = UIImage(data: data) {
                    completionHandler(.success(image))
                } else {
                    completionHandler(.failure(.noData))
                }
            }
        }
    }
}
