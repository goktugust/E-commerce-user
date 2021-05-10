//
//  AnanVC.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 6.05.2021.
//

import UIKit
import Firebase
import SDWebImage

class BucketVC: UIViewController {
    
    var sepet = [Bucket]()
    var tutar = [Float]()
    let db = Firestore.firestore()
    
    @IBOutlet weak var silBtn: UIButton!
    @IBOutlet weak var onayBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sepetTutarı: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        sepetTutarı.text = "$0"
        onayBtn.backgroundColor = .clear
        onayBtn.layer.cornerRadius = 5
        onayBtn.layer.borderWidth = 1
        onayBtn.layer.borderColor = UIColor.black.cgColor
        
        silBtn.backgroundColor = .clear
        silBtn.layer.cornerRadius = 5
        silBtn.layer.borderWidth = 1
        silBtn.layer.borderColor = UIColor.black.cgColor
        
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SepetCell", bundle: nil), forCellReuseIdentifier: "sepetCell")
        
        let anonFunc = { (fetchedProductList: [Bucket]) in
            self.sepet = fetchedProductList
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
            
        }
        loadDB(onCompletion: anonFunc)
    }
    
    @IBAction func silPressed(_ sender: UIButton) {
        let mail = Auth.auth().currentUser?.email
        db.collection("Sepet")
            .whereField("user", isEqualTo: mail!)
            .getDocuments { (snapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                }else {
                    guard let snap = snapshot else {return}
                    for document in snap.documents {
                        document.reference.delete()
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                self.viewDidLoad()
            }
    }
    
    @IBAction func onaylaPressed(_ sender: UIButton) {
    }
    
    //MARK: - Fetch data from firebase
    func loadDB(onCompletion: @escaping ([Bucket]) -> ()){
        let mail = Auth.auth().currentUser?.email
        db.collection("Sepet")
            .order(by: "date")
            .whereField("user", isEqualTo: mail!)
            .getDocuments { (snapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                }else {
                    guard let snap = snapshot else {return}
                    
                    for document in snap.documents {
                        let data = document.data()
                        let title = data["title"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        let category = data["category"] as? String ?? ""
                        let id = data["id"] as? Int ?? 0
                        let image = data["image"] as? String ?? ""
                        let price = data["price"] as? Float ?? 0
                        let adet = data["adet"] as? Int ?? 1
                        let totalPara = data["totalPara"] as? Float ?? 0
                        let product = Bucket(adet: adet, category: category, description: description, id: id, image: image, price: price, title: title, totalPara: totalPara)
                        self.sepet.append(product)
                        
                    }
                    
                    onCompletion(self.sepet)
                }
                
            }
    }
}
//MARK: - Tableview handling
extension BucketVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sepetCell", for: indexPath) as! SepetCell
        let product = sepet[indexPath.row]
        cell.productImage.sd_setImage(with: URL(string: product.image), placeholderImage: UIImage(named: "none") )
        cell.adetLabel.text = "Adet: \(String(sepet[indexPath.row].adet))"
        cell.totalLabel.text = "Fiyat: $\(String(sepet[indexPath.row].totalPara))"
        cell.titleLabel.text = sepet[indexPath.row].title
        tutar.append(sepet[indexPath.row].totalPara)
        if self.sepet.count == tutar.count{
            let total = tutar.reduce(0, +)
            sepetTutarı.text = "$\(String(total))"
        }
        
        return cell
    }
    
    
}
