//
//  MovieTrailerViewController.swift
//  TheReel
//
//  Created by ashley canty on 4/30/19.
//  Copyright © 2019 ashley canty. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class MovieTrailerViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var closeButton: UIButton!
    

    var videoID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.cornerRadius = 8.0
        playButton.layer.masksToBounds = true
        stopButton.layer.cornerRadius = 8.0
        stopButton.layer.masksToBounds = true
        closeButton.layer.cornerRadius = 8.0
        closeButton.layer.masksToBounds = true

        self.playerView.load(withVideoId: videoID)
    }
    
    @IBAction func startVideo(_ sender: Any) {
        playerView.playVideo()
    }
    
    
    @IBAction func stopVideo(_ sender: Any) {
        playerView.stopVideo()
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

