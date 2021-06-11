//
//  PersonalInfoVC.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 12.05.2021.
//

import UIKit
import Firebase
class AdressAddVC: UIViewController, UITextViewDelegate {

    
    let personalVC = PersonalVC()
    let db = Firestore.firestore()
    @IBOutlet weak var kaydetBtn: UIButton!
    @IBOutlet weak var adressName: UITextField!
    @IBOutlet weak var adressTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adressTextView.delegate = self
        let amountOfLinesToBeShown: CGFloat = 6
        let maxHeight: CGFloat = adressTextView.font!.lineHeight * amountOfLinesToBeShown
        adressTextView.sizeThatFits(CGSize(width: adressTextView.frame.size.width, height: maxHeight))
        
        adressTextView.text = "Adress Bilgilerinizi Girin!"
        adressTextView.textColor = UIColor.lightGray
        
        adressTextView.backgroundColor = .clear
        adressTextView.layer.cornerRadius = 5
        adressTextView.layer.borderWidth = 1
        adressTextView.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func adresiKaydetPressed(_ sender: UIButton) {
        
        if let email = Auth.auth().currentUser?.email{
            db.collection("Adresler").document("Email").collection(email).addDocument(data: [
                "adresAdi" : adressName.text!,
                "adres": adressTextView.text!
            ]){(error) in
                if let e = error{
                    print("There was an issue saving data to firestore \(e.localizedDescription)")
                   
                }else {
                    print("Succsess saving data")
                   
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "Roboto-Regular", size: 17)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Adress Bilgilerinizi Girin!"
            textView.textColor = UIColor.lightGray
        }
    }
}
