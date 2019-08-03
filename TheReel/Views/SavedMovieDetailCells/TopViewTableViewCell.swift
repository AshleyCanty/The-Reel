//
//  TopViewTableViewCell.swift
//  TheReel
//
//  Created by ashley canty on 5/3/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit


class TopViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var genres: UILabel? {
        didSet {
            guard let genres = genres else { return }
            let genresHeight = genres.optimalHeight
            genres.frame = CGRect(x: genres.frame.origin.x, y: genres.frame.origin.y, width: genres.frame.width, height: genresHeight)
            self.layoutIfNeeded()
            print(genres.frame.height)
        }
    }
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    override func awakeFromNib() {
        posterImage.clipsToBounds = true
        posterImage.layer.cornerRadius = 8
        genres?.adjustsFontSizeToFitWidth = true
    }
}


