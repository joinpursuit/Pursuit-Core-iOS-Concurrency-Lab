//
//  DetailedCountryInfoTableViewCell.swift
//  Concurrency
//
//  Created by Cameron Rivera on 12/6/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import UIKit

class DetailedCountryInfoViewController: UIViewController {
    
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryPopulationLabel: UILabel!
    @IBOutlet weak var countryCapitalLabel: UILabel!
    
    var currentCountry: CountryInfo?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setUp()
    }

    private func setUp(){
        guard let curCountry = currentCountry, var countryCode = currentCountry?.topLevelDomain.first else {
            return
        }

        countryCode.remove(at: countryCode.startIndex)
        countryNameLabel.text = "Name: \(curCountry.name)"
        countryPopulationLabel.text = "Population: \(curCountry.population)"
        countryCapitalLabel.text = "Capital: \(curCountry.capital)"
        
        CountryAPI.obtainCountryFlag(countryCode) { (result) in
            switch result{
            case .failure(let netError):
                print(netError)
            case .success(let flag):
                DispatchQueue.main.async{
                    self.flagImage.image = flag
                }
            }
        }
        
    }
}
