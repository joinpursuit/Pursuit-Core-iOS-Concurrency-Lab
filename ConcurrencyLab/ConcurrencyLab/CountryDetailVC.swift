//
//  CountryDetailVC.swift
//  ConcurrencyLab
//
//  Created by Sam Roman on 9/3/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class CountryDetailVC: UIViewController {

    var selectedCountry: Countries!
    
    @IBOutlet weak var flagView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var capitalLabel: UILabel!
    
    @IBOutlet weak var populationLabel: UILabel!
    
    
    override func viewDidLoad() {
    nameLabel.text = selectedCountry.name
        capitalLabel.text = "Capital: \(selectedCountry.capital)"
        populationLabel.text = "Population: \(selectedCountry.population)"
    
        super.viewDidLoad()
    }
    


}
