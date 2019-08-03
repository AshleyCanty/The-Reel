//
//  HomeScreenTableCell.swift
//  TheReel
//
//  Created by ashley canty on 7/13/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

class UpcomingTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageArray = [String]()
    var movieBackdropUrls = [String]()
    var movieArray: [Results]? {
        didSet {
            getBackdropImages()
        }
    }
    
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
        if let cell: UpcomingCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCollectionCell", for: indexPath) as? UpcomingCollectionCell {

            guard let movies = movieArray else { return UICollectionViewCell() }
            cell.titleLabel.text = movies[indexPath.row].title
            
            cell.imageView.downloadImageFromCacheUsingURL(imgPath: movieBackdropUrls[indexPath.row]) { (image) in
                if let updateCell = collectionView.cellForItem(at: indexPath) as? UpcomingCollectionCell {
                    updateCell.imageView.image = image
                    updateCell.titleLabel.text = movies[indexPath.row].title
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 286, height: 170)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = Colors.darkBlue
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let key = movieArray?[indexPath.row].trailerKey else { return }
        NotificationCenter.default.post(name: NSNotification.Name("PresentTrailer"), object: nil, userInfo: ["TrailerKey": key])
    }
}
