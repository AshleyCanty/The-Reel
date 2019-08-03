//
//  HomeScreenTableCell.swift
//  TheReel
//
//  Created by ashley canty on 7/13/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

class TrendingTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageArray = [String]()
    var movieBackdropUrls = [String]()
    var movieArray: [Results]? {
        didSet {
            getBackdropImages()
        }
    }
    var runtimeList = [String]()
    var genreList = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
    }
    
    func getBackdropImages() {
        guard let movieArray = movieArray else { return }
        
        if movieArray.count > 0 {
            var array = [String]()
            
            for movie in movieArray {
                array.append(movie.backdrop_path ?? "")
            }
            movieBackdropUrls = array
            collectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieBackdropUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: TrendingCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCollectionCell", for: indexPath) as? TrendingCollectionCell {
            
            guard let movies = movieArray else { return UICollectionViewCell()}
            
            cell.id = movies[indexPath.row].id?.returnStringDescription()
            cell.titleLabel.text = movies[indexPath.row].title
            cell.genreLabel.text = movies[indexPath.row].mainGenre
            cell.durationLabel.text = movies[indexPath.row].runtime?.changeTimeFormat()

            cell.imageView.downloadImageFromCacheUsingURL(imgPath: movieBackdropUrls[indexPath.row]) { (image) in
                if let updateCell = collectionView.cellForItem(at: indexPath) as? TrendingCollectionCell {
                    updateCell.id = self.movieArray?[indexPath.row].id?.returnStringDescription()
                    updateCell.imageView.image = image
                    updateCell.titleLabel.text = self.movieArray?[indexPath.row].title
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 376, height: 200)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = Colors.darkBlue
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TrendingCollectionCell {
            print(cell.id)
            guard let id = cell.id else { return }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PresentMovieDetail"), object: nil, userInfo: ["movieID": id])
        }
    }
}
