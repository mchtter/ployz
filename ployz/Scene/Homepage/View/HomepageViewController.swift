//
//  HomepageView.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 15.01.2023.
//

import UIKit

class HomepageViewController: UIViewController {
    
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
    
    var viewModel: HomepageViewModelProtocol = HomepageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiKeyErrorLabel.isHidden = true
        viewModel.delegate = self
        activityIndicator.startAnimating()
        viewModel.fetchPopularGames()
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
}

extension HomepageViewController: HomepageViewModelDelegate {
    func didGamesLoad() {
        gamesTableView.reloadData()
        activityIndicator.stopAnimating()
        if viewModel.getPopularGamesCount() == 0 {
            apiKeyErrorLabel.isHidden = false
        }
    }
}
