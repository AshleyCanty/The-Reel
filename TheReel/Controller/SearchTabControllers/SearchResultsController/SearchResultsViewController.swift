//
//  SearchResultsViewController.swift
//  TheReel
//
//  Created by ashley canty on 4/28/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit
import Alamofire


class SearchResultsViewController: UITableViewController, MovieSearchResultCellDelegate {
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    static var savedMovieIndex: IndexPath = [0,0]
    static var savedMovieObject: Movie = Movie()
    static var selectedMovieIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    
    let persistenceManager = PersistenceManager.shared
    let spinnerView = UIActivityIndicatorView(style: .gray)
    var savedMovies: [SavedMovies] = [SavedMovies]()
    var searchLabel: String?
    var selectedIndexPath: IndexPath?
    var movieGenres: [MovieGenres]?
    var movies: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMovies()
        fetchGenres()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateMovieListWithSaved()
    }
    
    func setupUI() {
        tableView.separatorStyle = .none
        spinnerView.startAnimating()
        spinnerView.center = tableView.center
        self.view.addSubview(spinnerView)
        navigationItem.title = "\"\(searchLabel!)\""
    }
    
    func noResultsFound() {
        let alert = UIAlertController(title: AlertMessages.NoResults.rawValue, message: AlertMessages.NoResultsMessage.rawValue, preferredStyle: .alert)
        let action = UIAlertAction(title: AlertMessages.GoBack.rawValue, style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateMovieListWithSaved(){
        let title = SearchResultsViewController.savedMovieObject.title
        let id = SearchResultsViewController.savedMovieObject.id
        let saved = SearchResultsViewController.savedMovieObject.saved
        
        guard let list = movies else { return }
        for x in 0...list.count-1 {
            if movies![x].title == title && movies![x].id == id {
                movies![x].saved = saved
            }
        }
        tableView.reloadData()
    }

    func saveMovieToFavoritesDidTap(_ sender: MovieSearchResultCell) {
        let indexPath = tableView.indexPath(for: sender)
        SearchResultsViewController.savedMovieIndex = indexPath!
        
        if let cell = tableView.cellForRow(at: indexPath!) as? MovieSearchResultCell {
            guard let saved = cell.movie?.saved else { return }
            
            if saved {
                cell.saveToFavorites.setImage(UIImage(named: ImageNames.emptyHeart.rawValue), for: .normal)
                cell.movie?.saved = false
                movies?[(indexPath?.row)!].saved = false
                deleteMovieFromCoreData()
                return
            }
            
            guard let title = cell.movie?.title, let id = cell.movie?.id, let img = cell.moviePosterImage.image else { return }
            let imgData = img.jpeg(.lowest)
            
            SearchResultsViewController.savedMovieObject.title = title
            SearchResultsViewController.savedMovieObject.id = id
            SearchResultsViewController.savedMovieObject.index = indexPath?.row ?? 0
            saveMovieToCoreData(title, id, imgData!)
            
            cell.saveToFavorites.setImage(UIImage(named: ImageNames.filledHeart.rawValue), for: .normal)
            cell.movie?.saved = true
            movies?[(indexPath?.row)!].saved = true
        }
    }
}


