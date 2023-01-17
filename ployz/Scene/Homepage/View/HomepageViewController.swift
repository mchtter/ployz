//
//  HomepageView.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 15.01.2023.
//

import UIKit

class HomepageViewController: UIViewController {
    
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

        viewModel.delegate = self
        viewModel.fetchPopularGames()
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
}

extension HomepageViewController: HomepageViewModelDelegate {
    func didGamesLoad() {
        gamesTableView.reloadData()
    }
}
