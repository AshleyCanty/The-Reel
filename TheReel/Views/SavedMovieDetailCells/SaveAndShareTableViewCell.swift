//
//  SaveAndShareTableViewCell.swift
//  TheReel
//
//  Created by ashley canty on 5/3/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit


protocol MovieActionsDelegate: class {
    func saveMovieToFavorites()
    func presentMovieTrailer()
    func shareMovie()
}


class SaveAndShareTableViewCell: UITableViewCell {
    
    @IBOutlet weak var saveMovieButton: UIButton!
    @IBOutlet weak var shareMovieButton: UIButton!
    @IBOutlet weak var playTrailerButton: UIButton!
    
    weak var delegate: MovieActionsDelegate?
    
    override func awakeFromNib() {
        playTrailerButton.clipsToBounds = true
        playTrailerButton.layer.cornerRadius = 8.0
    }

    @IBAction func saveMovieButtonDidTap() {
        delegate?.saveMovieToFavorites()
    }
    
    @IBAction func playTrailerButtonDidTap() {
        delegate?.presentMovieTrailer()
    }
    
    @IBAction func shareMovieDidTap() {
        delegate?.shareMovie()
    }
}
