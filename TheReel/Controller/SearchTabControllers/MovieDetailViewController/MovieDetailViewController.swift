//
//  MovieDetailViewController.swift
//  TheReel
//
//  Created by ashley canty on 4/25/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import AVKit
import WebKit
import youtube_ios_player_helper
import CoreData

class MovieDetailViewController: UIViewController {
   
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
    
    
    let persistenceManager: PersistenceManager = PersistenceManager.shared
    var savedMovies = [SavedMovies]()
    var movieAlreadySaved: Bool!
    
    let spinnerView = UIActivityIndicatorView(style: .gray)
    var trailersIDs: [String] = []
    var movieID: String?
    var posterImage: UIImage?
    var movie: Movie! {
        didSet {
            downloadPosterImageData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MovieDetailViewControllerrrrrrrrrrrr")
        guard let title = movie.title, let id = movie.id else { return }
        movieAlreadySaved = checkCoreDataForExistingMovie(title, id)

        setupGradientView()
        fetchMovieDetails(movieID: id)
        playTrailerButton.setupMovieTrailerURL(movie.id, trailersIDs)
        spinnerView.startAnimating()
        spinnerView.center = self.view.center
        
        playTrailerButton.clipsToBounds = true
        playTrailerButton.layer.cornerRadius = 8.0
        updateUI()
    }

    @IBAction func playTrailerButtonDidTap(){
        var id = ""
        if trailersIDs.count > 0 {
            id = trailersIDs[0]
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
    
    @IBAction func saveToFavoritesButtonDidTap(_ sender: Any) {
        if movieAlreadySaved {
            setMovieObject(false)
            deleteMovieFromCoreData()
            return
        }

        guard let title = movie?.title, let id = movie?.id, let posterImage = self.posterImage else { return }
        guard let imgData = posterImage.jpeg(.lowest) else { return }
        setMovieObject(true)
        saveMovieToCoreData(title, id, imgData)
    }
    
    @IBAction func shareButtonDidTap(_ sender: Any) {
      print("TAPPPED")
    }
    
    func setMovieObject(_ flag: Bool){
        SearchResultsViewController.savedMovieObject.title = movie?.title
        SearchResultsViewController.savedMovieObject.id = movie?.id
        SearchResultsViewController.savedMovieObject.saved = flag
    }
    
    func setupGradientView() {
        let layer = CAGradientLayer()
        layer.frame = gradientView.bounds
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientView.backgroundColor = UIColor.clear
        gradientView.layer.addSublayer(layer)
    }
    
    func updateUI() {
        guard let movie = self.movie else { return }
        
        moviePlotTextView.text = movie.overview
        if let title = movie.title, let releaseDate = movie.releaseDate, let genres = movie.genres, let runtime = movie.runtime {
            movieTitleLabel.text = title
            movieReleaseDataLabel.text = releaseDate
            movieGenreLabel.text = genres
            movieRuntimeLabel.text = runtime
            navigationItem.title = title
        }
        
        if let voteCount = movie.voteCount {
            movieVoteCount.text = voteCount
        }
        
        if movie.voteAverage == nil {
            movieAverageRating.text = "N/A"
        } else {
            movieAverageRating.text = "\(movie.voteAverage ?? 0)"
        }
    }

}
