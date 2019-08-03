//
//  HomeScreenViewController.swift
//  TheReel
//
//  Created by ashley canty on 7/11/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    let key = NotificationKeys.loadHomescreenTable.rawValue
    
    var trendingMovies: [Results]?
    var releasedMovies: [Results]?
    var upcomingMovies: [Results]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.shadowImage = UIImage()
        setNeedsStatusBarAppearanceUpdate()
        navigationItem.title = "Welcome to The Reel"
        DispatchQueue.global(qos: .background).async { self.fetchTrendingMovies()
            self.fetchReleasedMovies()
            self.fetchUpcomingMovies()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(presentMovieTrailer), name: NSNotification.Name(rawValue: "PresentTrailer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadTable), name: NSNotification.Name.init(rawValue: key), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentDetailModal(notif:)), name: NSNotification.Name(rawValue: "PresentMovieDetail"), object: nil)
    }
    
    @objc func presentDetailModal(notif: NSNotification) {
        if let userInfo = notif.userInfo {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard
                .instantiateViewController(withIdentifier: "MovieDetailTableViewController") as? MovieDetailTableViewController {
                detailVC.id = userInfo["movieID"] as? String
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    @objc func loadTable() {
        DispatchQueue.main.async(execute: self.tableView.reloadData)
    }
        
    func fetchTrendingMovies() {
        Network.fetchTrendingMovies { (results) in
            let prefixList = results.prefix(8)
            var finalList = [Results]()
            
            for obj in prefixList {
                guard let id = obj.id?.returnStringDescription() else { return }
                var objCopy = obj
                
                Network.fetchMovieDetails(fetchWithID: id, completion: { [weak self] (movieDetails) in
                    guard let self = self else { return }
                    
                    objCopy.runtime = movieDetails.runtime
                    objCopy.mainGenre = movieDetails.genres?.first?.name
                    finalList.append(objCopy)
                    if finalList.count == prefixList.count {
                        self.trendingMovies = finalList
                        let movie = finalList.first
                        let path = movie?.poster_path
                        UserDefaults.standard.set(path, forKey: "SearchPosterUrl")
                        DispatchQueue.main.async(execute: self.tableView.reloadData)
                    }
                })
            }
        }
    }
    
    func fetchReleasedMovies() {
        Network.fetchReleasedMovies { [weak self] (results) in
            guard let self = self else { return }
            self.releasedMovies = results
            DispatchQueue.main.async(execute: self.tableView.reloadData)
        }
    }
    
    func fetchUpcomingMovies() {
        Network.fetchUpcomingMovies { [weak self] (results) in
            guard let self = self else { return }
            self.upcomingMovies = results
            DispatchQueue.main.async(execute: self.tableView.reloadData)
            
            let prefixList = results.prefix(8)
            var finalList = [Results]()
            
            for obj in prefixList {
                guard let id = obj.id?.returnStringDescription() else { return }
                var objCopy = obj
                self.fetchTrailerURL(withID: id, completion: { (key) in
                    objCopy.trailerKey = key
                    finalList.append(objCopy)
                    if finalList.count == prefixList.count {
                        self.upcomingMovies = finalList
                        DispatchQueue.main.async(execute: self.tableView.reloadData)
                    }
                })
            }
        }
    }
    
    func fetchTrailerURL(withID id: String, completion: @escaping ((String)->())){
        Network.fetchTrailerUrl(fetchWithID: id) { [weak self] (key) in
            guard let self = self else { return }
            completion(key)
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
                self.tableView.reloadData()
            }
        }
    }
    
    // TODO: -- Debug to find out why userInfo not working
    @objc func presentMovieTrailer(_ notification: NSNotification) {
        if let key = notification.userInfo?["TrailerKey"] as? String {
            let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifiers.MovieTrailerVC.rawValue) as! MovieTrailerViewController
            vc.videoID = key
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var titleText: String?
        if section == 0 {
            titleText = "Trending"
        } else if section == 1 {
            titleText = "In Theaters"
        } else if section == 2 {
            titleText = "Upcoming"
        }
        
        var view: UIView
        view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        view.backgroundColor = Colors.darkBlue
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 35))
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        label.text = titleText
        label.textColor = .white
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 230
        } else if indexPath.section == 1{
            return 260
        } else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 230
        } else if indexPath.section == 1{
            return 260
        } else {
            return 200
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "trendingTableCell", for: indexPath) as? TrendingTableCell {
                if let movies = self.trendingMovies {
                    cell.movieArray = movies
                }
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "releasedTableCell", for: indexPath) as? ReleasedTableCell {
                if let movies = releasedMovies {
                    cell.movieArray = movies
                }
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingTableCell", for: indexPath) as? UpcomingTableCell {
                if let movies = upcomingMovies {
                    cell.movieArray = movies
                }
                return cell
            }
        }
        return UITableViewCell()
    }
}
