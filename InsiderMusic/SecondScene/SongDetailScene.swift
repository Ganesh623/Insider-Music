//
//  SongDetailScene.swift
//  InsiderMusic
//
//  Created by mac on 26/06/20.
//  Copyright © 2020 Ganesh iOS. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SongDetailScene: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songDescriptionLabel: UILabel!
    @IBOutlet weak var musicPlayBtnOutlet: UIButton!
    
    // Stored Properties
    
    var songDetails: MusicResults?
    /// Property for AudioPlayer
    private var songTrailer: AVPlayer?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///
        DispatchQueue.main.async { self.setupSongData() }
    }
    
    // MARK: - IBActions
    
    @IBAction func musicPlayBtnAction(_ sender: Any) {
        
        /// Get Video URL and initialize the Player.
        let videoUrl = URL(string: self.songDetails?.previewUrl ?? "")
        self.songTrailer = AVPlayer(url: videoUrl!)
        
        /// Player ViewController.
        let playerVC = AVPlayerViewController()
        playerVC.player = self.songTrailer
        
        /// Present Video Player & Play in Completion
        self.present(playerVC, animated: true) { playerVC.player?.play() }
    }
}

// MARK: - Setup Methods

extension SongDetailScene {
    ///
    private func setupSongData() {
        guard let songItem = songDetails else { return }
        ///
        self.songImageView.downloadAndSetImage(from: songItem.artworkUrl100)
        self.songDescriptionLabel.text = songItem.longDescription
    }
}
