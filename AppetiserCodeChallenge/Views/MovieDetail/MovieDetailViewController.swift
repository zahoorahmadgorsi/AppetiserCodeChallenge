//
//  Untitled.swift
//  AppetiserCodeChallenge
//
//  Created by Zahoor Gorsi on 06/03/2025.
//

import UIKit

//When user taps on favourite/unfavourite on movie details we are just reloading favrouties movies and list of movies on the parent VC, so that when user go back this action of favourite/unfavourite is reflected.
protocol MovieDetailDelegate: AnyObject {
    func reloadMovies()
}

//Implementing MVC (Model-View-Controller) is Apple's default architectural pattern and is suitable for simple applications or small projects.
class MovieDetailViewController: UIViewController {
    var mMovie: Movie? // Replace `Movie` with your actual data model
    @IBOutlet weak var imgViewMovieTitleImage: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblMovieDescription: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    weak var delegate: MovieDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the passed movie data to configure the view
        if let movie = mMovie {
            self.title = movie.trackName
            
            if let imageUrl = movie.artworkUrl100, let url = URL(string: imageUrl) {
                self.imgViewMovieTitleImage.sd_setImage(with: url, placeholderImage: UIImage(named: "place_holder"))
            } else {
                self.imgViewMovieTitleImage.image = UIImage(named: "place_holder")
            }
            
            lblPrice.text = movie.trackPrice.map { "\($0)" } ?? "N/A"
            lblGenre.text = movie.primaryGenreName
            self.lblMovieDescription.text = movie.longDescription
            
            setBtnTitle()
        }
    }
    
    @IBAction func btnFavouriteTapped(_ sender: Any) {
        if let movie = self.mMovie {
            if PersistenceManager.shared.isFavorite(movieId: movie.trackId) {
                PersistenceManager.shared.removeFavorite(movieId: movie.trackId)
            } else {
                PersistenceManager.shared.addFavorite(movie: movie)
            }
            setBtnTitle()
            self.delegate?.reloadMovies()
        }
    }
    
    func setBtnTitle(){
        if let movie = self.mMovie {
            if PersistenceManager.shared.isFavorite(movieId: movie.trackId) {
                self.btnFavourite.setTitle("Make Unfavourite", for: .normal)
                self.btnFavourite.setTitleColor(.blue, for: .normal)
            }else{
                self.btnFavourite.setTitle("Make Favourite", for: .normal)
                self.btnFavourite.setTitleColor(.red, for: .normal)
            }
        }
    }
}
