//
//  PersistenceManagerTests.swift
//  AppetiserCodeChallenge
//
//  Created by Zahoor Gorsi on 03/03/2025.
//

import XCTest
import RealmSwift
@testable import AppetiserCodeChallenge

class PersistenceManagerTests: XCTestCase {
    
    var testMovie: Movie!

    override func setUp() {
        super.setUp()
        
        // Configure Realm for testing
        let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
        Realm.Configuration.defaultConfiguration = config
        
        // Create a test movie
        testMovie = Movie(
            trackId: 12345,
            trackName: "Test Movie",
            artworkUrl100: "https://example.com/image.jpg",
            primaryGenreName: "Action",
            trackPrice: 9.99,
            longDescription: "This is a test movie."
        )
    }

    func testAddFavoriteMovie() {
        PersistenceManager.shared.addFavorite(movie: testMovie)
        let favorites = PersistenceManager.shared.getFavoriteMovies()
        
        XCTAssertEqual(favorites.count, 1, "Favorite movie should be saved")
        XCTAssertEqual(favorites.first?.trackId, testMovie.trackId, "Saved movie ID should match")
    }

    func testRemoveFavoriteMovie() {
        PersistenceManager.shared.addFavorite(movie: testMovie)
        PersistenceManager.shared.removeFavorite(movieId: testMovie.trackId)
        let favorites = PersistenceManager.shared.getFavoriteMovies()
        
        XCTAssertEqual(favorites.count, 0, "Favorite movie should be removed")
    }

    func testIsFavorite() {
        PersistenceManager.shared.addFavorite(movie: testMovie)
        XCTAssertTrue(PersistenceManager.shared.isFavorite(movieId: testMovie.trackId), "Movie should be marked as favorite")
        
        PersistenceManager.shared.removeFavorite(movieId: testMovie.trackId)
        XCTAssertFalse(PersistenceManager.shared.isFavorite(movieId: testMovie.trackId), "Movie should no longer be a favorite")
    }
}
