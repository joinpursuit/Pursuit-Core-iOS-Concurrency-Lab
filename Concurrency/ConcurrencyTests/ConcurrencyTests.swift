//
//  ConcurrencyTests.swift
//  ConcurrencyTests
//
//  Created by Cameron Rivera on 12/5/19.
//  Copyright © 2019 Cameron Rivera. All rights reserved.
//

import XCTest
@testable import Concurrency

let countryListEndpoint = "https://restcountries.eu/rest/v2/name/united"

class ConcurrencyTests: XCTestCase {
    func testValidCountryListURL() {
        // Arrange
        
        // Act
        let validURL = URL(string: countryListEndpoint)
        
        // Assert
        XCTAssertNotNil(validURL, "URL returned a value of nil")
    }
    
    
    // async test
    func testObtainCountries() {
        // Arrange
        var countryInfo = [CountryInfo]()
        
        let exp = XCTestExpectation(description: "countries returned")
        
        // Act
        CountryAPI.obtainCountries(){ result in
            switch result{
            case .success(let countries):
                countryInfo = countries
                // Assert
                exp.fulfill()
                XCTAssertGreaterThan(countryInfo.count, 0, "\(countryInfo.count) is not greater than \(0)")
            case .failure(_):
                break
            }
            
        }
        
        wait(for: [exp], timeout: 3.0)
        
        
    }
}
