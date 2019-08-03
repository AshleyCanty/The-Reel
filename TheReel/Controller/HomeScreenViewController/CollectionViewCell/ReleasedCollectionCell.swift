//
//  ReleasedCollectionView.swift
//  TheReel
//
//  Created by ashley canty on 7/11/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

class ReleasedCollectionCell: UICollectionViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        shadowView.addRoundedCorners()
        shadowView.backgroundColor = .orange
        shadowView.addRoundedCorners()
        shadowView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        imageView.addRoundedCorners()

    }
}
