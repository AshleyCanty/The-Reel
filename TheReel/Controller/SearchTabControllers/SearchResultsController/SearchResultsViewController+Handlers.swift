//
//  SearchResultsViewController+Handlers.swift
//  TheReel
//
//  Created by ashley canty on 4/30/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import Alamofire

extension SearchResultsViewController {
    
    // MARK: - Retrieve Movies and Details
    
    func fetchMovies() {
        let title = searchLabel!.replacingOccurrences(of: " ", with: "+")
        var list: [Movie] = [Movie]()
        
        Alamofire.request("\(MovieDBQueries.discoverMoviesByKeyword)\(title)").responseJSON { (response) in
            guard let dict = response.result.value as? Dictionary<String, Any> else { return }
            
            let totalResults = dict[MovieDBKeys.TotalResults.rawValue] as? Int
            if totalResults == 0 {
                self.noResultsFound()
                DispatchQueue.main.async {
                    self.spinnerView.removeFromSuperview()
                }
            }
            
            for (k, arrayOfValues) in dict where k == MovieDBKeys.Results.rawValue {
                for item in arrayOfValues as? [Any] ?? [] {
                    guard let movieDictionary = item as? [String: Any] else { return }
                    
                    var movie = Movie()
                    guard let newID = movieDictionary[MovieDBKeys.ID.rawValue] as? Int else { return }
                    
                    movie.id = newID.returnStringDescription()
                    movie.title = movieDictionary[MovieDBKeys.Title.rawValue] as? String
                    movie.releaseDate = movieDictionary[MovieDBKeys.ReleaseDate.rawValue] as? String
                    movie.voteAverage = movieDictionary[MovieDBKeys.VoteAverage.rawValue] as? Double
                    movie.overview = movieDictionary[MovieDBKeys.Overview.rawValue] as? String
                    movie.posterPath = movieDictionary[MovieDBKeys.PosterURL.rawValue] as? String
                    movie.backdropPath = movieDictionary[MovieDBKeys.Backdrop.rawValue] as? String
                    movie.genreIDs = movieDictionary[MovieDBKeys.GenreIDs.rawValue] as? [Int]

                    guard let releaseDate = movie.releaseDate else { return }
                    guard let genreIDs = movie.genreIDs else { return }
                    movie.releaseDate = releaseDate.changeDateFormat()
                    movie.genres = self.filterGenreNames(movieGenreIDs: genreIDs)
                    movie.saved = self.checkCoreDataForExistingMovie(movie.title ?? "", movie.id ?? "")
                    
                    list.append(movie)
                    self.movies = list
                }
            }
            
            DispatchQueue.main.async {
                self.spinnerView.removeFromSuperview()
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Retrieve Genres from Database
    
    func fetchGenres() {
        var list = [MovieGenres]()
        
        Alamofire.request(MovieDBQueries.movieGenresURL).responseJSON { (response) in
            guard let dict = response.result.value as? Dictionary<String, Any> else { return }
            
            for value in dict {
                guard let objects = value.value as? [Any] else { return }
                
                for obj in objects {
                    guard let newObj = obj as? [String: Any] else { return }
                    guard let id = newObj[MovieDBKeys.ID.rawValue] as? Int, let name = newObj[MovieDBKeys.Name.rawValue] as? String else { return }
                    
                    var genreObject = MovieGenres()
                    genreObject.id = id
                    genreObject.name = name
                    list.append(genreObject)
                    self.movieGenres = list
                }
            }
        }
    }
    
    // MARK: - Filter Genre IDs for Name
    
    func filterGenreNames(movieGenreIDs: [Int]) -> String {
        var genreNames = ""
        var counter = 0
        var index = 0
        
        guard let databaseGenreList = movieGenres else { return " " }
        for id in movieGenreIDs {
            for genre in databaseGenreList {
                print(databaseGenreList)
                if genre.id == id {
                    guard let name = genre.name else { return " "}
                    
                    if index == movieGenreIDs.count-1 || counter == 1 {
                        genreNames += "\(name)"
                        return genreNames
                    } else {
                        genreNames += "\(name) and "
                    }
                    
                    counter += 1
                }
            }
            index += 1
        }
        if genreNames == "" {
            genreNames = "N/A"
        }
        return genreNames
    }
    
    // MARK: - Core Data Functions
    
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
        let movie = SavedMovies(context: persistenceManager.context)
        movie.title = title
        movie.id = id
        movie.posterImage = imgData
        
        let indexPath = SearchResultsViewController.savedMovieIndex
        if let cell = tableView.cellForRow(at: indexPath) as? MovieSearchResultCell {
            cell.movie?.saved = true
            movie.posterPath = cell.movie?.posterPath
            movie.backdropPath = cell.movie?.backdropPath
            movie.releaseDate = cell.movie?.releaseDate
            movie.voteCount = cell.movie?.voteCount
            movie.voteAverage = cell.movie?.voteAverage ?? 0.0
            movie.genres = cell.movie?.genres
            movie.saved = true
        }
        persistenceManager.save()
        
        let deadline = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.getSavedMovies()
        }
    }
    
    func deleteMovieFromCoreData(){
        let savedMovies = persistenceManager.fetch(SavedMovies.self)
        let indexPath = SearchResultsViewController.savedMovieIndex
        if let cell = tableView.cellForRow(at: indexPath) as? MovieSearchResultCell {
            
            for currentMovie in savedMovies {
                if currentMovie.title == cell.movie?.title && currentMovie.id == cell.movie?.id {
                    persistenceManager.delete(currentMovie)
                    cell.saveToFavorites.setImage(UIImage(named: ImageNames.emptyHeart.rawValue), for: .normal)
                    cell.movie?.saved = false
                    break
                }
            }
        }
        
        let deadline = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.getSavedMovies()
        }
    }
    
    func getSavedMovies(){
        let savedMovies = persistenceManager.fetch(SavedMovies.self)
        self.savedMovies = savedMovies
        printSavedMovies()
        
    }
    
    func printSavedMovies() {
        savedMovies.forEach { (movie) in
            print(movie.title!, movie.id!)
        }
    }
}
