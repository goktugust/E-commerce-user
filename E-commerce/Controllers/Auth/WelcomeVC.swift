//
//  ViewController.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 28.04.2021.
//

import UIKit
import Firebase

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
//        override func viewDidAppear(_ animated: Bool) {
//            super.viewDidAppear(false)
//            if Auth.auth().currentUser != nil{
//                performSegue(withIdentifier: "alreadySignedIn", sender: self)
//            }
//
//        }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        signUpButton.isHidden = true
        signInButton.isHidden = true
        if Auth.auth().currentUser?.email != nil{
            
            DispatchQueue.main.async(){
               self.performSegue(withIdentifier: "alreadySignedIn", sender: self)
            }

        }else {
            signUpButton.isHidden = false
            signInButton.isHidden = false

            signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 2
            signInButton.layer.cornerRadius = signInButton.frame.size.height / 2
        }

    }

    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            signUpButton.isHidden = true
            signInButton.isHidden = true
            
            if Auth.auth().currentUser?.email != nil{
//                signUpButton.isHidden = true
//                signInButton.isHidden = true
                
                DispatchQueue.main.async(){
                   self.performSegue(withIdentifier: "alreadySignedIn", sender: self)
                }

            }else {
                signUpButton.isHidden = false
                signInButton.isHidden = false
                
                signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 2
                signInButton.layer.cornerRadius = signInButton.frame.size.height / 2
            }
           
    
        }
    @IBAction func signInPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
    }
}

