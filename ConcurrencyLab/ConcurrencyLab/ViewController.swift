//
//  ViewController.swift
//  ConcurrencyLab
//
//  Created by Sam Roman on 9/3/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    @IBOutlet weak var countrySearchBar: UISearchBar!
    
    @IBOutlet weak var countriesTableView: UITableView!
    
    var countries = [Countries]() {
        didSet {
        countriesTableView.reloadData()
        }
    }
    
    var currency: Rates!
    
    
    
    

    var searchString: String? = nil {
        didSet {
            self.countriesTableView.reloadData()
        }
    }
    
    var searchResults: [Countries] {
        get {
            guard let searchString = searchString else {
                return countries
                
            }
            guard searchString != "" else {
                return countries
            }
    
            return countries.filter{$0.name.contains(searchString)}
            
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCountry = searchResults[indexPath.row]
        guard let cell = countriesTableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as? CustomCountryCell else {return UITableViewCell()}
        cell.nameLabel.text = currentCountry.name
        cell.capitalLabel.text = "Capital: \(currentCountry.capital)"
        cell.populationLabel.text = "Pop: \(String(currentCountry.population))"
        return cell
    }
    

    
    private func loadData() {
    CountryAPIClient.shared.fetchData { (result) in
        DispatchQueue.main.async {
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let countries):
                self.countries = countries
            }
        }
        }
        CurrencyAPIClient.shared.fetchData { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let rates):
                self.currency = rates
                }
            }
        }
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else {
            fatalError("No identifier in segue")
        }
        switch segueIdentifier {
        case "countrySegue":
            guard let detailVC = segue.destination as? CountryDetailVC
                else {
                    fatalError("Unexpected segue")}
            guard let selectedIndexPath = countriesTableView.indexPathForSelectedRow else {
                fatalError("No row selected")
            }
            detailVC.selectedCountry = searchResults[selectedIndexPath.row]
        default:
            fatalError("Unexpected segue identifier")
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        loadData()
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        countrySearchBar.delegate = self
        print(currency)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchString = countrySearchBar.text
    }
    
}

