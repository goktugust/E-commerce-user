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
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if Auth.auth().currentUser != nil{
//            performSegue(withIdentifier: "loggedInUser", sender: self)
//        }
        
        signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 2
        signInButton.layer.cornerRadius = signInButton.frame.size.height / 2
        // Do any additional setup after loading the view.
    }
    @IBAction func signInPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
    }
}

