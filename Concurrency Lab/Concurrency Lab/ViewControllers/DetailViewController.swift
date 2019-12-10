//
//  DetailViewController.swift
//  Concurrency Lab
//
//  Created by Bienbenido Angeles on 12/9/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var passedObj: CountryList?
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var countryLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureData()
    }
    
    func configureData(){
        guard let validCountry = passedObj else {
            fatalError("failed to unwrap country, check on view controller if countries is nil")
        }
        
        
        imageView.setImage(with: "https://www.countryflags.io/\(validCountry.alpha2Code)/flat/64.png") { (result) in
            switch result{
            case .failure:
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(systemName: "person.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        countryLabel.text = "Country: \(validCountry.name)\nCapital: \(validCountry.capital)\nPopulation: \(validCountry.population)"
    }

}
