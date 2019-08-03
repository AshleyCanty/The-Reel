//
//  UpcomingCollectionView.swift
//  TheReel
//
//  Created by ashley canty on 7/11/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

class UpcomingCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var roundButtonWrap: UIView!
    @IBOutlet weak var shadowButtonWrap: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews() {
        imageView.addRoundedCorners()
        wrapView.addShadow()
        
        roundButtonWrap.clipsToBounds = true
        roundButtonWrap.layer.cornerRadius = playButton.bounds.width/2
        
        shadowButtonWrap.addShadow()
        shadowButtonWrap.layer.cornerRadius = playButton.bounds.width/2
        shadowButtonWrap.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowButtonWrap.layer.shadowOpacity = 0.65
        shadowButtonWrap.layer.shadowPath = UIBezierPath(roundedRect: roundButtonWrap.bounds, cornerRadius: playButton.bounds.width/2).cgPath
        
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 7
        blurView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
