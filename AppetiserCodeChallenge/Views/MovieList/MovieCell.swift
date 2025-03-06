//
//  MovieCell.swift
//  AppetiserCodeChallenge
//
//  Created by Zahoor Gorsi on 03/03/2025.
//

import UIKit
import SDWebImage


protocol MovieCellDelegate: AnyObject {
    func didTapFavoriteButton(for movie: Movie)
}

class MovieCell: UICollectionViewCell {
    
    static var identifier = "MovieCell"
    var mMovie: Movie?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    weak var delegate: MovieCellDelegate?
    private let favoriteButton = UIButton(type: .custom)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // This is the required initializer when the cell is instantiated from a storyboard or XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Any setup can go here, though the button setup can be done in init(frame:) if you're not using Storyboard.
        // Configure the favorite button
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal) // Unfavorite state
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected) // Favorite state
        // Set the default tint color for the favorite button
        favoriteButton.tintColor = .gray // This will be the color for the hollow heart (unfavorite state)
                
        favoriteButton.addTarget(self, action: #selector(btnFavouriteTapped), for: .touchUpInside)
        
        contentView.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            favoriteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
        ])
    }
    
    func configure(with movie: Movie) {
        self.mMovie = movie
        lblTitle.text = movie.trackName
        lblPrice.text = movie.trackPrice.map { "\($0)" } ?? "N/A"
        lblGenre.text = movie.primaryGenreName
        
        if let imageUrl = movie.artworkUrl100, let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "place_holder"))
        } else {
            imageView.image = UIImage(named: "place_holder")
        }
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.cornerRadius = 12 //imageView.frame.size.width / 2
        imageView.clipsToBounds = true // Ensures the image stays within the circle
        
        if PersistenceManager.shared.isFavorite(movieId: movie.trackId) {
            favoriteButton.isSelected = true
            favoriteButton.tintColor = .red
        }else{
            favoriteButton.isSelected = false
            favoriteButton.tintColor = .gray
        }
    }
    
    
    @IBAction func btnFavouriteTapped(_ sender: Any) {
        if let movie = self.mMovie {
            self.delegate?.didTapFavoriteButton(for: movie)
        }
    }
}

