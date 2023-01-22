//
//  DetailsView.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 18.01.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var gameId: Int?
    var viewModel: DetailsViewModelProtocol = DetailsViewModel()
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        likeButtonHandler(likeStatus: viewModel.favoriteHandler())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _gameId = gameId else { return }
        NotificationCenter.default.addObserver(self, selector: #selector(errorHandler), name: NSNotification.Name("detailGamesErrorMessage"), object: nil)
        viewModel.delegate = self
        viewModel.fetchGameDetails(_gameId)
    }
    
    func likeButtonHandler(likeStatus: Bool?) {
        if let likeStatus {
            if likeStatus {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            likeButton.isHidden = false
            return
        }
        likeButton.isHidden = true
        return
    }
}

extension DetailsViewController: DetailsViewModelDelegate {
    func didGameLoad() {
        
        if let _gameId = self.gameId {
            self.likeButtonHandler(likeStatus: self.viewModel.isFavoriteGame(_gameId))
        }
        self.gameImage.kf.indicatorType = .activity
        guard let img = URL(string: self.viewModel.getGameImage()) else { return }
        DispatchQueue.main.async {
            self.gameImage.kf.setImage(with: img)
        }
        
        self.gameTitle.text = self.viewModel.getGameTitle()
        self.gameDescription.text = self.viewModel.getGameDescription()
        
    }
}
