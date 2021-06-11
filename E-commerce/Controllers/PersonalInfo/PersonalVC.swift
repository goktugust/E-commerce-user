//
//  PersonalVC.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 12.05.2021.
//

import UIKit
import Firebase

class PersonalVC: UIViewController {
   
    @IBOutlet weak var bilgi: UINavigationItem!
    
    var fetchedGivenOrder = [GivenOrderFromFirestore]()
    let db = Firestore.firestore()
    var person = [User]()
    var adresss = [Adress]()
    
    @IBOutlet weak var showActiveOrder: UIButton!
    @IBOutlet weak var signOutBtn: UIButton!
    
    
    @IBOutlet weak var oldOrdersBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var adresEkleBtn: UIButton!
    @IBOutlet weak var mailText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    
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
        
        tableView.register(UINib(nibName: "AdresCell", bundle: nil), forCellReuseIdentifier: "adresCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        adresEkleBtn.contentHorizontalAlignment = .left
        adresEkleBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        adresEkleBtn.backgroundColor = .clear
        adresEkleBtn.layer.cornerRadius = 5
        adresEkleBtn.layer.borderWidth = 1
        adresEkleBtn.layer.borderColor = UIColor.black.cgColor
        
        showActiveOrder.contentHorizontalAlignment = .left
        showActiveOrder.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        showActiveOrder.backgroundColor = .clear
        showActiveOrder.layer.cornerRadius = 5
        showActiveOrder.layer.borderWidth = 1
        showActiveOrder.layer.borderColor = UIColor.black.cgColor
        
        oldOrdersBtn.contentHorizontalAlignment = .left
        oldOrdersBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        oldOrdersBtn.backgroundColor = .clear
        oldOrdersBtn.layer.cornerRadius = 5
        oldOrdersBtn.layer.borderWidth = 1
        oldOrdersBtn.layer.borderColor = UIColor.black.cgColor
        
        
        let anonFunc = {(fetchedPersonInfo: [User]) in
            self.person = fetchedPersonInfo
            self.nameText.text = self.person[0].name
            self.mailText.text = self.person[0].mail
        }

        loadNameAndMail(onCompletion: anonFunc)

    }
    
    
    @IBAction func showActiveOrderPressed(_ sender: UIButton) {
        givenOrderDB()
    }
    
    func loadDb(onCompletion: @escaping ([GivenOrderFromFirestore]) -> ()){
        let user = Auth.auth().currentUser?.email
        db.collection("Siparisler").whereField("status", isNotEqualTo: "Sipariş Teslim Edildi").whereField("user", isEqualTo: user!).getDocuments { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }else {
                guard let snap = snapshot else {return}
                
                
                for document in snap.documents {
                    let data = document.data()
                    let totalPara = data["totalPara"] as? String ?? ""
                    let user = data["user"] as? String ?? ""
                    let payment = data["payment"] as? String ?? ""
                    let status = data["status"] as? String ?? ""
                    let adres = data["adres"] as? String ?? ""
                    let siparisNotu = data["siparisNotu"] as? String ?? ""
                    let siparisId = data["siparisId"] as? Int ?? 0
                    let kuryeAdi = data["kurye"] as! String
                    let order = GivenOrderFromFirestore(user: user, status: status, payment: payment, adres: adres, totalPara: totalPara, siparisNotu: siparisNotu, siparisId: siparisId, kurye: kuryeAdi)
                    self.fetchedGivenOrder.append(order)
                }
                onCompletion(self.fetchedGivenOrder)
            }
        }
    }
    
    func givenOrderDB(){
        self.fetchedGivenOrder = []
        let anonFunc = {(fetchedOrder: [GivenOrderFromFirestore]) in
            
            self.fetchedGivenOrder = fetchedOrder
            if self.fetchedGivenOrder.isEmpty{
                
                let alert = UIAlertController(title: "Hata!", message: "Siparişiniz bulunmuyor!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else {
                self.performSegue(withIdentifier: "activeOrder", sender: nil)
            }
            
        }
        loadDb(onCompletion: anonFunc)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OrderDetailsVC {
            
            
            destination.label1 = fetchedGivenOrder[0].adres
            destination.label2 = fetchedGivenOrder[0].totalPara
            destination.label3 = fetchedGivenOrder[0].payment
            destination.siparisId = fetchedGivenOrder[0].siparisId
            destination.label4 = fetchedGivenOrder[0].siparisNotu
            destination.label5 = fetchedGivenOrder[0].kurye
            destination.label6 = fetchedGivenOrder[0].status
        }
    }
    @IBAction func signOutPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Dikkat!", message: "Çıkış yapmak istediğine emin misin?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Evet", style: UIAlertAction.Style.cancel, handler: { (action) in
            do{
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
                print("Log out")
                self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
                
            }catch let signOutError as NSError{
                print("Error signing out: %@", signOutError)
            }
        }))
        alert.addAction(UIAlertAction(title: "Hayır", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
       
        
    }
    
    func loadNameAndMail(onCompletion: @escaping ([User]) -> ()){
        if let mail = Auth.auth().currentUser?.email{
            db.collection("Kullanıcılar").document("Email").collection(mail).getDocuments { (snapshot, error) in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    guard let snap = snapshot else {return}
                    
                    for document in snap.documents{
                        let data = document.data()
                        let name = data["name"] as? String ?? ""
                        let mail = data["mail"] as? String ?? ""
                        let user = User(mail: mail, name: name)
                        self.person.append(user)
                        //print(user)
                    }
                    onCompletion(self.person)
                }
            }
        }
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
                        //print(user)
                    }
                    onCompletion(self.adresss)
                }
            }
        }
    }

}
//MARK: - Tableview handling

extension PersonalVC: UITableViewDataSource, UITableViewDelegate{

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

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let adres = adresss[indexPath.row].adres
        
        if editingStyle == .delete{
            let email = Auth.auth().currentUser?.email
            self.db.collection("Adresler").document("Email").collection(email!).whereField("adres", isEqualTo: adres).getDocuments { (snapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                }else {
                    guard let snap = snapshot else {return}
                    
                    for document in snap.documents{
                        document.reference.delete()
                    }
                }
            }
            adresss.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
