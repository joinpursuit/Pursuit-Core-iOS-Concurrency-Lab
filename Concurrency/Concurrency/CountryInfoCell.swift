//
//  CountryInfoCell.swift
//  Concurrency
//
//  Created by Cameron Rivera on 12/5/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import UIKit

class CountryInfoCell: UITableViewCell {
    
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryPopulationLabel: UILabel!
    @IBOutlet weak var countryCapitalLabel: UILabel!
    
    func cellSetUp(_ Country: CountryInfo,_ flag: UIImage ){
        self.countryFlag.image = flag
        self.countryNameLabel.text = Country.name
        self.countryPopulationLabel.text = Country.population
        self.countryCapitalLabel.text = Country.capital
    }
}
