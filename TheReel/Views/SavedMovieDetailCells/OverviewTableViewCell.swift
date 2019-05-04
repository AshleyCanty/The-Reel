//
//  OverviewTableViewCell.swift
//  TheReel
//
//  Created by ashley canty on 5/3/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit


class OverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var overview: UITextView!
    
    override func awakeFromNib() {
        var frame = overview.frame
        frame.size = overview.contentSize
        overview.frame = frame
    }
}
