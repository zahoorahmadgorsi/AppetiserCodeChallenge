//
//  MovieListViewController.swift
//  AppetiserCodeChallenge
//
//  Created by Zahoor Gorsi on 03/03/2025.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

//Implementing this VC using MVVM (Model-View-ViewModel) because it has slight complicattion thats why to improving maintainability, testability, and separation of concerns using MVVM.
class MovieListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favoriteCollectionView: UICollectionView! // Horizontal favorite list
    @IBOutlet weak var lastVisitLabel: UILabel!
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!  // Main movie list
    private let movieViewModel = MovieListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private var favoriteMovies: [Movie] = []

    private let emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Make some movies as favourite."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gray
        label.isHidden = true // Initially hidden
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movies"
        //To interact with UI elements in tests, we must assign accessibility identifiers to them.
        favoriteCollectionView.accessibilityIdentifier = "FavoriteCollectionView"
        
        setupSearchBar()
//        setupBinding()
        setupFavoriteCollectionView()
        loadFavorites()
        
        setupMoviesCollectionView()
        bindViewModel()
        //it must contain star, as per requirement
        movieViewModel.fetchMovies(with: "star")  // Fetch movies when view loads
        
        lastVisitLabel.text = PersistenceManager.shared.getLastVisitDate()
        
        PersistenceManager.shared.saveLastVisitDate()
//        viewModel.searchMovies(with: "star")
        
    }

            
    
    private func setupBinding() {
//        searchBar.rx.text.orEmpty
//            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .subscribe(onNext: { [weak self] query in
//                self?.viewModel.searchMovies(with: query)
//            })
//            .disposed(by: disposeBag)
        
    }
    
    private func setupFavoriteCollectionView() {
        // Create and configure the flow layout for left alignment
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        // Set section insets to avoid any padding (align cells to left)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // Adjust spacing between cells (horizontal and vertical)
        layout.minimumInteritemSpacing = 10   // Adjust as needed
        layout.minimumLineSpacing = 10        // Adjust as needed
        // Set the layout to the collection view
        favoriteCollectionView.setCollectionViewLayout(layout, animated: false)
        
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
        favoriteCollectionView.register(UINib(nibName: "FavoriteMovieCell", bundle: nil), forCellWithReuseIdentifier: "FavoriteMovieCell")
        
        //Adding empty state
        favoriteCollectionView.addSubview(emptyMessageLabel)
            emptyMessageLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptyMessageLabel.centerXAnchor.constraint(equalTo: favoriteCollectionView.centerXAnchor),
                emptyMessageLabel.centerYAnchor.constraint(equalTo: favoriteCollectionView.centerYAnchor)
            ])
    }
    
    private func setupMoviesCollectionView() {
        // Create and configure the flow layout for left alignment
        let layout = UICollectionViewFlowLayout()

        // Set section insets to avoid any padding (align cells to left)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        // Adjust spacing between cells (horizontal and vertical)
        layout.minimumInteritemSpacing = 10   // Adjust as needed
        layout.minimumLineSpacing = 10        // Adjust as needed

        // Set the layout to the collection view
        moviesCollectionView.setCollectionViewLayout(layout, animated: false)
        
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: MovieCell.identifier)
    }
    
    private func bindViewModel() {
        movieViewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.moviesCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }

    //This method simply loads the favourites movies from the realm
    private func loadFavorites() {
        favoriteMovies = PersistenceManager.shared.getFavoriteMovies()
        favoriteCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.favoriteCollectionView{
            let count = favoriteMovies.count // data source
            emptyMessageLabel.isHidden = count > 0  //hiding unhiding the empty state based on the cont
            return count
        }else{
            return movieViewModel.movies.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.favoriteCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMovieCell.identifier, for: indexPath) as? FavoriteMovieCell else {
                return UICollectionViewCell()
            }
            let movie = favoriteMovies[indexPath.row]
            cell.configure(with: movie)
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
                return UICollectionViewCell()
            }
            let movie = movieViewModel.movies[indexPath.row]
            cell.configure(with: movie)
            cell.delegate = self
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.favoriteCollectionView{
            return CGSize(width: 100, height: 100)
        }else{
            let width = collectionView.frame.width - 20  // Full width of collection view
            return CGSize(width: width / 2 , height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Instantiate the detailed view controller
        let storyboard = UIStoryboard(name: "MovieList", bundle: nil)
        let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        // Pass the selected movie to the detailed view controller
        var selectedMovie = movieViewModel.movies[indexPath.item]
        
        if collectionView == self.favoriteCollectionView{
            selectedMovie = favoriteMovies[indexPath.item]
        }
        else{
            // Pass the selected movie to the detailed view controller
            selectedMovie = movieViewModel.movies[indexPath.item]
        }
        movieDetailVC.mMovie = selectedMovie
        movieDetailVC.delegate = self
        // Present the detailed view controller
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

// MARK: - MovieCellDelegate (Handling Favorite Action on the movie cell)
extension MovieListViewController: MovieCellDelegate {
    func didTapFavoriteButton(for movie: Movie) {
        if PersistenceManager.shared.isFavorite(movieId: movie.trackId) {
            PersistenceManager.shared.removeFavorite(movieId: movie.trackId)
        } else {
            PersistenceManager.shared.addFavorite(movie: movie)
        }
        reloadMovies()
    }
}

// MARK: - MovieDetailDelegate (Handling Favorite Action on the movie detail)
extension MovieListViewController: MovieDetailDelegate {
    func reloadMovies() {
        moviesCollectionView.reloadData()
        loadFavorites()
        //Ensuring that empty state does get update After Data is Fetched
        emptyMessageLabel.isHidden = !favoriteMovies.isEmpty
    }
}

// MARK: - UISearchBarDelegate (Handling search bar related stuff)
extension MovieListViewController: UISearchBarDelegate {
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search movies..."
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        //load movies
        movieViewModel.fetchMovies(with: searchText)
    }
}
