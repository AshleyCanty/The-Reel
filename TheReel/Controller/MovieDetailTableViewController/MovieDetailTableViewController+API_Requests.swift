//
//  MovieDetailTableViewController+Handlers.swift
//  TheReel
//
//  Created by ashley canty on 5/4/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


// MARK: - MovieDB API Requests

// TODO: - Refactor by making re-usable code, add these network requests to the Network class, use closures

extension MovieDetailTableViewController {
    
    func updateTitle(with title: String) {
        self.navigationItem.title = title
        self.view.layoutIfNeeded()
    }
    
    func fetchMovieInformation() {
        guard let id = self.id else { return }
        
        Network.fetchMovieDetails(fetchWithID: id) { [weak self] movieDetails in
            guard let self = self else { return }
            
            if movieDetails.title != "" {
                DispatchQueue.main.async {
                    self.updateTitle(with: movieDetails.title ?? "")
                }
                self.posterPath = movieDetails.poster_path
                self.movie.title = movieDetails.title
                self.movie.releaseDate = movieDetails.release_date?.changeDateFormat()
                self.movie.voteCount = movieDetails.vote_count?.returnStringDescription()
                self.movie.runtime = movieDetails.runtime?.changeTimeFormat()
                self.movie.overview = movieDetails.overview
                self.downloadPosterImageData(movieDetails.backdrop_path ?? "", movieDetails.poster_path ?? "")

                if movieDetails.vote_average == nil {
                    self.voteAverage = "N/A"
                } else {
                    self.voteAverage = movieDetails.vote_average?.returnStringDescription() ?? ""
                }
            
                var genreString = ""
                var counter = 0
                var index = 0
                if let genres = movieDetails.genres {
                    var slicedArray = genres
                    if slicedArray.count > 2 {
                        slicedArray.removeSubrange(2..<genres.count)
                    }
                    for item in slicedArray {
                        guard let name = item.name else { return }
                        if index == (genres.count-1) || counter == 1 {
                            genreString += "\(name)"
                        } else {
                            genreString += "\(name) and "
                        }
                        counter += 1
                        index += 1
                    }
                    if genreString == "" {
                        genreString = "N/A"
                    }
                    self.movie.genres = genreString
                }
                
                self.movieAlreadySaved = self.checkCoreDataForExistingMovie(movieDetails.title ?? "", id)
                DispatchQueue.main.async {
                    self.spinnerView.removeFromSuperview()
                    self.tableView.reloadData()
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func fetchTrailerURL(){
        guard let id = self.id else { return }
        Network.fetchTrailerUrl(fetchWithID: id) { [weak self] (key) in
            guard let self = self else { return }
            self.trailerKey = key

            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
                self.tableView.reloadData()
            }
        }
    }
    
    func downloadPosterImageData(_ movieBackdropURL: String, _ moviePosterURL: String) {
        
        if let backdropURL = URL(string: "\(MovieDBQueries.movieImageBaseURL)\(movieBackdropURL)") {
            
            getData(from: backdropURL) { [weak self] data, response, error  in
                guard let data = data, error == nil else { return }
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let lowResData = UIImage(data: data)?.jpeg(.lowest) {
                        self.backdropImage = UIImage(data: lowResData)
                    } else {
                        self.backdropImage = UIImage(named: ImageNames.noImage.rawValue)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
        
        if moviePosterURL != "" {
            if let posterURL = URL(string: "\(MovieDBQueries.movieImageBaseURL)\(moviePosterURL)") {
                
                getData(from: posterURL) { [weak self] data, response, error  in
                    guard let data = data, error == nil else { return }
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        let lowResData = UIImage(data: data)?.jpeg(.lowest)
                        self.posterImage = UIImage(data: lowResData!)
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.posterImage = UIImage(named: "noImage")
                self.tableView.reloadData()
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

