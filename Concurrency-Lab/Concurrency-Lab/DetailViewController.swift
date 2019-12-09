//
//  DetailViewController.swift
//  Concurrency-Lab
//
//  Created by Yuliia Engman on 12/8/19.
//  Copyright © 2019 Yuliia Engman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    
    var country: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        guard let someCountry = country else {
            fatalError("could not get object from prepare for segue")
        }
        //func configureCell(for country: Country) {
        let urlString = "https://www.countryflags.io/\(someCountry.alpha2Code)/flat/64.png"
        imageView.setImage(with: urlString) { (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(systemName: "photo.fill")
                }
            case .success(let flagImage):
                DispatchQueue.main.async {
                    self.imageView.image = flagImage
                }
            }
        }
        countryLabel.text = someCountry.name
        capitalLabel.text = someCountry.capital
        populationLabel.text = "Population is \(String(someCountry.population)) people"
    }
}

