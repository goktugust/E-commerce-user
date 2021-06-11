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
    
    var bucket = [Bucket]()
    var bucketTotal = [Float]()
    let db = Firestore.firestore()
    
    @IBOutlet weak var onayBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sepetTutarı: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(false)
        /*Bu kısımda eğer siparişler bölümünde current userın bir siparişi var ise yeni sipariş verememesi için
            sipariş ver butonunun disabled yapılması gerekiyor!
         */
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onayBtn.isEnabled = false
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        sepetTutarı.text = "$0"
        onayBtn.backgroundColor = .clear
        onayBtn.layer.cornerRadius = 5
        onayBtn.layer.borderWidth = 1
        onayBtn.layer.borderColor = UIColor.black.cgColor
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SepetCell", bundle: nil), forCellReuseIdentifier: "sepetCell")
        
        getBucketFromFirestore()
    }
    
    func getBucketFromFirestore(){
        let anonFunc = { (fetchedProductList: [Bucket]) in
            self.bucket = fetchedProductList
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        loadDB(onCompletion: anonFunc)
    }
    
    @IBAction func emptyBucket(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Sepet", message: "Ürünleri boşaltmak istediğinize emin misiniz?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Evet", style: UIAlertAction.Style.destructive, handler: { (action) in
            let mail = Auth.auth().currentUser?.email
            self.db.collection("Sepet")
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
                        self.navigationController?.popViewController(animated: true)
                    }
                }
        }))
        alert.addAction(UIAlertAction(title: "Hayır", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func onaylaPressed(_ sender: UIButton) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sepet = sepetTutarı.text
        if segue.destination is SiparisVerVC{
            let vc = segue.destination as? SiparisVerVC
            vc?.sepetTotal = sepet!
        }
    }
    
    //MARK: - Fetch data from firebase
    func loadDB(onCompletion: @escaping ([Bucket]) -> ()){
        if let mail = Auth.auth().currentUser?.email{
            db.collection("Sepet")
                .order(by: "date")
                .whereField("user", isEqualTo: mail)
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
                            self.bucket.append(product)
                        }
                        onCompletion(self.bucket)
                    }
                }
        }
    }
}
//MARK: - Tableview handling
extension BucketVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sepetCell", for: indexPath) as! SepetCell
        let product = bucket[indexPath.row]
        cell.productImage.sd_setImage(with: URL(string: product.image), placeholderImage: UIImage(named: "none") )
        cell.adetLabel.text = "Adet: \(String(bucket[indexPath.row].adet))"
//        cell.totalLabel.text = "Fiyat: $\(String(sepet[indexPath.row].totalPara))"
        cell.totalLabel.text = String(format: "Fiyat: $%.2f", bucket[indexPath.row].totalPara)
        cell.titleLabel.text = bucket[indexPath.row].title
        bucketTotal.append(bucket[indexPath.row].totalPara)
        if self.bucket.count == bucketTotal.count{
            let total = bucketTotal.reduce(0, +)
            //sepetTutarı.text = "$\(String(total))"
            sepetTutarı.text = String(format: "$%.2f", total)
        }
        
        if self.bucket.count != 0{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.9109922051, blue: 0.577586472, alpha: 0.8470588235)
            onayBtn.isEnabled = true
            
        }
        
        return cell
    }
    
    //MARK: - Tableview cell delete function with firebase deleting bucket product content.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let product = bucket[indexPath.row].title
        let user = Auth.auth().currentUser?.email
        if editingStyle == .delete{
            self.db.collection("Sepet").whereField("user", isEqualTo: user!).whereField("title", isEqualTo: product).getDocuments { (snapshot, error) in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    guard let snap = snapshot else {return}
                    for document in snap.documents{
                        document.reference.delete()
                        //print("SİLİNDİ")
                    }
                }
            }
            bucket.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
