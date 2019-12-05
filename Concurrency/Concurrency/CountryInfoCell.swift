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
    
    func cellSetUp(_ Country: CountryInfo){
        guard var countryCode = Country.topLevelDomain.first else {
            return
        }
        countryCode.remove(at: countryCode.startIndex)
        self.countryNameLabel.text = "Name: \(Country.name)"
        self.countryPopulationLabel.text = "Population: \(String(Country.population))"
        self.countryCapitalLabel.text =
            "Capital: \(Country.capital)"
        
            CountryAPI.obtainCountryFlag(countryCode) { result in
                switch result{
                case .failure(_):
                    break
                case .success(let image):
                    DispatchQueue.main.async{
                    self.countryFlag.image = image
                    }
                }
        }
    }
}
