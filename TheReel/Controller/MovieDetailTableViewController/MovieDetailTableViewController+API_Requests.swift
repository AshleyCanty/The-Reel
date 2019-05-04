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

extension MovieDetailTableViewController {
    
    func fetchMovieInformation() {
        
        guard let id = self.id else { return }
        let url = URL(string: "\(MovieDBQueries.getMovieDetailsBaseURL)\(id)\(MovieDBQueries.getEnglishVersionTailURL)")!
        
        Alamofire.request(url).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, Any> {
                let title = dict[MovieDBKeys.Title.rawValue] as? String
                let date = dict[MovieDBKeys.ReleaseDate.rawValue] as? String
                let vcount = dict[MovieDBKeys.VoteCount.rawValue] as? Int
                let vAverage = dict[MovieDBKeys.VoteAverage.rawValue] as? Double
                let time = dict[MovieDBKeys.Runtime.rawValue] as? Int
                let overview = dict[MovieDBKeys.Overview.rawValue] as? String
                let genres = dict[MovieDBKeys.Genres.rawValue] as? [Any]
                let posterURL = dict[MovieDBKeys.PosterURL.rawValue] as? String
                let backdropURL = dict[MovieDBKeys.Backdrop.rawValue] as? String
                
                self.posterPath = posterURL
                self.movie.title = title
                self.movie.releaseDate = date?.changeDateFormat()
                self.movie.voteCount = vcount?.returnStringDescription()
                self.movie.runtime = time?.changeTimeFormat()
                self.movie.overview = overview
                self.downloadPosterImageData(backdropURL ?? "", posterURL ?? "")
                
                if vAverage == nil {
                    self.voteAverage = "N/A"
                } else {
                    self.voteAverage = vAverage?.returnStringDescription() ?? ""
                }
                
                if let genres = genres {
                    var genreString = ""
                    var counter = 0
                    var index = 0
                    for item in genres {
                        if let item = item as? [String: Any] {
                            guard let name = item[MovieDBKeys.Name.rawValue] as? String else { return }
                            if index == (genres.count-1) || counter == 2 {
                                genreString += "\(name)"
                            } else {
                                genreString += "\(name), "
                            }
                            counter += 1
                        }
                        index += 1
                    }
                    self.movie.genres = genreString
                }
                
                self.movieAlreadySaved = self.checkCoreDataForExistingMovie(title ?? "", id)
                self.spinnerView.removeFromSuperview()
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchTrailerURL(){
        
        Alamofire.request("\(MovieDBQueries.getMovieDetailsBaseURL)\(id ?? "")\(MovieDBQueries.movieTrailerTailURL)").responseJSON { (response) in
            guard let dict = response.result.value as? Dictionary<String, Any> else { return }
            
            for (k,v) in dict where k == MovieDBKeys.Results.rawValue {
                guard let arrayOfValues = v as? [Any] else { return }
                
                for item in arrayOfValues {
                    guard let dictionary = item as? [String: Any] else { return }
                    
                    for (k,v) in dictionary {
                        if k == MovieDBKeys.TypeKey.rawValue {
                            
                            if let value = v as? String {
                                if value == MovieDBKeys.Trailer.rawValue {
                                    
                                    guard let key = dictionary[MovieDBKeys.Key.rawValue] as? String else { return }
                                    self.trailersIDs.append(key)
                                }
                            }
                        }
                    }
                }
            }
            self.view.layoutIfNeeded()
            self.tableView.reloadData()
        }
    }
    
    func downloadPosterImageData(_ movieBackdropURL: String, _ moviePosterURL: String) {
        
        if let backdropURL = URL(string: "\(MovieDBQueries.movieImageBaseURL)\(movieBackdropURL)") {
            
            getData(from: backdropURL) { data, response, error  in
                guard let data = data, error == nil else { return }
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
        
        if let posterURL = URL(string: "\(MovieDBQueries.movieImageBaseURL)\(moviePosterURL)") {
            
            getData(from: posterURL) { data, response, error  in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let lowResData = UIImage(data: data)?.jpeg(.lowest)
                    self.posterImage = UIImage(data: lowResData!)
                    self.tableView.reloadData()
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

