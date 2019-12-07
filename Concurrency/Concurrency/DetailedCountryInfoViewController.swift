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
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    
    var currentCountry: CountryInfo?
    var exchangeRates: ExchangeRate? {
        didSet{
            setUp()
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.getExchangeRates()
    }
    
    private func setUp(){
        guard let curCountry = currentCountry, var countryCode = currentCountry?.topLevelDomain.first, let exRate = exchangeRates else {
            return
        }
        
        countryCode.remove(at: countryCode.startIndex)
        DispatchQueue.main.async{
            self.countryNameLabel.text = "Name: \(curCountry.name)"
            self.countryPopulationLabel.text = "Population: \(curCountry.population)"
            self.countryCapitalLabel.text = "Capital: \(curCountry.capital)"
            self.currencyLabel.text = "Currency: \(curCountry.currencies.first!.name)"
            self.exchangeRateLabel.text = "Exchange Rate: \(String(format: "%.2f", CurrencyAPI.getAnExchangeRate(using: curCountry.currencies.first!.code, and: exRate)))"
        }
        
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
    
    private func getExchangeRates() {
        CurrencyAPI.getCurrencies { (result) in
            switch result{
            case .failure(let netError):
                print(netError)
            case .success(let conCurrency):
                self.exchangeRates = conCurrency.rates
            }
        }
    }
}
