//
//  MovieObject.swift
//  AppetiserCodeChallenge
//
//  Created by Zahoor Gorsi on 03/03/2025.
//

import Foundation
import RealmSwift

//used in realm
class MovieObject: Object {
    @Persisted(primaryKey: true) var trackId: Int
    @Persisted var trackName: String
    @Persisted var artworkUrl100: String
    @Persisted var primaryGenreName: String
    @Persisted var trackPrice: Double?
    @Persisted var longDescription: String?
    
    // Convert from API model to Realm model
    convenience init(movie: Movie) {
        self.init()
        self.trackId = movie.trackId
        self.trackName = movie.trackName
        self.artworkUrl100 = movie.artworkUrl100 ?? ""
        self.primaryGenreName = movie.primaryGenreName
        self.trackPrice = movie.trackPrice
        self.longDescription = movie.longDescription
    }
}
