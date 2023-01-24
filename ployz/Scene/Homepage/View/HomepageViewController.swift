//
//  HomepageView.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 15.01.2023.
//

import UIKit

class HomepageViewController: UIViewController {
    var viewModel: HomepageViewModelProtocol = HomepageViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    var orderByName = false
    var lastScheduledSearch: Timer?
    var searchText: String = ""
    
    @IBOutlet weak var orderButton: UIBarButtonItem!
    @IBOutlet weak var apiKeyErrorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gamesTableView: UITableView! {
        didSet {
            gamesTableView.delegate = self
            gamesTableView.dataSource = self
            gamesTableView.register(UINib(nibName: "GamesTableViewCell", bundle: nil), forCellReuseIdentifier: "gamesTableCell")
            gamesTableView.rowHeight = 161
        }
    }
    
    @IBAction func orderButtonAction(_ sender: Any) {
        if (orderByName == false){
            viewModel.orderByName(status: orderByName)
            orderButton.image = UIImage(systemName: "arrow.up.square.fill")
            orderByName = true
        } else {
            viewModel.orderByName(status: orderByName)
            orderButton.image = UIImage(systemName: "arrow.down.square.fill")
            orderByName = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        apiKeyErrorLabel.isHidden = true
        viewModel.delegate = self
        activityIndicator.startAnimating()
        viewModel.fetchPopularGames()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        self.searchText = searchText
        lastScheduledSearch?.invalidate()
        lastScheduledSearch = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.startTyping), userInfo: searchText, repeats: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "homepageToGameDetail":
                if let gameId = sender as? Int {
                    let target = segue.destination as! DetailsViewController
                    target.gameId = gameId
                }
            default:
                print("ERROR")
        }
    }
}

extension HomepageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getPopularGamesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gamesTableCell", for: indexPath) as? GamesTableViewCell,
              let gameObject = viewModel.getGames(at: indexPath.row) else { return UITableViewCell() }
        
        DispatchQueue.main.async {
            cell.setCell(gameObject)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let gameId = viewModel.getGameId(at: indexPath.row) {
            performSegue(withIdentifier: "homepageToGameDetail", sender: gameId)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.getPopularGamesCount() && !(GlobalVariables.store.homepageTableSize > viewModel.getPopularGamesCount()) {
            GlobalVariables.store.homepageTableSize += 10
//            GlobalVariables.store.homepageTablePage += 1
//            GlobalVariables.store.paginationMode = true
            if GlobalVariables.store.isSearchActive {
                viewModel.searchGames(searchText)
            } else {
                viewModel.fetchPopularGames()
            }
        }
    }
}

extension HomepageViewController: HomepageViewModelDelegate {
    func didGamesLoad() {
        gamesTableView.reloadData()
        activityIndicator.stopAnimating()
        if viewModel.getPopularGamesCount() == 0 {
            apiKeyErrorLabel.isHidden = false
        } else if viewModel.getPopularGamesCount() == 0 && GlobalVariables.store.isSearchActive {
            apiKeyErrorLabel.text = "Sonuç Bulunamadı"
            apiKeyErrorLabel.isHidden = false
        } else {
            apiKeyErrorLabel.isHidden = true
        }
    }
}

extension HomepageViewController: UISearchResultsUpdating, UISearchBarDelegate {
    @objc func startTyping() {
        activityIndicator.startAnimating()
        if searchText == "" {
            GlobalVariables.store.homepageTableSize = 10
            GlobalVariables.store.isSearchActive = false
            viewModel.fetchPopularGames()
        } else {
            GlobalVariables.store.homepageTableSize = 10
            GlobalVariables.store.isSearchActive = true
            didSearchGame()
        }
    }
    func didSearchGame() {
        viewModel.searchGames(searchText)
    }
}
