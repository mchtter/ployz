//
//  GamesTableViewCell.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 15.01.2023.
//

import UIKit

final class GamesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
