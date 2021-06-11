//
//  ActiveOrderVC.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 3.06.2021.
//

import UIKit
import Firebase

class OrderDetailsVC: UIViewController {

    let db = Firestore.firestore()
    var siparisId = Int()
    var label1 = ""
    var label2 = ""
    var label3 = ""
    var label4 = ""
    var label5 = ""
    var label6 = ""
    var fetchedOrdersDetailsData = [GivenOrderDetailsFromFirestore]()
    
    
    @IBOutlet weak var labelSix: UILabel!
    @IBOutlet weak var labelFive: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        orderDetails()
        labelFive.text = label5
        labelSix.text = label6
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        tableView.register(UINib(nibName: "SepetCell", bundle: nil), forCellReuseIdentifier: "sepetCell")
        
        tableView.dataSource = self
        
        labelOne.text = label1
        labelTwo.text = label2
        labelThree.text = label3
        labelFour.text = label4
        
        
    }
    
    func loadDB(onCompletion: @escaping ([GivenOrderDetailsFromFirestore]) -> ()){
        let user = Auth.auth().currentUser?.email
        db.collection("OnaylanmışSiparişler").whereField("siparisId", isEqualTo: siparisId).whereField("user", isEqualTo: user!).getDocuments { (snapshot, error) in
            if let e =  error {
                print(e.localizedDescription)
            }else {
                guard let snap = snapshot else {return}
                for document in snap.documents{
                    let data = document.data()
                    let user = data["user"] as? String ?? ""
                    let id = data["id"] as? Int ?? 0
                    let title = data["title"] as? String ?? ""
                    let price = data["price"] as? Float ?? 0
                    let description = data["description"] as? String ?? ""
                    let image = data["image"] as? String ?? ""
                    let category = data["category"] as? String ?? ""
                    let adet = data["adet"] as? Int ?? 1
                    let totalPara = data["totalPara"] as? Float ?? 0
                    let product = GivenOrderDetailsFromFirestore(adet: adet, category: category, description: description, id: id, image: image, price: price, title: title, totalPara: totalPara, user: user)
                    self.fetchedOrdersDetailsData.append(product)
                }
                onCompletion(self.fetchedOrdersDetailsData)
            }
        }
    }
    
    func orderDetails(){
        let anonFunc = {(fetchedProducts: [GivenOrderDetailsFromFirestore])in
            self.fetchedOrdersDetailsData = []
            self.fetchedOrdersDetailsData = fetchedProducts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        loadDB(onCompletion: anonFunc)
    }
    
}


extension OrderDetailsVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedOrdersDetailsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sepetCell", for: indexPath) as! SepetCell
        let product = fetchedOrdersDetailsData[indexPath.row]
        cell.adetLabel.text = "Adet: \(product.adet)"
        cell.productImage.sd_setImage(with: URL(string: "\(product.image)"), placeholderImage: UIImage(named: "none"))
        cell.titleLabel.text = product.title
        cell.totalLabel.text = "Fiyat: $\(product.totalPara)"
        return cell
    }
    
    
}
