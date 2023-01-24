//
//  HomepageViewModel.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 15.01.2023.
//

import Foundation

class HomepageViewModel: HomepageViewModelProtocol {
    var delegate: HomepageViewModelDelegate?
    var popularGames: [Result]?
    
    func fetchPopularGames() {
        NetworkManager.getPopularGames { [weak self] fetchedGames, error in
            guard let _ = self else { return }
            if let error {
                NotificationCenter.default.post(name: NSNotification.Name("popularGamesErrorMessage"), object: error.localizedDescription)
                return 
            }
            self?.popularGames = fetchedGames
            self?.delegate?.didGamesLoad()
        }
    }
    
    func searchGames(_ searchParameter: String) {
        NetworkManager.searchGames(searchText: searchParameter) { [weak self] searchGame, error in
            guard let _ = self else { return }
            if let error {
                NotificationCenter.default.post(name: NSNotification.Name("searchGamesErrorMessage"), object: error.localizedDescription)
                return
            }
            self?.popularGames = searchGame
            self?.delegate?.didGamesLoad()
        }
    }
    
    func getGames(at index: Int) -> Result? {
        return popularGames?[index]
    }
    
    func getPopularGamesCount() -> Int {
        return popularGames?.count ?? 0
    }
    
    func getGameId(at index: Int) -> Int? {
        return popularGames?[index].id
    }
    
    func orderByName(status: Bool) {
        if status {
            popularGames = popularGames?.sorted { (first, second) in
                return first.name ?? "-" < second.name ?? "-"
            }
        } else {
            popularGames = popularGames?.sorted { (first, second) in
                return first.id ?? 0 < second.id ?? 0
            }
        }
        delegate?.didGamesLoad()
    }
}

protocol HomepageViewModelProtocol {
    var delegate: HomepageViewModelDelegate? { get set }
    func fetchPopularGames()
    func searchGames(_ searchParameter: String)
    func getGames(at index: Int) -> Result?
    func getPopularGamesCount() -> Int
    func getGameId(at index: Int) -> Int?
    func orderByName(status: Bool)
}

protocol HomepageViewModelDelegate: AnyObject {
    func didGamesLoad()
}
