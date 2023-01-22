//
//  AppExtensions.swift
//  ployz
//
//  Created by Mücahit Alperen Eryılmaz on 19.01.2023.
//

import UIKit
extension UIViewController{
    @objc func errorHandler(_ error: Notification) {
        if let message = error.object as? String {
            let modal = UIAlertController(title: NSLocalizedString("ERROR_TITLE", comment: "Error"), message: message, preferredStyle: UIAlertController.Style.alert)
            modal.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON", comment: "OK"), style: UIAlertAction.Style.default, handler: nil))
            self.present(modal, animated: true, completion: nil)
        }
    }
}
