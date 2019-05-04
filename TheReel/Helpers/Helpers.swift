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
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
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
