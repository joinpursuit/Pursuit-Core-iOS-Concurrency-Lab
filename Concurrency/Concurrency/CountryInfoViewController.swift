//
//  ViewController.swift
//  Concurrency
//
//  Created by Cameron Rivera on 12/5/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import UIKit

class CountryInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var countryInfoArr: [CountryInfo] = [] {
        didSet {
            print("\(countryInfoArr.count)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUp(){
        CountryAPI.obtainCountries{ result in // async
            switch result{
            case .failure(let error):
                print(error)
            case .success(let countries):
                self.countryInfoArr = countries
            }
        }
           // print(countryInfoArr.count) // main thread
    }
}

extension CountryInfoViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let xCell = tableView.dequeueReusableCell(withIdentifier: "countryInfoCell", for: indexPath) as? CountryInfoCell else {
            fatalError("Could not dequeue cell as a CountryInfoCell")
        }
        
    }
}

extension CountryInfoViewController: UITableViewDelegate{
    
}
