//
//  FavoritesView.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 15.01.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    var viewModel: FavoritesViewModelProtocol = FavoritesViewModel()
    
    @IBOutlet weak var favoritesTableView: UITableView!{
        didSet {
            favoritesTableView.delegate = self
            favoritesTableView.dataSource = self
            favoritesTableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "favoritesCell")
            favoritesTableView.rowHeight = 175
            
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel! {
        didSet {
            emptyLabel.text = "Favori listeniz boş."
            emptyLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(errorHandler), name: NSNotification.Name("favoritesErrorMessage"), object: nil)
        viewModel.delegate = self
        activityIndicator.startAnimating()
        viewModel.getFavorites()
        GlobalVariables.store.isFavoriteChanged = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if GlobalVariables.store.isFavoriteChanged {
            activityIndicator.startAnimating()
            viewModel.getFavorites()
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.getGameCount()
        if count == 0 {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as? FavoritesTableViewCell,
              let game = viewModel.getGame(at: indexPath.row) else { return UITableViewCell() }
        DispatchQueue.main.async {
            cell.setFavoritesCell(game)
        }
        return cell
    }
    
}

extension FavoritesViewController: FavoritesViewModelDelegate {
    func didLoadFavorites() {
        favoritesTableView.reloadData()
        activityIndicator.stopAnimating()
    }
}
