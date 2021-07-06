//
//  CountryTableViewCell.swift
//  Concurrency-Lab
//
//  Created by Yuliia Engman on 12/8/19.
//  Copyright © 2019 Yuliia Engman. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    func configureCell(for country: Country) {
        let urlString = "https://www.countryflags.io/\(country.alpha2Code)/flat/64.png"
        flagImage.setImage(with: urlString) { (result) in
            switch result {
            case .failure:
            DispatchQueue.main.async {
                self.flagImage.image = UIImage(systemName: "photo.fill")
                }
            case .success(let flagImage):
                DispatchQueue.main.async {
                    self.flagImage.image = flagImage
                }
            }
        }
        countryLabel.text = country.name
        capitalLabel.text = "Capital is \(country.capital)"
        populationLabel.text = "Population is \(String(country.population)) people"
    }
    
}
