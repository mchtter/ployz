//
//  DetailsViewModel.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 18.01.2023.
//

import Foundation

final class DetailsViewModel: DetailsViewModelProtocol {
    var delegate: DetailsViewModelDelegate?
    var gameDetails: GameDetailsModel?
    
    func fetchGameDetails(_ gameId: Int) {
        NetworkManager.getGameDetails(gameId: gameId) { [weak self] game, error in
            guard let self = self else { return }
            
            if game?.id == nil {
                NotificationCenter.default.post(name: NSNotification.Name("gameDetailsErrorMessage"), object: error?.localizedDescription)
            }
            self.gameDetails = game
            self.delegate?.didGameLoad()
        }
    }
    
    func getGameImage() -> String {
        return gameDetails?.backgroundImage ?? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
    }
    
    func getGameTitle() -> String? {
        return gameDetails?.name ?? "PLOYZ"
    }
    
    func getGameDescription() -> String? {
        return gameDetails?.description ?? ""
    }
}

protocol DetailsViewModelProtocol {
    var delegate: DetailsViewModelDelegate? { get set }

    func fetchGameDetails(_ gameId: Int)
    func getGameImage() -> String
    func getGameTitle() -> String?
    func getGameDescription() -> String?
}

protocol DetailsViewModelDelegate: AnyObject {
    func didGameLoad()
}
