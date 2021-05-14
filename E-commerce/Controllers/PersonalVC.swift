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
    
    let db = Firestore.firestore()
    var person = [User]()
    var adresss = [Adress]()
    
    @IBOutlet weak var signOutBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var adresEkleBtn: UIButton!
    @IBOutlet weak var mailText: UILabel!
    @IBOutlet weak var nameText: UILabel!
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
        
        
        
        
        let anonFunc = {(fetchedPersonInfo: [User]) in
            self.person = fetchedPersonInfo
            self.nameText.text = self.person[0].name
            self.mailText.text = self.person[0].mail
        }

        loadNameAndMail(onCompletion: anonFunc)
        
        let anonyFuntion = {(fetchedAdresInfo: [Adress]) in
            self.adresss = fetchedAdresInfo
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        loadAdress(onCompletion: anonyFuntion)
    }
    @IBAction func signOutPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Dikkat!", message: "Çıkış yapmak istediğine emin misin?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Evet", style: UIAlertAction.Style.cancel, handler: { (action) in
            do{
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
                print("Log out")
                
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
                        print(user)
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
                        print(user)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let adres = adresss[tableView.indexPathForSelectedRow!.row].adres
        print(adres)
        
        
        
        navigationController?.popViewController(animated: true)
        
        
    }
   
    
}
