//
//  ViewController.swift
//  Concurrency
//
//  Created by Cameron Rivera on 12/5/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import UIKit

class CountryInfoViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Properties
    var countryInfoArr: [CountryInfo] = [] {
        didSet {
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    var userQuery = "" {
        didSet{
            CountryAPI.obtainCountries{ result in
                switch result{
                case .success(let countries):
                    if self.userQuery == "" {
                        self.countryInfoArr = countries
                    } else {
                        self.countryInfoArr = countries.filter{$0.name.lowercased().contains(self.userQuery.lowercased())}
                    }
                case .failure(let error):
                    print("Encountered Error: \(error)")
                }
            }
        }
    }
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    // MARK: Helper Methods
    private func setUp(){
        
            CountryAPI.obtainCountries{ result in // async
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let countries):
                    self.countryInfoArr = countries
                }
            }
            // print(self.countryInfoArr.count) // main thread
        }
}
// MARK: TableView Data Source
extension CountryInfoViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let xCell = tableView.dequeueReusableCell(withIdentifier: "countryInfoCell", for: indexPath) as? CountryInfoCell else {
                fatalError("Could not dequeue cell as a CountryInfoCell")
            }
            xCell.cellSetUp(countryInfoArr[indexPath.row])
            return xCell

    }
}
// MARK: TableView Delegate
extension CountryInfoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newStoryboard = UIStoryboard(name: "SecondStoryboard", bundle: nil)
        guard let detailedCountryInfoVC = newStoryboard.instantiateViewController(withIdentifier: "detailedCountryInfoVC") as? DetailedCountryInfoViewController else {
            fatalError("Could not create instance of detailed Country Info View Controller")
        }
        detailedCountryInfoVC.currentCountry = countryInfoArr[indexPath.row]
        navigationController?.pushViewController(detailedCountryInfoVC, animated: true)
    }
}

// MARK: UISearchBar Delegate methods
extension CountryInfoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        userQuery = searchText
    }
}
