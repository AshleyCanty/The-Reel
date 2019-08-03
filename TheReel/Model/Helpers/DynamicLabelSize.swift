//
//  DynamicLabelSize.swift
//  TheReel
//
//  Created by ashley canty on 7/23/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

class DynamicLabelSize {
    
    static func height(text: String?, font: UIFont, width: CGFloat) -> CGFloat {
        
        var currentHeight: CGFloat!
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        currentHeight = label.frame.height
        label.removeFromSuperview()
        
        return currentHeight
    }
    
}
