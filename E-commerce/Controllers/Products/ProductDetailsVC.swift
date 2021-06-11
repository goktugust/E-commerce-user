//
//  ProductDetailsVC.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 4.05.2021.
//

import UIKit
import SDWebImage
import Firebase
class ProductDetailsVC: UIViewController {
    
    var id = 0
    var category = ""
    var detail = ""
    var price: Float = 0
    var ident = ""
    var image = ""
    var stepperValue = 1
    var detailedView = [Products]()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var favoriteBarItem: UIBarButtonItem!
    @IBOutlet weak var sepeteEkle: UIButton!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var detailsText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var addProductNumber: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sepeteEkle.backgroundColor = .clear
        sepeteEkle.layer.cornerRadius = 5
        sepeteEkle.layer.borderWidth = 1
        sepeteEkle.layer.borderColor = UIColor.black.cgColor
        
        detailsText.text = detail
        titleText.text = ident
        priceText.text = "$\(price)"
        productImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "none"))
        
        
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        stepperValue = Int(sender.value)
        addProductNumber.text = String(stepperValue)
    }
    
    
    @IBAction func favoriteBarItemPressed(_ sender: UIBarButtonItem) {
        
        if let user = Auth.auth().currentUser?.email {
            db.collection("Favoriler").whereField("title", isEqualTo: ident).whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
                if let e = error{
                    print(e.localizedDescription)
                }else if snapshot?.isEmpty == true{
                    if let user = Auth.auth().currentUser?.email{
                        self.db.collection("Favoriler").addDocument(data: [
                            "user": user,
                            "id": self.id,
                            "title": self.ident,
                            "price": self.price,
                            "description": self.detail,
                            "image": self.image,
                            "category": self.category,
                            "date": Date().timeIntervalSince1970
                        ]) {(error) in
                            if let e = error {
                                print(e.localizedDescription)
                            }else {
                                print("added favorites")
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    //MARK: - Store bucket data firebase
    @IBAction func addBucketPressed(_ sender: UIButton) {
        
        if let user = Auth.auth().currentUser?.email {
            db.collection("Sepet").whereField("title", isEqualTo: ident).whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
                if let e = error{
                    print(e.localizedDescription)
                }else if snapshot?.isEmpty == true {
                    self.db.collection("Sepet").addDocument(data: [
                        "user": user,
                        "id": self.id,
                        "title": self.ident,
                        "price": self.price,
                        "description": self.detail,
                        "image": self.image,
                        "category": self.category,
                        "adet": self.stepperValue,
                        "totalPara": Float(self.stepperValue) * self.price,
                        "date": Date().timeIntervalSince1970
                    ]) {(error) in
                        if let e = error {
                            print("There was an issue saving data to firestore \(e.localizedDescription)")
                        }else{
                            print("Succsess saving data!")
                        }
                        
                    }
                    
                }else {
                    let document = snapshot?.documents.first
                    document?.reference.updateData([
                        "adet": self.stepperValue,
                        "totalPara": Float(self.stepperValue) * self.price
                    ])
                    print("Update Edildi")
                }
            }
        }
    }
}
