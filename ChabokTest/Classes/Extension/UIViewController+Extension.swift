//
//  UIViewController+Extension.swift
//  ChabokTest
//
//  Created by Hussein Habibi Juybari on 9/25/18.
//  Copyright © 2018 Chabok Realtime Solutions. All rights reserved.
//

import UIKit

extension UIViewController {

    func showErrorAlert(message: String){
        showAlert(title: "Error", message: message)
    }
    
    func showInfoAlert(message: String){
        showAlert(title: "Information", message: message)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController.init(title: title,
                                           message: message,
                                           preferredStyle: .actionSheet)
        let okAction = UIAlertAction.init(title: "OK",
                                          style: .cancel,
                                          handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
