//
//  UIViewController+Allert.swift
//  CarRacing
//
//  Created by Dmitriy Budanov on 29.03.2022.
//

import UIKit

extension UIViewController {
    func showAlert(title:String = "Error",
                   message:String = "Something going wrong",
                   button:String? = nil,
                   secondButton:String? = nil,
                   handler:((UIAlertAction) ->())? = nil,
                   textFieldHandler:((UITextField) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
        if let button = button {
            let action = UIAlertAction(title: button,
                                       style: .default
            ) { action in
                handler?(action)
                if let textField = alert.textFields?.first{
                    textFieldHandler?(textField)
                }
            }
            alert.addAction(action)
        }
        if secondButton != nil {
        let cancelAction = UIAlertAction(title: secondButton,
                                          style: .cancel
        )
        if textFieldHandler != nil {
        alert.addTextField { textField in
            textField.placeholder = "PIN"
            }
        alert.addAction(cancelAction)
            }
        }
        self.present(alert, animated: true)
    }
}
