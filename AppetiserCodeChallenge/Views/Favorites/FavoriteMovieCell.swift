//
//  FavoriteMovieCell.swift
//  AppetiserCodeChallenge
//
//  Created by Zahoor Gorsi on 03/03/2025.
//

import UIKit
import SDWebImage


class FavoriteMovieCell: UICollectionViewCell {
    static var identifier = "FavoriteMovieCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    func configure(with movie: Movie) {
        if let imageUrl = movie.artworkUrl100, let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "place_holder"))
        } else {
            imageView.image = UIImage(named: "place_holder")
        }
        
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.red.cgColor
        let width: CGFloat = (imageView.frame.size.width)
        imageView.layer.cornerRadius = width / 2
        imageView.clipsToBounds = true // Ensures the image stays within the circle
        
        lblTitle.text = movie.trackName
    }
}
