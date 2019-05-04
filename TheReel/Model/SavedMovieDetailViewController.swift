//
//  SavedMovieDetailViewController.swift
//  TheReel
//
//  Created by ashley canty on 5/2/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreData

class SavedMovieDetailViewController: UIViewController {
    
    @IBOutlet weak var saveToFavorites: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseDataLabel: UILabel!
    @IBOutlet weak var movieAverageRating: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieVoteCount: UILabel!
    @IBOutlet weak var moviePlotTextView: UITextView!
    @IBOutlet weak var movieRuntimeLabel: UILabel!
    @IBOutlet weak var playTrailerButton: UIButton!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    var trailersIDs: [String] = []
    
    let persistenceManager: PersistenceManager = PersistenceManager.shared
    let spinnerView = UIActivityIndicatorView(style: .gray)
    var savedMovies = [SavedMovies]()
    var movieAlreadySaved: Bool!
    var movieID: String?
    var posterImage: UIImage?
    var posterPath: String?
    var backdropPath: String?
    var id: String?
    
    override func viewDidLoad() {
        fetchMovieInformation()
        setupGradientView()
        spinnerView.startAnimating()
        spinnerView.center = self.view.center
        fetchTrailerURL()
        playTrailerButton.clipsToBounds = true
        playTrailerButton.layer.cornerRadius = 8.0
        resizeForSmallerDevice()
    }
    
    func resizeForSmallerDevice() {
        let screenType = UIDevice.current.screenType
        
        if screenType == .iPhones_5_5s_5c_SE {
            print("SMALLLL SCREEEN")
        }
        
    }
    
    @IBAction func saveToFavoritesButtonDidTap(_ sender: Any) {
        if movieAlreadySaved {
            deleteMovieFromCoreData()
            return
        }
        
        guard let title = movieTitleLabel.text, let id = id, let posterImage = self.posterImage else { return }
        guard let imgData = posterImage.jpeg(.lowest) else { return }
        saveMovieToCoreData(title, id, imgData)
    }
    
    //  Hey, you should check out this movie!
    
    // Title:
    // Released:
    // Youtube link
    // PosterImage (if no youtube trailer availiable)
    
    
    @IBAction func shareButtonDidTap(_ sender: Any) {
        
        print("Tapped Button")
        guard let title = movieTitleLabel.text else { return }
        let argA = "Hey you should check out this movie!"
        let argB = title
        let argC = posterImage
        
        let array = [argA, argB, argC] as [Any]
        let activityVC = UIActivityViewController(activityItems:array, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    @IBAction func playTrailerButtonDidTap(){
        var id = ""
        print(self.trailersIDs)
        if self.trailersIDs.count > 0 {
            id = self.trailersIDs[0]
        } else {
            print("No trailers available");
            return
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieTrailerViewController") as! MovieTrailerViewController
        vc.videoID = id
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true, completion: nil)
    }
    
    func setupGradientView() {
        let layer = CAGradientLayer()
        layer.frame = gradientView.bounds
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientView.backgroundColor = UIColor.clear
        gradientView.layer.addSublayer(layer)
    }
    
    func fetchMovieInformation() {
        guard let id = self.id else { return }
        
        let url = URL(string: "\(MovieDBQueries.getMovieDetailsBaseURL)\(id)\(MovieDBQueries.getEnglishVersionTailURL)")!
        
        Alamofire.request(url).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, Any> {
                let title = dict["title"] as? String
                let date = dict["release_date"] as? String
                let vcount = dict["vote_count"] as? Int
                let vAverage = dict["vote_average"] as? Double
                let time = dict["runtime"] as? Int
                let overview = dict["overview"] as? String
                let genres = dict["genres"] as? [Any]
                let posterURL = dict["poster_path"] as? String
                let backdropURL = dict["backdrop_path"] as? String
                
                self.posterPath = posterURL
                self.movieTitleLabel.text = title
                self.movieReleaseDataLabel.text = date?.changeDateFormat()
                self.movieVoteCount.text = vcount?.returnStringDescription()
                self.movieRuntimeLabel.text = time?.changeTimeFormat()
                self.moviePlotTextView.text = overview
                self.downloadPosterImageData(backdropURL ?? "", posterURL ?? "")

                if vAverage == nil {
                    self.movieAverageRating.text = "N/A"
                } else {
                    self.movieAverageRating.text = vAverage?.returnStringDescription()
                }
                
                if let genres = genres {
                    var genreString = ""
                    for item in genres {
                        if let item = item as? [String: Any] {
                            guard let name = item["name"] as? String else { return }
                            genreString += "\(name) "
                        }
                    }
                    
                    self.movieGenreLabel.text = genreString
                }
                
                self.movieAlreadySaved = self.checkCoreDataForExistingMovie(title ?? "", id)
                
                self.spinnerView.removeFromSuperview()
            }
        }
    }


    // MARK: Network Requests
    
    func fetchTrailerURL(){
        Alamofire.request("\(MovieDBQueries.getMovieDetailsBaseURL)\(id ?? "")\(MovieDBQueries.movieTrailerTailURL)").responseJSON { (response) in

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
                                    self.trailersIDs.append(key)
                                }
                            }
                        }
                    }
                }
            }
            
            self.view.layoutIfNeeded()
            if self.trailersIDs .count == 0 {
                self.playTrailerButton.setTitle("No Trailer Available", for: .normal)
                self.playTrailerButton.isEnabled = false
            }
        }
    }
    
    func downloadPosterImageData(_ movieBackdropURL: String, _ moviePosterURL: String) {

        if let backdropURL = URL(string: "\(MovieDBQueries.movieImageBaseURL)\(movieBackdropURL)") {
            
            getData(from: backdropURL) { data, response, error  in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            }
        }
        
        if let posterURL = URL(string: "\(MovieDBQueries.movieImageBaseURL)\(moviePosterURL)") {
            
            getData(from: posterURL) { data, response, error  in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.posterImage = UIImage(data: data)
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // MARK: Core Data Functions
    
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
            if saved.title == title && saved.id == id {
                self.saveToFavorites.setImage(UIImage(named: "heart"), for: .normal)
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
        movie.posterPath = posterPath
        movie.backdropPath = backdropPath
        movie.releaseDate = movieReleaseDataLabel.text
        movie.voteCount = movieVoteCount.text
        movie.voteAverage = (movieAverageRating.text?.returnDoubleType())!
        movie.genres = movieGenreLabel.text
        movie.overview = moviePlotTextView.text
        movie.saved = true
        
        persistenceManager.save()
        self.movieAlreadySaved = true
        self.saveToFavorites.setImage(UIImage(named: "heart"), for: .normal)
    }
    
    func deleteMovieFromCoreData(){
        let savedMovies = persistenceManager.fetch(SavedMovies.self)
        let title = movieTitleLabel.text
        for currentMovie in savedMovies {
            if currentMovie.title == title && currentMovie.id == id {
                persistenceManager.delete(currentMovie)
                self.saveToFavorites.setImage(UIImage(named: "emptyHeart"), for: .normal)
                movieAlreadySaved = false
                
                break
            }
        }
    }
}

