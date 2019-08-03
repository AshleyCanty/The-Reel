//
//  TrailerTableViewCell.swift
//  TheReel
//
//  Created by ashley canty on 5/3/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit
class TrailerTableViewCell: UITableViewCell {
    @IBOutlet weak var playTrailerButton: UIButton!
    
    override func awakeFromNib() {
        playTrailerButton.clipsToBounds = true
        playTrailerButton.layer.cornerRadius = 8.0
    }

    @IBAction func playTrailerButtonDidTap() {
    }
}
