//
//  RegisterVC.swift
//  DisertatieEnachescuRobert
//
//  Created by Robert Enachescu on 19/01/2020.
//  Copyright © 2020 Enachescu Robert. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterVC: UIViewController {
    
    //  MARK: - IBOutlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    //  MARK: - Properties
    var user: User?
    let goToMap = "goToMap"
    
    //  MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //  MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToMap {
            if let vc = segue.destination as? MapVC {
                vc.user = user
            }
        }
    }
    
    //  MARK: - IBActions
    @IBAction func register(_ sender: Any) {
        if emailTF.text == "" ||
            passwordTF.text == "" ||
            confirmPasswordTF.text == "" {
            AlertManager.shared.showAlertMessage(vc: self, message: "You must fill out all fields.", handler: {})
        } else if passwordTF.text != confirmPasswordTF.text {
            AlertManager.shared.showAlertMessage(vc: self, message: "Passwords did not match.", handler: {})
        } else {
            
            Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) {
                authDataResult, error in
                
                if error != nil {
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                        switch errorCode {
                        case .weakPassword:
                            print("Please provice a strong password")
                            AlertManager.shared.showAlertMessage(vc: self, message: "Please provide a strong password", handler: {})
                        default:
                            print(error?.localizedDescription ?? "Error")
                            AlertManager.shared.showAlertMessage(vc: self, message: "Error: \(error?.localizedDescription ?? "error")", handler: {})
                        }
                        
                    }
                }
                
                if let authDataResult = authDataResult {
                    authDataResult.user.sendEmailVerification() {
                        error in
                        if error != nil {
                            AlertManager.shared.showAlertMessage(vc: self, message: "Error: \(error?.localizedDescription ?? "error")", handler: {})
                        } else {
                            Auth.auth().signIn(withEmail: self.emailTF.text!, password: self.passwordTF.text!)
                            AlertManager.shared.showAlertMessage(vc: self, title: "Done",message: "You will receive an confirmation email soon. You'll have limited access for now.", handler: {
                                self.user = User(uid: authDataResult.user.uid, email: authDataResult.user.email ?? "")
                                self.performSegue(withIdentifier: self.goToMap, sender: nil)
                            })
                        }
                    }
                }
            }
        }
    }
}
