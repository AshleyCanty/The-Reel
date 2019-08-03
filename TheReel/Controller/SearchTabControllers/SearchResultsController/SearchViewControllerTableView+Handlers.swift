//
//  SearchViewControllerTableView+Handlers.swift
//  TheReel
//
//  Created by ashley canty on 4/30/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource

extension SearchResultsViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movies != nil {
            return movies!.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.SearchResultCell.rawValue, for: indexPath) as! MovieSearchResultCell
        cell.movie = movies?[indexPath.row]
        cell.delegate = self
        
        if let movie = movies?[indexPath.row] {
            cell.movieTitleLabel.text = movie.title
            cell.movieGenresLabel.text = movie.genreIDs?.description
            cell.moviePosterImage.downloadImageFromCacheUsingURL(imgPath: movie.posterPath, completionHandler: {(image) in
                if let updateCell = tableView.cellForRow(at: indexPath) as? MovieSearchResultCell {
                    updateCell.moviePosterImage.image = image
                }
            })
            cell.movieReleaseDateLabel.text = movie.releaseDate
            cell.movieGenresLabel.text = movie.genres
            cell.movieVoteAverage.text = movie.voteAverage?.returnStringDescription()
            cell.saveToFavorites.tag = indexPath.row
            
            if  checkCoreDataForExistingMovie(movie.title!, movie.id!) {
                cell.saveToFavorites.setImage(UIImage(named: ImageNames.filledHeart.rawValue), for: .normal)
            } else {
                cell.saveToFavorites.setImage(UIImage(named: ImageNames.emptyHeart.rawValue), for: .normal)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        
        SearchResultsViewController.savedMovieObject.title = movies![indexPath.row].title
        SearchResultsViewController.savedMovieObject.id = movies![indexPath.row].id
        SearchResultsViewController.savedMovieObject.saved = movies![indexPath.row].saved
        performSegue(withIdentifier: StoryBoardSegues.MovieDetailsScreen.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryBoardSegues.MovieDetailsScreen.rawValue {
            let vc = segue.destination as! MovieDetailTableViewController
            vc.id = SearchResultsViewController.savedMovieObject.id
        }
    }
}
