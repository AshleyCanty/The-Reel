//
//  TestingTable.swift
//  TheReel
//
//  Created by ashley canty on 5/2/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreData


class MovieDetailTableViewController: UITableViewController {
    
    let persistenceManager: PersistenceManager = PersistenceManager.shared
    let spinnerView = UIActivityIndicatorView(style: .gray)
    var savedMovies = [SavedMovies]()
    var movieAlreadySaved: Bool!
    var movie: Movie = Movie()
    var movieID: String?
    var posterImage: UIImage?
    var posterPath: String?
    var backdropImage: UIImage?
    var backdropPath: String?
    var trailersIDs: [String] = []
    var voteAverage = ""
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerView.startAnimating()
        spinnerView.center = self.view.center
        view.addSubview(spinnerView)
        fetchMovieInformation()
        fetchTrailerURL()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.TopViewCell.rawValue, for: indexPath) as! TopViewTableViewCell
            cell.backdropImage.image = backdropImage
            print(movie.title, backdropImage)
            cell.title.text = movie.title
            cell.rating.text = self.voteAverage
            cell.genres.text = movie.genres
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.SaveAndShareCell.rawValue, for: indexPath) as! SaveAndShareTableViewCell
            cell.delegate = self
            
            if let title = movie.title, let id = self.id {
                if checkCoreDataForExistingMovie(title, id) {
                    cell.saveMovieButton.setImage(UIImage(named: ImageNames.filledHeart.rawValue), for: .normal)
                } else {
                    cell.saveMovieButton.setImage(UIImage(named: ImageNames.emptyHeart.rawValue), for: .normal)
                }
            }
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.ExtraDetailsCell.rawValue, for: indexPath) as! ExtraDetailsTableViewCell
            cell.runtime.text = movie.runtime
            cell.releaseDate.text = movie.releaseDate
            cell.voteCount.text = movie.voteCount
            
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.Overview.rawValue, for: indexPath) as! OverviewTableViewCell
            if let overview = movie.overview {
                if overview == "" || overview.count < 1 {
                    cell.overview.text = LabelTexts.noPlot.rawValue
                } else {
                    cell.overview.text = overview
                }
            }
            
            return cell
            
        } else if indexPath.row == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.TrailerCell.rawValue, for: indexPath) as! TrailerTableViewCell
            cell.delegate = self
            
            if self.trailersIDs.count == 0 {
                cell.playTrailerButton.setTitle(TrailerButton.NoTrailer.rawValue, for: .normal)
                cell.playTrailerButton.isEnabled = false
            } else {
                cell.playTrailerButton.setTitle(TrailerButton.PlayTrailer.rawValue, for: .normal)
                cell.playTrailerButton.isEnabled = true 
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.TopViewCell.rawValue, for: indexPath) as! TopViewTableViewCell
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 250
        } else if indexPath.row == 1 {
            return 46
        } else if indexPath.row == 2 {
            return 110
        } else if indexPath.row == 3 {
            return 200
        } else {
            return 110
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else if indexPath.row == 1 {
            return 46
        } else if indexPath.row == 2 {
            return 110
        } else if indexPath.row == 3 {
            return 200
        } else {
            return 110
        }
    }
}


