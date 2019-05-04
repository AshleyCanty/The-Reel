//
//  MovieDetailViewController+Handlers.swift
//  TheReel
//
//  Created by ashley canty on 4/30/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit
import Alamofire

extension MovieDetailViewController {
    
    // MARK: - Retrieve Movie Information --- TrailerURL, PosterImageURL, Extra Details (runtime, votecount)
    
    
    func downloadPosterImageData() {
        guard let moviePosterURL = movie?.posterPath, let movieBackdropURL = movie?.backdropPath else {
            return
        }
        
        if let url = URL(string: "\(MovieDBQueries.movieImageBaseURL)\(movieBackdropURL)") {
            
            getData(from: url) { data, response, error  in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            }
        }
    }
        
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func fetchMovieDetails(movieID: String?) {
        guard let id = movieID else { return }
        let url = URL(string: "\(MovieDBQueries.getMovieDetailsBaseURL)\(id)\(MovieDBQueries.getEnglishVersionTailURL)")!
        
        Alamofire.request(url).responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, Any> {
                for (k,v) in dict {
                    if k == "runtime" {

                        if let runtime = v as? Int {
                            self.movie.runtime = runtime.changeTimeFormat()
                        }
                    }
                    if k == "vote_count" {
                        if let value = v as? Int {
                            self.movie.voteCount = String(value)
                        }
                    }
                    self.updateUI()
                }
            }
        }
    }
    
    // MARK: - Core Data Functions -- Save, Delete, Print & Check for existing
    
    func saveMovieToCoreData(_ title: String,_ id: String,_ imgData: Data) {
        let movie = SavedMovies(context: persistenceManager.context)
        movie.title = title
        movie.id = id
        movie.posterImage = imgData
        movie.posterPath = self.movie.posterPath
        movie.backdropPath = self.movie.backdropPath
        movie.releaseDate = self.movie.releaseDate
        movie.voteCount = self.movie.voteCount
        movie.voteAverage = self.movie.voteAverage ?? 0.0
        movie.genres = self.movie.genres
        movie.overview = self.movie.overview
        movie.saved = true
        
        persistenceManager.save()
        self.movieAlreadySaved = true
        self.saveToFavorites.setImage(UIImage(named: ImageNames.filledHeart.rawValue), for: .normal)
    }
    
    func deleteMovieFromCoreData(){
        let savedMovies = persistenceManager.fetch(SavedMovies.self)
        
        for currentMovie in savedMovies {
            if currentMovie.title == movie.title && currentMovie.id == movie.id {
                persistenceManager.delete(currentMovie)
                self.saveToFavorites.setImage(UIImage(named: ImageNames.emptyHeart.rawValue), for: .normal)
                movieAlreadySaved = false
                break
            }
        }
    }
    
    func getSavedMovies(){
        let savedMovies = persistenceManager.fetch(SavedMovies.self)
        self.savedMovies = savedMovies
        printSavedMovies()
        
    }
    
    func printSavedMovies() {
        savedMovies.forEach { (movie) in
            print(movie.title, movie.id)
        }
    }
    
    func checkCoreDataForExistingMovie(_ title: String, _ id: String) -> Bool {
        let savedMovies = persistenceManager.fetch(SavedMovies.self)
        
        for saved in savedMovies {
            if saved.title == movie.title && saved.id == movie.id {
                self.saveToFavorites.setImage(UIImage(named: ImageNames.filledHeart.rawValue), for: .normal)
                return true
            }
        }
        return false
    }
}
