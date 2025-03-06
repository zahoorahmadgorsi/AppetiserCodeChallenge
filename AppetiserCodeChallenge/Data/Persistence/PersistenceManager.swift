//
//  PersistenceManager.swift
//  AppetiserCodeChallenge
//  Handles CoreData/Realm for favorites & last visit date
//  Created by Zahoor Gorsi on 03/03/2025.
//

import Foundation
import RealmSwift

class PersistenceManager {
    static let shared = PersistenceManager()
    private let realm = try! Realm()

    // MARK: - Save Favorite Movie
    func addFavorite(movie: Movie) {
        let movieObject = MovieObject(movie: movie)
        try? realm.write {
            realm.add(movieObject, update: .modified)
        }
    }

    // MARK: - Remove Favorite Movie
    func removeFavorite(movieId: Int) {
        if let movieToDelete = realm.object(ofType: MovieObject.self, forPrimaryKey: movieId) {
            try? realm.write {
                realm.delete(movieToDelete)
            }
        }
    }

    // MARK: - Check if Movie is Favorite
    func isFavorite(movieId: Int) -> Bool {
        return realm.object(ofType: MovieObject.self, forPrimaryKey: movieId) != nil
    }

    // MARK: - Get All Favorite Movies
    func getFavoriteMovies() -> [Movie] {
        return realm.objects(MovieObject.self).map { movieObject in
            return Movie(
                trackId: movieObject.trackId,
                trackName: movieObject.trackName,
                artworkUrl100: movieObject.artworkUrl100,
                primaryGenreName: movieObject.primaryGenreName,
                trackPrice: movieObject.trackPrice,
                longDescription: movieObject.longDescription
            )
        }
    }

    // MARK: - Save Last Visited Date
    func saveLastVisitDate() {
        let defaults = UserDefaults.standard
        let date = Date()
        defaults.set(date, forKey: "lastVisitDate")
    }

    // MARK: - Retrieve Last Visited Date
    func getLastVisitDate() -> String {
        let defaults = UserDefaults.standard
        if let lastDate = defaults.object(forKey: "lastVisitDate") as? Date {
            let timeElapsed = lastDate.timeSinceAppClosed()
            return "Last visit: \(timeElapsed)"
        }
        return "No previous visit recorded"
    }
}
