//
//  SecondViewController.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 29.04.2021.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneBtn.layer.cornerRadius = doneBtn.frame.size.height / 2
    }
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        
        
        
        if let email = emailText.text, let password = passwordText.text{
            
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    print(e.localizedDescription)
                }else{
                    print("succesfuly signed")
                }
            }
        }
        
        
        
    }
    
}
