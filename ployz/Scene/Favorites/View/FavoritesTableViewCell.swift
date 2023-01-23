//
//  FavoritesTableViewCell.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 23.01.2023.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setFavoritesCell(_ game: GameDetailsModel) {
        gameTitle.text = game.name
        setImage(imgUrl: game.backgroundImage)
    }
    
    func setImage(imgUrl: String?) {
        guard let img = URL(string: imgUrl ?? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg") else { return }
        DispatchQueue.main.async {
            self.gameImage.kf.setImage(with: img)
        }
    }
}
