//
//  MovieDetailTableView+Handlers.swift
//  TheReel
//
//  Created by ashley canty on 5/4/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Delegates: Save and Share, Movie Trailer

extension MovieDetailTableViewController: MovieActionsDelegate {
    
    func saveMovieToFavorites() {
        guard let title = movie.title, let id = self.id else { return }
        if checkCoreDataForExistingMovie(title, id) {
            deleteMovieFromCoreData()
            return
        }
        if let data = posterImage?.jpeg(.lowest) {
            saveMovieToCoreData(title, id, data)
        }
    }
    
    func shareMovie() {
        guard let title = movie.title else { return }
        let runtime = movie.runtime ?? "N/A"
        let releaseDate = movie.releaseDate ?? "N/A"
        
        let argA = ShareMessage.Message.rawValue
        let argB = "Title: \(title)"
        let argC = "Release Date: \(releaseDate)"
        let argD = "Runtime: \(runtime)"
        let argE = posterImage as Any
        
        let array = [argA, argB, argC, argD, argE] as [Any]
        let activityVC = UIActivityViewController(activityItems:array, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func presentMovieTrailer() {
        guard let id = self.trailerKey else {
            print("No trailers available");
            return
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifiers.MovieTrailerVC.rawValue) as! MovieTrailerViewController
        vc.videoID = id
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true, completion: nil)
    }
}
