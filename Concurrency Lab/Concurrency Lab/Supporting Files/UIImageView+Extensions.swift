//
//  UIImageView+Extensions.swift
//  Concurrency Lab
//
//  Created by Bienbenido Angeles on 12/9/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(with urlString: String, completionHandler: @escaping (Result<UIImage, AppError>)->()){
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemGray
        activityIndicator.center = center
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        NetworkHelper.shared.performDataTask(with: urlString) { [weak activityIndicator] (result) in
            DispatchQueue.main.async {
                activityIndicator?.stopAnimating()
            }
            switch result{
            case .failure(let appError):
                completionHandler(.failure(.networkClientError(appError)))
            case .success(let data):
                if let image = UIImage(data: data){
                    completionHandler(.success(image))
                }
            }
        }
        
    }

}
