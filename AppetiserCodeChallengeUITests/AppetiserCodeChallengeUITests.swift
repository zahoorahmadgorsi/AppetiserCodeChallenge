//
//  AppetiserCodeChallengeUITests.swift
//  AppetiserCodeChallengeUITests
//
//  Created by Zahoor Gorsi on 03/03/2025.
//


import XCTest

final class AppetiserCodeChallengeUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false // Stops execution if a test fails
        app = XCUIApplication()
        app.launch() // Launch the app before each test
    }
    
    override func tearDown() {
        app.terminate()
        super.tearDown()
    }
    
    // MARK: - Test Movie Search Functionality
    func testSearchMovie() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists, "Search field should exist")
        
        searchField.tap()
        searchField.typeText("Star Wars")
        sleep(3) // Allow API call to complete
        
        let firstMovie = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstMovie.exists, "Search results should populate")
    }

    // MARK: - Test Adding and Removing Favorites
    func testAddRemoveFavorite() {
        let firstMovie = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstMovie.exists, "Movies should be displayed")

        let favoriteButton = firstMovie.buttons["FavoriteButton"] // Assuming the button has an accessibility identifier
        XCTAssertTrue(favoriteButton.exists, "Favorite button should exist")
        
        favoriteButton.tap()
        sleep(2) // Wait for UI update
        
        let favoriteList = app.collectionViews["FavoriteCollectionView"] // Assuming the favorite collection view has an identifier
        XCTAssertTrue(favoriteList.cells.count > 0, "Movie should be added to favorites")
        
        // Remove the favorite
        favoriteButton.tap()
        sleep(2)
        XCTAssertEqual(favoriteList.cells.count, 0, "Movie should be removed from favorites")
    }

    // MARK: - Test Favorites Persistence
    func testFavoritesPersistAcrossLaunches() {
        let firstMovie = app.collectionViews.cells.firstMatch
        let favoriteButton = firstMovie.buttons["FavoriteButton"]
        
        favoriteButton.tap()
        sleep(2)
        
        app.terminate()
        app.launch() // Restart the app
        
        let favoriteList = app.collectionViews["FavoriteCollectionView"]
        XCTAssertTrue(favoriteList.cells.count > 0, "Favorite should persist after app relaunch")
    }
}


