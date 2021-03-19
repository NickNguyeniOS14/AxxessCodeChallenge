//
//  ViewController + Ext.swift
//  Axxess
//
//  Created by Nick Nguyen on 3/19/21.
//

import UIKit

extension UIViewController {

    func showAlert(forError error: NetworkError) {
        let alertController = UIAlertController(title: error.errorDescription, message: error.recoverySuggestion, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)

        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
