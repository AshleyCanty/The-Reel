//
//  MovieSearchResultCell.swift
//  TheReel
//
//  Created by ashley canty on 4/28/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit


protocol MovieSearchResultCellDelegate: class {
    func saveMovieToFavoritesDidTap(_ sender: MovieSearchResultCell)
}

class MovieSearchResultCell: UITableViewCell {
   
    @IBOutlet weak var saveToFavorites: UIButton!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieVoteAverage: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    
    weak var delegate: MovieSearchResultCellDelegate?
    var movie: Movie?
    
    override func awakeFromNib() {
        moviePosterImage.layer.cornerRadius = 8
        moviePosterImage.layer.masksToBounds = true
        moviePosterImage.contentMode = .scaleAspectFill
    }
    
    @IBAction func saveToFavoritesDidTap(){
        delegate?.saveMovieToFavoritesDidTap(self)
    }
}
