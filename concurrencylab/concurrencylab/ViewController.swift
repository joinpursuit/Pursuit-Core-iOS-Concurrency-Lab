//
//  ViewController.swift
//  concurrencylab
//
//  Created by Ahad Islam on 11/14/19.
//  Copyright © 2019 Ahad Islam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    var countries = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.flagTableView.reloadData()
            }
        }
    }
    
    lazy var flagTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Flag Cell")
        return tableView
    }()
    
    // MARK: - Lifecycle Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureTableView()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCountries()
    }
    
    // MARK: - Private Methods
    
    private func loadCountries() {
        CountryFetchingService.manager.getCountries { (result) in
            switch result {
            case .success(let countries):
                self.countries = countries
            case .failure(let error):
                print("Error getting posts. \(error)")
            }
            
        }
    }
    
    private func configureTableView() {
        flagTableView.delegate = self
        flagTableView.dataSource = self
    }
    
    private func loadImages(urlString: String) -> UIImage? {
        var onlineImage: UIImage?
        guard let url = URL(string: urlString) else {
            print("Bad url")
            return nil
        }
        DispatchQueue.global(qos: .userInitiated).async {
            do {
            let data = try Data(contentsOf: url)
                
            onlineImage = UIImage(data: data)
            print("print")
                
            } catch {
                print("oh no data wasnt caught from url: \(error)")
            }
        }
        return onlineImage
    }
    
    // MARK: - Constraints
    
    private func setupTableView() {
        view.addSubview(flagTableView)
        flagTableView.delegate = self
        flagTableView.dataSource = self
        flagTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            flagTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            flagTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            flagTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            flagTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate {}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = flagTableView.dequeueReusableCell(withIdentifier: "Flag Cell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        cell.textLabel?.numberOfLines = 0
        let x = "https://www.countryflags.io/\(countries[indexPath.row].alpha2Code.lowercased())/flat/64.png"
        print(x)
        UIImage.getImage(from: x) { (result) in
            switch result {
            case .failure(let error):
                print("Error getting image: \(error)")
            case .success(let image):
                DispatchQueue.main.async {
                    cell.imageView?.image = image
                }
            }
        }
        return cell
    }
    
}
