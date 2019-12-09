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
        // image = ?
        //        animalImageView.image = UIImage(named: animal.imageNumber.description)
        countryLabel.text = country.name
        capitalLabel.text = country.capital
        populationLabel.text = String(country.population)
    }
    
}
