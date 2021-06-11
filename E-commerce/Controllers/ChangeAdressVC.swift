//
//  AdresSecVC.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 19.05.2021.
//

import UIKit
import Firebase
class ChangeAdressVC: UIViewController {

    var adresss = [Adress]()
    let db = Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        adresss = []
        let anonyFuntion = {(fetchedAdresInfo: [Adress]) in
            self.adresss = fetchedAdresInfo
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        loadAdress(onCompletion: anonyFuntion)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "AdresCell", bundle: nil), forCellReuseIdentifier: "adresCell")
        
    }
    @IBAction func xBtn(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func loadAdress(onCompletion: @escaping ([Adress]) -> ()){
        if let mail = Auth.auth().currentUser?.email{
            db.collection("Adresler").document("Email").collection(mail).getDocuments { (snapshot, error) in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    guard let snap = snapshot else {return}

                    for document in snap.documents{
                        let data = document.data()
                        let adres = data["adres"] as? String ?? ""
                        let adresAdi = data["adresAdi"] as? String ?? "Kayıtlı Adres"
                        let user = Adress(adres: adres, adresAdi: adresAdi)
                        self.adresss.append(user)
                        
                    }
                    onCompletion(self.adresss)
                }
            }
        }
    }

}

extension ChangeAdressVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adresss.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adresCell") as! AdresCell
        let adres = adresss[indexPath.row]
        cell.adresAdi.text = adres.adresAdi
        cell.adresTarifi.text = adres.adres
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let adres = adresss[tableView.indexPathForSelectedRow!.row].adres
         let adresAdi = adresss[tableView.indexPathForSelectedRow!.row].adresAdi
         let email = Auth.auth().currentUser?.email
         
         db.collection("Seçili Adres").document("Email").collection(email!).getDocuments { (snapshot, error) in
             if let e = error {
                 print(e.localizedDescription)
             }else if snapshot?.isEmpty == true {
                 self.db.collection("Seçili Adres").document("Email").collection(email!).addDocument(data: [
                     "seciliAdres": adres,
                     "seciliAdresAdi": adresAdi
                 ])
                self.navigationController?.popViewController(animated: true)
             }else {
                 let document = snapshot?.documents.first
                 document?.reference.updateData([
                     "seciliAdres": adres,
                     "seciliAdresAdi": adresAdi
                 ])
                self.navigationController?.popViewController(animated: true)
             }
         }
         
         
         
    }
    
    
}
