//
//  Movie.swift
//  AppetiserCodeChallenge
//
//  Created by Zahoor Gorsi on 03/03/2025.
//

import Foundation

struct Movie: Codable {
    let trackId: Int
    let trackName: String
    let artworkUrl100: String?
    let primaryGenreName: String
    let trackPrice: Double?
    let longDescription: String?
}
