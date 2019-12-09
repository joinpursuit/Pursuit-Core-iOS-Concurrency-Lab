//
//  ViewController.swift
//  Concurrency Lab
//
//  Created by Bienbenido Angeles on 12/5/19.
//  Copyright © 2019 Bienbenido Angeles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var countries: [CountryList] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var query = "" {
        didSet{
            countries = getCountries().filter{$0.name.lowercased().contains(query.lowercased())}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        searchBar.delegate = self
        loadData()
    }
    
    
    // be wary of using inner function dependency
    func loadData(){
        countries = getCountries()
    }
    
    func getCountries() -> [CountryList]{
        let users = CountryListAPI.getListOfCountries(completion: { (result) in
            switch result{
            case .failure(let appError):
                fatalError("Error: \(appError)")
            case .success(let countries):
                self.countries = countries
            }
        })
        return users
    }

}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as? CountryCell else {
            fatalError("failed to deque cell, check reuseIndentifier")
        }
        let country = countries[indexPath.row]
        
        cell.configureCell(withFlagUrlString: "https://www.countryflags.io/\(country.alpha2Code)/flat/64.png", for: country)
        
        return cell
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            loadData()
            return
        }
        query = searchText
    }
}
