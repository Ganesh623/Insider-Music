//
//  SongDetailsTableCell.swift
//  InsiderMusic
//
//  Created by mac on 23/06/20.
//  Copyright © 2020 Ganesh iOS. All rights reserved.
//

import UIKit

class SongDetailsTableCell: UITableViewCell {

    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var songGenreLabel: UILabel!
    @IBOutlet weak var songDurationLabel: UILabel!
    @IBOutlet weak var songPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - Binding Data to Cell

extension SongDetailsTableCell {
    
    func bindDataToSongCell(_ details: MusicResults?) -> Void {
        guard let details = details else { return }
        ///
        DispatchQueue.main.async {
            ///
            self.songNameLabel.text = details.trackName
            self.songArtistLabel.text = details.artistName
            self.songGenreLabel.text = details.primaryGenreName
            self.songPriceLabel.text = "$\(details.trackPrice ?? 0.0)"
            ///
            let (_,m,s) = AppHelpers.shared.secondsToHMS(seconds: details.trackTimeMillis ?? 0)
            self.songDurationLabel.text = "\(m):\(s)"
            ///
            self.songImageView.downloadAndSetImage(from: details.artworkUrl60)
        }
    }
}
