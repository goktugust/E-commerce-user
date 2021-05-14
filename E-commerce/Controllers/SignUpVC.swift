//
//  SecondViewController.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 29.04.2021.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        doneBtn.layer.cornerRadius = doneBtn.frame.size.height / 2
    }
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        
        
        
        if let email = emailText.text, let password = passwordText.text, let name = fullName.text{
            
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    let alert = UIAlertController(title: "Error!", message: "\(e.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(e.localizedDescription)
                }else{
                    if let user = Auth.auth().currentUser?.email{
                        self.db.collection("Kullanıcılar").document("Email").collection(user).addDocument(data: [
                            
                            "mail": email,
                            "name": name
                        ]){(error) in
                            if let e = error {
                                print("There was an issue saving data to firestore \(e.localizedDescription)")
                            }else{
                                print("Succsess saving data!")
                            }
                        }
                    }
                    
                    
                    
                    self.performSegue(withIdentifier: "signUp", sender: self)
                    print("succesfuly signed")
                }
            }
        }
        
        
        
    }
    
}
