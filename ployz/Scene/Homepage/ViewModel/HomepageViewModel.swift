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
        NetworkManager.getPopularGames { [weak self] popularGames, error in
            guard let game = self else { return }
            if let error {
                NotificationCenter.default.post(name: NSNotification.Name("popularGamesErrorMessage"), object: error.localizedDescription)
                game.delegate?.didGamesLoad()
                return 
            }
            game.popularGames = popularGames
            game.delegate?.didGamesLoad()
        }
    }
    
    func getGames(at index: Int) -> Result? {
        popularGames?[index]
    }
    
    func getPopularGamesCount() -> Int {
        return popularGames?.count ?? 0
    }
}

protocol HomepageViewModelProtocol {
    var delegate: HomepageViewModelDelegate? { get set }
    func fetchPopularGames()
    func getGames(at index: Int) -> Result?
    func getPopularGamesCount() -> Int
}

protocol HomepageViewModelDelegate: AnyObject {
    func didGamesLoad()
}
