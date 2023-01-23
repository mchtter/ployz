//
//  FavoritesViewModel.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 15.01.2023.
//

import Foundation

class FavoritesViewModel: FavoritesViewModelProtocol {
    var delegate: FavoritesViewModelDelegate?
    var favorites = [Favorites]()
    var games: [GameDetailsModel]?
    
    func getFavorites() {
        GlobalVariables.sharedInstance.isFavoriteChanged = false
        games = [GameDetailsModel]()
        favorites = FavoritesCoreData.shared.getFavorite()
        var favCounter = favorites.count
        
        if favorites.count <= 0 {
            delegate?.didLoadFavorites()
            return
        }
        
        for fav in favorites.enumerated() {
            games?.append(GameDetailsModel(id: Int(fav.element.gameId)))
            NetworkManager.getGameDetails(gameId: Int(fav.element.gameId)) { [weak self] game, error in
                guard let _game = self else { return }
                if let game {
                    if game.id == nil {
                        self?.favorites.removeAll()
                        NotificationCenter.default.post(name: NSNotification.Name("favoritesErrorMessage"), object: error?.localizedDescription)
                        return
                    }
                    _game.games?[fav.offset] = game
                    favCounter -= 1
                    if(favCounter <= 0) {
                        _game.delegate?.didLoadFavorites()
                    }
                }
                
            }
        }
    }
    
    func getGame(at index: Int) -> GameDetailsModel? {
        return games?[index]
    }
    
    func getGameCount() -> Int {
        return games?.count ?? 0
    }
}

protocol FavoritesViewModelProtocol {
    var delegate: FavoritesViewModelDelegate? { get set }
    
    func getFavorites()
    func getGame(at index: Int) -> GameDetailsModel?
    func getGameCount() -> Int
}

protocol FavoritesViewModelDelegate: AnyObject {
    func didLoadFavorites()
}
