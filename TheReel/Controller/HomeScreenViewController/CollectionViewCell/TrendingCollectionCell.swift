//
//  CollectionViewCell.swift
//  TheReel
//
//  Created by ashley canty on 7/13/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

class TrendingCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var wrapView: UIView!
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.addRoundedCorners()
        wrapView.addShadow()
        wrapView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 8).cgPath
        
        gradientView.setGradientBackground(colorTop: UIColor.clear, colorBottom: UIColor.black)
        gradientView.clipsToBounds = true
        gradientView.layer.cornerRadius = 7
        gradientView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
