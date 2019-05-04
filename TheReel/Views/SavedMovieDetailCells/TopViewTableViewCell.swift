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
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backdropImage: UIImageView!
    
    override func awakeFromNib() {
        setupGradientView()
    }
    
    func setupGradientView() {
        let layer = CAGradientLayer()
        layer.frame = gradientView.bounds
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientView.backgroundColor = UIColor.clear
        gradientView.layer.addSublayer(layer)
    }
}


