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

    @IBOutlet weak var sepeteEkle: UIButton!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var detailsText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var addProductNumber: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //categoryText.text = category
        detailsText.text = detail
        titleText.text = ident
        priceText.text = "$\(price)"
        productImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "none"))
        
        
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        stepperValue = Int(sender.value)
        addProductNumber.text = String(stepperValue)
        
    }
    
    
    //MARK: - Store bucket data firebase
    @IBAction func addBucketPressed(_ sender: UIButton) {
        
        if let user = Auth.auth().currentUser?.email{
            db.collection("Sepet").addDocument(data: [
                "user": user,
                "id": id,
                "title": ident,
                "price": price,
                "description": detail,
                "image": image,
                "category": category,
                "adet": stepperValue,
                "totalPara": Float(stepperValue) * price,
                "date": Date().timeIntervalSince1970
            ]) {(error) in
                if let e = error {
                    print("There was an issue saving data to firestore \(e.localizedDescription)")
                }else{
                    print("Succsess saving data!")
                }
                
            }
        }
    }
}
