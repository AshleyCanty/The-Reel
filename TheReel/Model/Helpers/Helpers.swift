//
//  Helpers.swift
//  TheReel
//
//  Created by ashley canty on 5/1/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


// MARK: - Retrieve Poster Images and Store in Cache

extension UIImageView {
    typealias ImageCacheLoaderCompletionHandler = ((UIImage) -> ())
    
    func downloadImageFromCacheUsingURL(imgPath: String?, completionHandler: @escaping ImageCacheLoaderCompletionHandler) {
        
        guard let path = imgPath else {
            self.image = UIImage(named: ImageNames.noImage.rawValue)
            return
        }
        
        if path == "" {
            self.image = UIImage(named: ImageNames.noImage.rawValue)
            return
        }
        
        guard let url = URL(string: "\(MovieDBQueries.movieImageBaseURL)\(path)") else {
            self.image = UIImage(named: ImageNames.noImage.rawValue)
            return
        }
        
        guard let imageFromCache = HomeScreenViewController.imageCache.object(forKey: url as AnyObject) else {
            do {
                
                Alamofire.request(url).response { (response) in
                    if let data = response.data {
                        guard let lowResData = UIImage(data: data)?.jpeg(.lowest) else { return }
                        guard let lowResImage = UIImage(data: lowResData) else { return }
                        HomeScreenViewController.imageCache.setObject(lowResImage, forKey: url as AnyObject)
                        self.image = lowResImage
                        DispatchQueue.main.async {
                            completionHandler(lowResImage)
                        }
                    }
                }
            }
            return
        }
        
        let cachedImage = imageFromCache as! UIImage
        self.image = cachedImage
        DispatchQueue.main.async {
            completionHandler(cachedImage)
        }
    }
}

extension UILabel {
    var optimalHeight : CGFloat {
        get
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = self.font
            label.text = self.text
            label.sizeToFit()
            return label.frame.height
        }
        
    }
}

extension UIView {
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addShadow() {
        clipsToBounds = false
        layer.opacity = 1
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: -1, height: 0)
        layer.shadowOpacity = 0.4
        layer.cornerRadius = 10
    }
    
    func addRoundedCorners() {
        self.clipsToBounds = true
        layer.cornerRadius = 8
    }
}

extension UIButton {
    func setupMovieTrailerURL(_ id: String?,_ trailerIDs: [String]) {
        guard let id = id else { return }
        var trailerIDs = trailerIDs
        Alamofire.request("\(MovieDBQueries.getMovieDetailsBaseURL)\(id)\(MovieDBQueries.movieTrailerTailURL)").responseJSON { (response) in

            guard let dict = response.result.value as? Dictionary<String, Any> else { return }
            for (k,v) in dict where k == "results" {
                guard let arrayOfValues = v as? [Any] else { return }
                for item in arrayOfValues {
                    guard let dictionary = item as? [String: Any] else { return }
                    for (k,v) in dictionary {
                        
                        if k == "type" {
                            if let value = v as? String {
                                if value == "Trailer" {
                                    guard let key = dictionary["key"] as? String else { return }
                                    trailerIDs.append(key)
                                }
                            }
                        }
                    }
                }
            }
            if trailerIDs.count == 0 {
                self.setTitle("No Trailer Available", for: .normal)
                self.isEnabled = false
                print("No trailers available");
            }
        }
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension Double {
    func returnStringDescription() -> String {
        var string = ""
        string = String(self)
        return string
    }
}
extension Int {
    func changeTimeFormat() -> String {
        var totalMinutes = self
        var hours = 0
                
        while totalMinutes > 60 {
            totalMinutes -= 60
            hours += 1
        }
        
        return "\(hours)h \(totalMinutes)m"
    }
    
    func returnStringDescription() -> String {
        var string = ""
        string = String(self)
        return string
    }
}

extension String {
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyy-MM-dd"
        
        let originalDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        return dateFormatter.string(from: originalDate ?? Date())
    }
}
