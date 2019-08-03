//
//  Network.swift
//  TheReel
//
//  Created by ashley canty on 7/16/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

class Network {
    
    static func fetchMovieDetails(fetchWithID id: String, completion: @escaping((MovieDetails)->())) {
        let url = URL(string: "\(MovieDBQueries.getMovieDetailsBaseURL)\(id)\(MovieDBQueries.getEnglishVersionTailURL)")!
        (URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let movieDetails = try jsonDecoder.decode(MovieDetails.self, from: data)
                    completion(movieDetails)
                } catch {
                    print("Error in do-catch")
                    print(error.localizedDescription)
                }
            } else {
                print("No data")
                print(error?.localizedDescription)
            }
        }).resume()
    }
    
    static func fetchTrailerUrl(fetchWithID id: String, completion: @escaping((String)->())) {
        
        let url = URL(string: "\(MovieDBQueries.getMovieDetailsBaseURL)\(id)\(MovieDBQueries.movieTrailerTailURL)")!
        
        (URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                
                do {
                    let json = try jsonDecoder.decode(MovieTrailer.self, from: data)
                    let key = json.results?.first?.key
                    if let key = key {
                        completion(key)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        })).resume()
    }
    
    func fetchExtraDetails(withID id: Int, completion: @escaping(([Results])->())) {
        // use id to fetch extra details from url
        // parse for Runtime & Genre
        // append to Results object, return object in closure
        
        let stringID = id.returnStringDescription()
        Network.fetchMovieDetails(fetchWithID: stringID) { (movieDetails) in
            
        }
    }
    
    static func fetchTrendingMovies(completion: @escaping(([Results])->())) {
        let url = URL(string: MovieDBQueries.getPopularMovies)
        (URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let movies = try  jsonDecoder.decode(JSONData.self, from: data)
                    if let results = movies.results {
                        completion(results)
                        
                        
                        // get results obj
                        // grab id and pass to fetchExtraDetails
                        // edit copies of results object, pass list into closure
                        // pass final array in closure
                        // we have list of movies with details intact
                    }
                } catch {
                    print(err! as NSError)
                }
            } else {
                print(err?.localizedDescription)
            }
        }).resume()
    }
    
    static func fetchReleasedMovies(completion: @escaping(([Results])->())) {
        let url = URL(string: MovieDBQueries.getReleasedMovies)
        (URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let movies = try  jsonDecoder.decode(JSONData.self, from: data)
                    if let results = movies.results {
                        completion(results)
                    }
                } catch {
                    print(err! as NSError)
                }
            } else {
                print(err?.localizedDescription)
            }
        }).resume()
    }
    
    static func fetchUpcomingMovies(completion: @escaping(([Results])->())) {
        let url = URL(string: MovieDBQueries.getUpcomingMovies)
        (URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let movies = try  jsonDecoder.decode(JSONData.self, from: data)
                    if let results = movies.results {
                        completion(results)
                    }
                } catch {
                    print(err! as NSError)
                }
            } else {
                print(err?.localizedDescription)
            }
        }).resume()
    }
}
