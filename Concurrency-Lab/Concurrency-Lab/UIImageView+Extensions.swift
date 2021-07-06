//
//  FlagAPIClient.swift
//  Concurrency-Lab
//
//  Created by Yuliia Engman on 12/9/19.
//  Copyright © 2019 Yuliia Engman. All rights reserved.
//

import UIKit


extension UIImageView {
    func setImage(with urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> ()) {        
        NetworkHelper.shared.performDataTask(with: urlString) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                // use data to create our Country model
                if let flag = UIImage(data: data) {
                    completion(.success(flag))
                }
            }
        }
    }
}

