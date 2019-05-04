//
//  TrailerTableViewCell.swift
//  TheReel
//
//  Created by ashley canty on 5/3/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit


protocol MovieTrailerDelegate: class {
    func presentMovieTrailer()
}

class TrailerTableViewCell: UITableViewCell {
    @IBOutlet weak var playTrailerButton: UIButton!
    weak var delegate: MovieTrailerDelegate?
    
    override func awakeFromNib() {
        playTrailerButton.clipsToBounds = true
        playTrailerButton.layer.cornerRadius = 8.0
    }

    @IBAction func playTrailerButtonDidTap() {
        delegate?.presentMovieTrailer()
    }
}
