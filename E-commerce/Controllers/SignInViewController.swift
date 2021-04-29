//
//  SignInViewController.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 29.04.2021.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        
        if let email = emailText.text, let password = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    print(e.localizedDescription)
                }else {
                    print("Sgned in")
                }
            }
        }
        
    }
}
