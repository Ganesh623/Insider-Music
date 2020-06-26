//
//  MusicListScene.swift
//  InsiderMusic
//
//  Created by mac on 23/06/20.
//  Copyright © 2020 Ganesh iOS. All rights reserved.
//

import UIKit

class MusicListScene: UITableViewController {
    
    // MARK: - Property Declerations
    
    lazy var musicSearchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Artist Name"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    // ViewModel Instance
    lazy var MusicListVM: MusicListViewModel = {
        let viewModel = MusicListViewModel()
        return viewModel
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///
        self.navigationItem.searchController = self.musicSearchController
        ///
        self.registerSongItemTableCell()
        /// Call API with RecentSearch Text. Which stored in UserDefaults
        self.recentSearchList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// ShowAlert Callback Closure Instance.
        self.MusicListVM.showErrorAlert = { [weak self] (errorMsg) in
            DispatchQueue.main.async {
                self?.showAlert(with: "Error", message: errorMsg)
            }
        }
    }
    
    // MARK: - Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SongDetailScene {
            let vc = segue.destination as? SongDetailScene
            guard let selectedRow = sender as? IndexPath else { return }
            vc?.songDetails = self.MusicListVM.getSongItem(at: selectedRow)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// Count from ViewModel.
        return self.MusicListVM.getMusicCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let songCell = tableView.dequeueReusableCell(withIdentifier: AppConstants.songItemTableCell, for: indexPath) as? SongDetailsTableCell
            else { return UITableViewCell() }
        /// Get Data from ViewModel and assign to Cell
        let songDetails = self.MusicListVM.getSongItem(at: indexPath)
        songCell.bindDataToSongCell(songDetails)
        ///
        return songCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Perform Segue here, with data.
        self.performSegue(withIdentifier: AppConstants.songDetailSceneSegue, sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ///
        if (self.musicSearchController.isActive) { return nil }
        else { return AppConstants.recentSectionTitle }
    }
}

// MARK: - Setup Methods

extension MusicListScene {
    ///
    private func registerSongItemTableCell() {
        self.tableView.register(UINib(nibName: AppConstants.songItemTableCell, bundle: nil), forCellReuseIdentifier: AppConstants.songItemTableCell)
    }
    
    /**
     Show Recent Search List from Userdefaults Text.
     */
    private func recentSearchList() {
        
        // If Userdefaults exists already then use it. Otherwise create default one.
        if let recentSearchText = UserDefaults.standard.string(forKey: AppConstants.userdefaultKey), !(recentSearchText.isEmpty) {
            DispatchQueue.main.async { self.callAPI(with: recentSearchText) }
        } else {
            DispatchQueue.main.async { self.callAPI(with: "Adele") }
        }
    }
}

// MARK: - Helper Methods

extension MusicListScene {
    
    /// Show Alert with Error Message.
    func showAlert(with title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - SearchController Delegates

extension MusicListScene: UISearchResultsUpdating, UISearchBarDelegate {
    /**
     Update Search Results, When text changes.
     */
    func updateSearchResults(for searchController: UISearchController) {
        DispatchQueue.main.async { self.callAPI(with: searchController.searchBar.text) }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.MusicListVM.clearData()
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /// Save recent Search Text in Userdefaults
        UserDefaults.standard.set(searchBar.text, forKey: AppConstants.userdefaultKey)
    }
    
    /**
     After clicking Cancel, call default Artist API.
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        /// Call API with RecentSearch Text. Which stored in UserDefaults
        DispatchQueue.main.async { self.recentSearchList() }
    }
}

// MARK: - API Calls

extension MusicListScene {
    
    /// Calls API
    func callAPI(with searchBarText: String?) {
        ///
        self.MusicListVM.getMusicListFromServer(searchText: searchBarText, success: { [weak self] (isSuccess) in
            ///
            if (isSuccess) {
                DispatchQueue.main.async { self?.tableView.reloadData() }
            }
        }) { (error) in
            print(error.errorDescription ?? "")
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
}
