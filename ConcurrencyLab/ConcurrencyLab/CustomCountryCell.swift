//
//  CustomCountryCell.swift
//  ConcurrencyLab
//
//  Created by Sam Roman on 9/3/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class CustomCountryCell: UITableViewCell {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var capitalLabel: UILabel!
    
    @IBOutlet weak var populationLabel: UILabel!
    
    @IBOutlet weak var flagView: UIImageView!
    
    
    
    //image files arent the correct type 
//    func loadImage(flagURL: String){
//        guard let url = URL(string: flagURL) else {fatalError()}
//        do {
//        let data = try Data(contentsOf: url)
//        flagView.image = UIImage(data: data)
//        } catch {
//            fatalError("couldnt load image")
//        }
//
//
//
//    }
   

}
