//
//  SavedMoviesCollectionController.swift
//  TheReel
//
//  Created by ashley canty on 5/2/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SavedMoviesCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let persistenceManager = PersistenceManager.shared
    var savedMovies: [SavedMovies] = [SavedMovies]()
    var indexPath: IndexPath?
    var selectedMovieID: String?
    
    private let sectionInsets = UIEdgeInsets(top: 15.0,
                                             left: 2.0,
                                             bottom: 15.0,
                                             right: 2.0)
    private let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedMovies = persistenceManager.fetch(SavedMovies.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        savedMovies = persistenceManager.fetch(SavedMovies.self)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.MovieCell.rawValue, for: indexPath) as? SavedMovieCollectionViewCell
        cell?.index = indexPath
        cell?.id = savedMovies[indexPath.row].id
        cell?.delegate = self
        
        if let data = savedMovies[indexPath.row].posterImage {
            let image = UIImage(data: data)
            cell?.cellImage.image = image
        }
        
        return cell!
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMovies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow )
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem*1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension SavedMoviesCollectionController: SavedMovieTableCellDelegate {
    
    func movieButtonDidTap(index: IndexPath, id: String) {
        selectedMovieID = id
        performSegue(withIdentifier: StoryBoardSegues.SavedMovieDetails.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == StoryBoardSegues.SavedMovieDetails.rawValue {
            if let vc = segue.destination as? MovieDetailTableViewController {
                vc.id = selectedMovieID
            }
        }
    }
    
    func deleteData(index: IndexPath) {
        persistenceManager.delete(savedMovies[index.row])
        savedMovies = persistenceManager.fetch(SavedMovies.self)
        collectionView.reloadData()
    }
}



