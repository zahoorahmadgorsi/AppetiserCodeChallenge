//
//  APIServiceTests.swift
//  AppetiserCodeChallenge
//
//  Created by Zahoor Gorsi on 03/03/2025.
//

import XCTest
@testable import AppetiserCodeChallenge

class APIServiceTests: XCTestCase {
    
    func testFetchMovies() {
        let expectation = self.expectation(description: "Movies fetched successfully")
        
        APIService.shared.fetchMovies(searchTerm: "star") { result in
            switch result {
            case .success(let movies):
                XCTAssertFalse(movies.isEmpty, "Movies list should not be empty")
                XCTAssertNotNil(movies.first?.trackName, "Movie name should not be nil")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("API call failed: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
