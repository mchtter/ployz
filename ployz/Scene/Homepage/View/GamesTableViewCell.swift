//
//  GamesTableViewCell.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 15.01.2023.
//

import UIKit
import Kingfisher

final class GamesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(_ game: Result) {
        gameTitle.text = game.name
        gameDescription.text = setDescription(game)
        setImage(imgUrl: game.backgroundImage)
    }
    
    func setDescription(_ game: Result) -> String {
        var descriptionString = ""
        if let tags = game.tags, ((game.tags?.count ?? 0) != 0) {
            for t in tags {
                descriptionString += "#\(t.name ?? "ployz") "
            }
            descriptionString.removeLast()
        }
        return "\(descriptionString)"
    }
    
    func setImage(imgUrl: String?) {
        guard let img = URL(string: imgUrl ?? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg") else { return }
        DispatchQueue.main.async {
            self.gameImage.kf.setImage(with: img)
        }
    }
}
