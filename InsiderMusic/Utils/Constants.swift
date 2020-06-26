//
//  Constants.swift
//  InsiderMusic
//
//  Created by mac on 24/06/20.
//  Copyright © 2020 Ganesh iOS. All rights reserved.
//

import Foundation

// MARK: - App Constants

public struct AppConstants {
    ///
    static let songItemTableCell = "SongDetailsTableCell"
    ///
    static let serverUrl = "https://itunes.apple.com/search?term="
    ///
    static let songDetailSceneSegue = "songDetailSegue"
    ///
    static let userdefaultKey = "recentSearch"
    ///
    static let recentSectionTitle = "Recent Search"
}

// MARK: - App Heleprs

public struct AppHelpers {
    static let shared = AppHelpers()
    
    /**
     Convert Seconds to Hours, Minutes & Seconds.
     */
    func secondsToHMS (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
