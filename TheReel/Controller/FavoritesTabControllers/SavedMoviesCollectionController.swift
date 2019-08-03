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
    let emptySavedMoviesNib = UINib.init(nibName: "EmptySavedMoviesCell", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(emptySavedMoviesNib, forCellWithReuseIdentifier: "EmptySavedMovies")
        savedMovies = persistenceManager.fetch(SavedMovies.self)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        savedMovies = persistenceManager.fetch(SavedMovies.self)
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if savedMovies.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptySavedMovies", for: indexPath) as! EmptySavedMoviesCell
                return cell
            
        } else {
        
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
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if savedMovies.count == 0 {
            return 1
        }
        return savedMovies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if savedMovies.count == 0 {
            return CGSize(width: collectionView.bounds.width, height: 55)
        }
        
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



