//
//  SavedMovieTableViewCell.swift
//  TheReel
//
//  Created by ashley canty on 5/2/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol SavedMovieTableCellDelegate: class {
    func deleteData(index: IndexPath)
    func movieButtonDidTap(index: IndexPath, id: String)
}

class SavedMovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var deleteMovieButton: UIButton!
    
    weak var delegate: SavedMovieTableCellDelegate?
    
    let persistenceManager = PersistenceManager.shared
    var savedMovies: [SavedMovies] = [SavedMovies]()
    var index: IndexPath?
    var id: String?
    

    override func awakeFromNib() {
        cellImage.layer.cornerRadius = 8.0
        cellImage.contentMode = .scaleAspectFill
        cellImage.layer.masksToBounds = true
    }
    
    @IBAction func imageButtonDidTap(_ sender: Any) {
        if let index = index, let id = id {
            delegate?.movieButtonDidTap(index: index, id: id)
        }
    }
    
    @IBAction func deleteMovieButtonDidTap(_ sender: Any) {
        delegate?.deleteData(index: index!)
    }
}
