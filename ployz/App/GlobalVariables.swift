//
//  GlobalVariables.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 22.01.2023.
//

import Foundation

class GlobalVariables {
    static let sharedInstance = GlobalVariables()
    private init(){}
    
    var isFavoriteChanged = false
}
