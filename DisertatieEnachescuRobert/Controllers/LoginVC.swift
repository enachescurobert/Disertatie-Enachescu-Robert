//
//  LoginVC.swift
//  DisertatieEnachescuRobert
//
//  Created by Robert Enachescu on 19/01/2020.
//  Copyright © 2020 Enachescu Robert. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    //  MARK: - IBOutlets
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    //  MARK: - Properties
    var user: User?
    let loginToMap = "loginToMap"
    
    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove the user if he logs out of the system
        let listener = Auth.auth().addStateDidChangeListener{
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.loginToMap, sender: nil)
            }
        }
        Auth.auth().removeStateDidChangeListener(listener)
    }
    
    //  MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == loginToMap {
            if let vc = segue.destination as? MapVC {
                vc.user = user
            }
        }
    }
    
    //  MARK: - IBActions
    @IBAction func loginDidTouch(_ sender: Any) {
        if loginTF.text == "" || passwordTF.text == "" {
            AlertManager.shared.showAlertMessage(vc: self, message: "You must fill out all fields", handler: {})
        } else {
            Auth.auth().signIn(withEmail: loginTF.text!, password: passwordTF.text!, completion: {
                authDataResult, error in
                if let error = error {
                    AlertManager.shared.showAlertMessage(vc: self, message: "Error: \(error.localizedDescription)", handler: {})
                    return
                }
                
                guard let authDataResult = authDataResult else { return }
                
                self.user = User(uid: authDataResult.user.uid, email: authDataResult.user.email ?? "")
                self.performSegue(withIdentifier: self.loginToMap, sender: nil)
            })
        }
    }
}
