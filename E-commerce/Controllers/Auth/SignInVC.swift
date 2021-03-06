//
//  SignInViewController.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 29.04.2021.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        doneBtn.layer.cornerRadius = doneBtn.frame.size.height / 2
    }
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        
        if let email = emailText.text, let password = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    let alert = UIAlertController(title: "Error", message: "\(e.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(e.localizedDescription)
                }else {
                    self.performSegue(withIdentifier: "signedIn", sender: self)
                    print("Signed in")
                }
            }
        }
        
    }
}
