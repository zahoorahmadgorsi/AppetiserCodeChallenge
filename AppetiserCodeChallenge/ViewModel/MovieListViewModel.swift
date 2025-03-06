//
//  MovieListViewModel.swift
//  AppetiserCodeChallenge
//
//  Created by Zahoor Gorsi on 03/03/2025.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

class MovieListViewModel {
    //Use Combine (@Published var movies) to make data reactive.
    @Published var movies: [Movie] = []  // Observable list of movies
    private var cancellables = Set<AnyCancellable>()
    
    func fetchMovies(with term: String) {
        APIService.shared.fetchMovies(searchTerm: term) { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.movies = movies
                }
            case .failure(let error):
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }
}
