//
//  MusicListViewModel.swift
//  InsiderMusic
//
//  Created by mac on 26/06/20.
//  Copyright © 2020 Ganesh iOS. All rights reserved.
//

import Foundation

internal class MusicListViewModel {
    
    // MARK: - Constants
    
    /// MusicList Data GET - API response
    private var MusicListDataResp: MusicList_Data?
    
    /// Callback Closure, to show error alert
    var showErrorAlert: ((_ error: String) -> Void)?
    
    // MARK: - Initializers
    
    internal init() {
    }
    
}

// MARK: - Helper Methods

extension MusicListViewModel {
    
    /// Count of Songs List
    func getMusicCount() -> Int {
        guard let count = self.MusicListDataResp?.results?.count else { return 0 }
        return count
    }
    
    /// Song Item from the Array
    func getSongItem(at index: IndexPath) -> MusicResults? {
        guard let item = self.MusicListDataResp?.results?[index.row] else { return nil }
        return item
    }
    
    /// Clear Data
    func clearData() {
        self.MusicListDataResp = nil
    }
}

// MARK: - API Calls

extension MusicListViewModel {
    
    // Getting Music List Data from iTunes
    
    func getMusicListFromServer(searchText: String?, success: @escaping(Bool) -> Void, failure: @escaping(NetworkError) -> Void) {
        ///
        let apiUrl = AppConstants.serverUrl + (searchText ?? "")
        ///
        NetworkManager.shared.getMusicListData(apiUrl) { [weak self] (resultData) in
            switch resultData {
            case .success(let data):
                do {
                    let parsedData = try JSONDecoder().decode(MusicList_Data.self, from: data)
                    self?.MusicListDataResp = parsedData
                    success(true)
                } catch {
                    debugPrint("Error while parsing data: \(error.localizedDescription)")
                    self?.showErrorAlert?(error.localizedDescription)
                    success(false)
                }
            case .failure(let error):
                self?.showErrorAlert?(error.localizedDescription)
                failure(error)
            }
        }
    }
}
