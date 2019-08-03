//
//  HomeScreenTableCell.swift
//  TheReel
//
//  Created by ashley canty on 7/13/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

class ReleasedTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageArray = [String]()
    var moviePosterUrls = [String]()
    var movieArray: [Results]? {
        didSet {
            getPosterImages()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
    }
    
    func getPosterImages() {
        guard let movieArray = movieArray else { return }
        
        if movieArray.count > 0 {
            let movies = movieArray.prefix(8)
            var array = [String]()
            
            for movie in movies {
                array.append(movie.poster_path ?? "")
            }
            moviePosterUrls = array
            collectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviePosterUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: ReleasedCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "releasedCollectionCell", for: indexPath) as? ReleasedCollectionCell {
            
            guard let movies = movieArray else { return UICollectionViewCell() }
            
            cell.id = movies[indexPath.row].id?.returnStringDescription()
            cell.titleLabel.text = movies[indexPath.row].title
            cell.imageView.downloadImageFromCacheUsingURL(imgPath: moviePosterUrls[indexPath.row]) { (image) in
                if let updateCell = collectionView.cellForItem(at: indexPath) as? ReleasedCollectionCell {
                    updateCell.id = movies[indexPath.row].id?.returnStringDescription()
                    updateCell.imageView.image = image
                    updateCell.titleLabel.text = movies[indexPath.row].title
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 136, height: 220)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = Colors.cellColorBlue
        cell.clipsToBounds = false
        cell.layer.opacity = 1
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        cell.layer.shadowRadius = 4
        cell.layer.shadowOffset = CGSize(width: -1, height: 0)
        cell.layer.shadowOpacity = 0.4
        cell.layer.cornerRadius = 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Pressed")
        if let cell = collectionView.cellForItem(at: indexPath) as? ReleasedCollectionCell {
            guard let id = cell.id else { return }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PresentMovieDetail"), object: nil, userInfo: ["movieID": id])
        }
    }
}
