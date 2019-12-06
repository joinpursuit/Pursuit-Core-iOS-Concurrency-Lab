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
    
    var notFinished = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func setUp(){
        
            CountryAPI.obtainCountries{ result in // async
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let countries):
                    self.countryInfoArr = countries
                    self.notFinished = false
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

extension CountryAPI{
    static func obtainCountryFlag(_ countryCode: String, completion: @escaping (Result<UIImage?,NetworkingError>) -> ()){
        DispatchQueue.global(qos: .userInitiated).async {
            var code: String = ""
            if countryCode == "uk"{
                code = "vg"
            } else {
                code = countryCode
            }
            
            
            let flagURL = "https://www.countryflags.io/\(code)/flat/64.png"
            // URL
            guard let fileURL = URL(string: flagURL) else {
                completion(.failure(.badURL(flagURL)))
                return
            }
            
            // Get some data using URLSession this is asynchronous by default
            let dataTask = URLSession.shared.dataTask(with: fileURL) { (data, response, error) in
                
                guard let unwrappedData = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                if let unwrappedError = error {
                    completion(.failure(.networkClientError(unwrappedError)))
                }
                
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    completion(.failure(.noResponse))
                    return
                }
                
                switch unwrappedResponse.statusCode{
                case 200...299:
                    break
                default:
                    completion(.failure(.invalidStatusCode(unwrappedResponse.statusCode)))
                }
                
                guard let image = UIImage(data: unwrappedData) else {
                    completion(.failure(.noImageFound))
                    return
                }
                completion(.success(image))
                
            }
            dataTask.resume()
        }
    }
}
