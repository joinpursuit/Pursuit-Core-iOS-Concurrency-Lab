//
//  ConcurrencyLabTests.swift
//  ConcurrencyLabTests
//
//  Created by Sam Roman on 9/3/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import XCTest
@testable import ConcurrencyLab

class ConcurrencyLabTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func Example() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func PerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func getDataFromJSON(name: String) -> Data {
        guard let pathToData = Bundle.main.path(forResource: name , ofType: "json") else { fatalError("couldnt find json file called \(name).json")}
        let url = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch let jsonError {
            fatalError("couldnt get data from json file \(jsonError)")
        }
    }
    
    func testCountriesLoaded (){
        let data = getDataFromJSON(name: "countries")
        let testCountries = Countries.getInfo(from: data)
        XCTAssertTrue(testCountries.self != nil, "Countries failed to load")
        
    }
    
    func testCountryArrayCount() {
        let data = getDataFromJSON(name:"countries")
        let testCountry = Countries.getInfo(from: data)
        XCTAssertTrue(testCountry!.count == 6 , "Not equal to 6 Countries")
    }
    
    func testValuesAreCorrect() {
        let data = getDataFromJSON(name:"countries")
        let testCountry = Countries.getInfo(from: data)
        for i in testCountry! {
        XCTAssertTrue(i.capital == String(i.capital), "capital not a string")
        XCTAssertTrue(i.name == String(i.name), "name not a string")
        XCTAssertTrue(i.population == Int(i.population), "population not an Int")
        
    }
    }
    

}
