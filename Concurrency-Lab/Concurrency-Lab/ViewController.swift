//
//  ViewController.swift
//  Concurrency-Lab
//
//  Created by Yuliia Engman on 12/8/19.
//  Copyright © 2019 Yuliia Engman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var arrayOfCountries = [Country]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchQuery = "" {
        didSet {
            CountryAPIClient.getCountries{ result in
                switch result {
                case .success(let countries):
                    if self.searchQuery == "" {
                        self.arrayOfCountries = countries
                    } else {
                        self.arrayOfCountries = countries.filter{$0.name.lowercased().contains(self.searchQuery.lowercased())}
                    }
                case .failure(let error):
                    print("Encountered Error: \(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        loadData()
    }
    
    func loadData() {
        CountryAPIClient.getCountries{result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let countries):
                self.arrayOfCountries = countries
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as? CountryTableViewCell else {
            fatalError("Could not dequeue cell as a CountryTableViewCell")
        }
        let country = arrayOfCountries[indexPath.row]
        
        customCell.configureCell(for: country)
        
        return customCell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            loadData()
            return
        }
        searchQuery = searchText
    }
}

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let detailPeopleVC = segue.destination as? DetailPeopleViewController, let indexPath = tableView.indexPathForSelectedRow else {
//            fatalError("verify class name in identity inspector")
//        }
//        let contact = userContacts[indexPath.row]
//        detailPeopleVC.contactsOfUser = contact
//    }
//}


