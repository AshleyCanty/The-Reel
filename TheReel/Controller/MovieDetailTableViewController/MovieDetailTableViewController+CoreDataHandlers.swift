//
//  MovieDetailTableViewController+CoreDataHandlers.swift
//  TheReel
//
//  Created by ashley canty on 5/4/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: - Core Data Functions

extension MovieDetailTableViewController {
    
    func getSavedMovies(){
        let savedMovies = persistenceManager.fetch(SavedMovies.self)
        self.savedMovies = savedMovies
        printSavedMovies()
    }
    
    func printSavedMovies() {
        savedMovies.forEach { (movie) in
            print(movie.title ?? "", movie.id ?? "")
        }
    }
    
    func checkCoreDataForExistingMovie(_ title: String, _ id: String) -> Bool {
        let savedMovies = persistenceManager.fetch(SavedMovies.self)
        for saved in savedMovies {
            if saved.title == title && saved.id == id {
                return true
            }
        }
        return false
    }
    
    func saveMovieToCoreData(_ title: String,_ id: String,_ imgData: Data) {
        let newMovie = SavedMovies(context: persistenceManager.context)
        newMovie.title = title
        newMovie.id = id
        newMovie.posterImage = imgData
        newMovie.posterPath = posterPath
        newMovie.backdropPath = backdropPath
        newMovie.releaseDate = movie.releaseDate
        newMovie.voteCount = movie.voteCount
        newMovie.voteAverage = movie.voteAverage ?? 0.0
        newMovie.genres = movie.genres
        newMovie.overview = movie.overview
        newMovie.saved = true
        
        persistenceManager.save()
        self.movieAlreadySaved = true
        
        let cell = tableView.cellForRow(at: [0,1]) as! SaveAndShareTableViewCell
        cell.saveMovieButton.setImage(UIImage(named: ImageNames.filledHeart.rawValue), for: .normal)
    }
    
    func deleteMovieFromCoreData(){
        let savedMovies = persistenceManager.fetch(SavedMovies.self)
        let title = movie.title
        
        for currentMovie in savedMovies {
            
            if currentMovie.title == title && currentMovie.id == id {
                persistenceManager.delete(currentMovie)
                movieAlreadySaved = false
                
                let cell = tableView.cellForRow(at: [0,1]) as! SaveAndShareTableViewCell
                cell.saveMovieButton.setImage(UIImage(named: ImageNames.emptyHeart.rawValue), for: .normal)
                
                break
            }
        }
    }
}

extension String {
    func returnDoubleType()-> Double {
        if let double = Double(self) {
            return double
        }
        return 0.0
    }
}
