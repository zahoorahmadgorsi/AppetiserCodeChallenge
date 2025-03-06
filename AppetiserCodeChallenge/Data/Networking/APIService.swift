//
//  APIService.swift
//  AppetiserCodeChallenge
//  Handles API calls using Alamofire
//  Created by Zahoor Gorsi on 03/03/2025.
//

import Foundation
import Alamofire

class APIService {
    static let shared = APIService()
    
    func fetchMovies(searchTerm: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&country=au&media=movie"
        
        AF.request(urlString).responseDecodable(of: SearchResult.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct SearchResult: Codable {
    let results: [Movie]
}
