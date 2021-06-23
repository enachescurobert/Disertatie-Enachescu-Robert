//
//  AlertManager.swift
//  DisertatieEnachescuRobert
//
//  Created by Robert Enachescu on 23.06.2021.
//

import Foundation
import UIKit

struct AlertManager {
    
    private init() {}
    static var shared = AlertManager()
    
    func showAlertMessage(vc: UIViewController, title titleStr: String = "Alert", message messageStr: String, handler completionHandler: @escaping () -> ()) {
        
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert) in completionHandler()}
        ))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithCancelOption(vc: UIViewController, title titleStr: String, message messageStr: String, cancelText: String = "Cancel", confirmationText: String = "Ok", handler completionHandler: @escaping () -> ()) {
        
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: cancelText, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: confirmationText, style: .default, handler: {(alert) in completionHandler()}))
        vc.present(alert, animated: true, completion: nil)
    }
}
