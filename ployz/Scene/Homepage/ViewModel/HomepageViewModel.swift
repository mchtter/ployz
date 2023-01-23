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
    var orderGames: [Result]?
    
    func fetchPopularGames() {
        NetworkManager.getPopularGames { [weak self] popularGames, error in
            guard let game = self else { return }
            if let error {
                NotificationCenter.default.post(name: NSNotification.Name("popularGamesErrorMessage"), object: error.localizedDescription)
                game.delegate?.didGamesLoad()
                return 
            }
            game.popularGames = popularGames
            game.orderGames = popularGames
            game.delegate?.didGamesLoad()
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
            popularGames = orderGames?.sorted { (first, second) in
                return first.name ?? "-" < second.name ?? "-"
            }
        } else {
            popularGames = orderGames?.sorted { (first, second) in
                return first.id ?? 0 < second.id ?? 0
            }
        }
        delegate?.didGamesLoad()
    }
}

protocol HomepageViewModelProtocol {
    var delegate: HomepageViewModelDelegate? { get set }
    func fetchPopularGames()
    func getGames(at index: Int) -> Result?
    func getPopularGamesCount() -> Int
    func getGameId(at index: Int) -> Int?
    func orderByName(status: Bool)
}

protocol HomepageViewModelDelegate: AnyObject {
    func didGamesLoad()
}
