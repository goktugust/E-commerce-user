//
//  OldOrdersVC.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 8.06.2021.
//

import UIKit
import Firebase

class OldOrdersVC: UIViewController {
    
    let db = Firestore.firestore()
    
    var fetchedGivenOrders = [GivenOrderFromFirestore]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        givenOrdesDB()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "AdresCell", bundle: nil), forCellReuseIdentifier: "adresCell")

        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func loadOldOrdersFromDB(onCompletion: @escaping ([GivenOrderFromFirestore]) -> ()){
        let user = Auth.auth().currentUser?.email
        db.collection("Siparisler").whereField("user", isEqualTo: user!).whereField("status", isEqualTo: "Sipariş Teslim Edildi").order(by: "siparisId", descending: true).getDocuments { (snapshot, error) in
            if let e =  error {
                print(e.localizedDescription)
            }else {
                guard let snap = snapshot else {return}
                
                for document in snap.documents{
                    let data = document.data()
                    let totalPara = data["totalPara"] as! String
                    let user = data["user"] as! String
                    let payment = data["payment"] as! String
                    let status = data["status"] as! String
                    let adres = data["adres"] as! String
                    let siparisNotu = data["siparisNotu"] as? String ?? ""
                    let siparisId = data["siparisId"] as! Int
                    let kuryeAdi = data["kurye"] as? String ?? "Henüz Kurye Atanmadı"
                    let currentUserOldOrder = GivenOrderFromFirestore(user: user, status: status, payment: payment, adres: adres, totalPara: totalPara, siparisNotu: siparisNotu, siparisId: siparisId, kurye: kuryeAdi)
                    self.fetchedGivenOrders.append(currentUserOldOrder)
                }
                onCompletion(self.fetchedGivenOrders)
            }
        }
    }
    func givenOrdesDB(){
        self.fetchedGivenOrders = []
        let anonFunc = {(fetchedList: [GivenOrderFromFirestore]) in
            self.fetchedGivenOrders = fetchedList
                DispatchQueue.main.async {
                    self.tableView.reloadData()
            }
        }
        loadOldOrdersFromDB(onCompletion: anonFunc)
    }
    
    

}


extension OldOrdersVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedGivenOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adresCell", for: indexPath) as! AdresCell
        let siparis = fetchedGivenOrders[indexPath.row]
        cell.adresAdi.text = "\(siparis.totalPara)"
        cell.adresTarifi.text = siparis.adres
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "oldOrderDetailSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OrderDetailsVC{
            
            destination.label1 = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].adres
            destination.label2 = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].totalPara
            destination.label3 = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].payment
            destination.siparisId = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].siparisId
            destination.label4 = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].siparisNotu
            destination.label5 = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].kurye
            destination.label6 = fetchedGivenOrders[tableView.indexPathForSelectedRow!.row].status
        }
    }
    
    
    
}
