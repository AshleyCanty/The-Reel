//
//  SaveAndShareTableViewCell.swift
//  TheReel
//
//  Created by ashley canty on 5/3/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit


protocol SaveAndShareDelegate: class {
    func saveMovieToFavorites()
    func shareMovie()
}

class SaveAndShareTableViewCell: UITableViewCell {
    
    @IBOutlet weak var saveMovieButton: UIButton!
    @IBOutlet weak var shareMovieButton: UIButton!
    
    weak var delegate: SaveAndShareDelegate?

    @IBAction func saveMovieButtonDidTap() {
        delegate?.saveMovieToFavorites()
    }
    
    @IBAction func shareMovieDidTap() {
        delegate?.shareMovie()
    }
}
