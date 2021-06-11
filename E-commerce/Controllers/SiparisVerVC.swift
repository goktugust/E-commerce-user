//
//  SiparisVerVC.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 16.05.2021.
//

import UIKit
import Firebase

class SiparisVerVC: UIViewController, UITextViewDelegate {
    
    var sepetTotal = ""
    let db = Firestore.firestore()
    var sepet = [Bucket]()
    var seciliAdres = [SeciliAdres]()
    var okBucket = [GivenOrderDetailsFromFirestore]()
    var siparisIdFromUser = Int()
    
    @IBOutlet weak var nakitKrediLabel: UILabel!
    @IBOutlet weak var finishBucket: UIButton!
    @IBOutlet weak var cardPaymentMethod: UIButton!
    @IBOutlet weak var bucketTotal: UILabel!
    @IBOutlet weak var sepetTutar: UILabel!
    @IBOutlet weak var nakitPaymentMethod: UIButton!
    @IBOutlet weak var notField: UITextView!
    @IBOutlet weak var adresLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        getSelectedAdressFromFirestore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adresLabel.sizeToFit()
        
        notField.delegate = self
        
        let amountOfLinesToBeShown: CGFloat = 6
        let maxHeight: CGFloat = notField.font!.lineHeight * amountOfLinesToBeShown
        notField.sizeThatFits(CGSize(width: notField.frame.size.width, height: maxHeight))
        
        notField.text = "Eklemek İstediğiniz Notu Yazın!"
        notField.textColor = UIColor.lightGray
        
        notField.backgroundColor = .clear
        notField.layer.cornerRadius = 5
        notField.layer.borderWidth = 1
        notField.layer.borderColor = UIColor.black.cgColor
        
        
        sepetTutar.text = sepetTotal
        bucketTotal.text = sepetTotal
        
    }
    
   //MARK: - Textview functions
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "Roboto-Regular", size: 17)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Eklemek İstediğiniz Notu Yazın!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    //MARK: - Buttons with functions
    @IBAction func siparisVerPressed(_ sender: UIButton) {
        sepet = []
        if let nakitOrKredi = nakitKrediLabel.text{
            if nakitOrKredi == "Kapıda Kredi Kartı İle Ödeme" || nakitOrKredi == "Kapıda Nakit Ödeme" {
                
                let anonyFunc = {(fetchedSiparisId: Int) in
                    self.siparisIdFromUser = fetchedSiparisId
                    let anonFunc = { (fetchedProductList: [Bucket]) in
                        self.sepet = fetchedProductList
                        self.db.collection("Siparisler").addDocument(data: [
                            "user": Auth.auth().currentUser!.email!,
                            "status": "Hazırlanıyor",
                            "payment": self.nakitKrediLabel.text!,
                            "adres": self.adresLabel.text!,
                            "siparisNotu": self.notField.text!,
                            "totalPara": self.sepetTutar.text!,
                            "time": Date().timeIntervalSince1970,
                            "siparisId": fetchedSiparisId,
                            "kurye": "Henüz Kurye Atanmadı"
                        ]){(error)in
                            if let e = error {
                                print(e.localizedDescription)
                            }else {
                                print("success")
                            }
                        }
                    }
                    self.loadBucketDbForOrderHandling(onCompletion: anonFunc)
                    self.getBucketDbAddOnayDb()
                    self.deleteBucket()
                    
                }
                getSiparisId(onCompletion: anonyFunc)
                
            }else {
                let alert = UIAlertController(title: "Hata!", message: "Bir ödeme yöntemi seçin", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func nakitPressed(_ sender: UIButton) {
        nakitKrediLabel.text = "Kapıda Nakit Ödeme"
    }
    @IBAction func krediPressed(_ sender: UIButton) {
        nakitKrediLabel.text = "Kapıda Kredi Kartı İle Ödeme"
    }
    
    //MARK: - Getting adress data from firestore and show the user his/her selected adress on the screen.
    func loadAdres(onCompletion: @escaping ([SeciliAdres]) -> ()){
        let email = Auth.auth().currentUser?.email
        db.collection("Seçili Adres").document("Email").collection(email!).getDocuments { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }else{
                guard let snap = snapshot else {return}
                
                for document in snap.documents{
                    let data = document.data()
                    let adresName = data["seciliAdresAdi"] as? String ?? ""
                    let adresLocation = data["seciliAdres"] as? String ?? ""
                    let adres = SeciliAdres(seciliAdres: adresLocation, seciliAdresAdi: adresName)
                    self.seciliAdres.append(adres)
                }
                onCompletion(self.seciliAdres)
            }
        }
    }
    func getSelectedAdressFromFirestore(){
        seciliAdres = []
        let anonFunc = {(fetchedSeciliAdres: [SeciliAdres]) in
            if fetchedSeciliAdres.count == 0{
                self.adresLabel.text = "Bir adres seçin veya ekleyin!"
            }else {
                self.seciliAdres = fetchedSeciliAdres
                self.adresLabel.text = self.seciliAdres[0].seciliAdres
            }
            
        }
        loadAdres(onCompletion: anonFunc)
    }
    
    //MARK: - getting bucket data, add bucket data to OnaylanmışSiparişler Firestore when Button clicked
    func loadBucketDbForOrderHandling(onCompletion: @escaping ([Bucket]) -> ()){
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
                            self.sepet.append(product)
                        }
                        onCompletion(self.sepet)
                    }
                }
        }
    }
    
    func getBucketDbAddOnayDb(){
        if let mail = Auth.auth().currentUser?.email{
            db.collection("Sepet").whereField("user", isEqualTo: mail).getDocuments { (snapshot, error) in
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
                        let user = data["user"] as? String ?? mail
                        let product = GivenOrderDetailsFromFirestore(adet: adet, category: category, description: description, id: id, image: image, price: price, title: title, totalPara: totalPara, user: user)
                        self.okBucket.append(product)
                        
                    }
                    self.addProdOnayFirestore(self.okBucket)
                }
            }
        }
    }
    
    func addProdOnayFirestore(_ products: [GivenOrderDetailsFromFirestore]){
        let gettingSiparisId = {(fetchedSiparisId: Int)in
            self.siparisIdFromUser = fetchedSiparisId
            for product in products{
                self.db.collection("OnaylanmışSiparişler").addDocument(data: [
                    "user": product.user,
                    "id": product.id,
                    "title": product.title,
                    "price": product.price,
                    "description": product.description,
                    "image": product.image,
                    "category": product.category,
                    "adet": product.adet,
                    "totalPara": product.totalPara,
                    "siparisId": fetchedSiparisId
                ]){(error) in
                    if let e = error {
                        print("There was an issue saving data to firestore\(e.localizedDescription)")
                    }else {
                        print("Success saving onaylanmış sipariş")
                    }
                }
            }
        }
        getSiparisId(onCompletion: gettingSiparisId)
        self.updateSiparisId()
       
    }
    

    //MARK: - Delete current users bucket data from firestore
    func deleteBucket(){
        let user = Auth.auth().currentUser?.email
        db.collection("Sepet").whereField("user", isEqualTo: user!).getDocuments { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }else {
                guard let snap = snapshot else {return}
                
                for document in snap.documents{
                    document.reference.delete()
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    
    //MARK: - Get siparisId form firestore(Kullanıcılar, currentUser.email)
    func getSiparisId(onCompletion: @escaping (Int) -> ()){
        let email = Auth.auth().currentUser?.email
        db.collection("Kullanıcılar").document("Email").collection(email!).getDocuments { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
                
            }else {
                guard let snap = snapshot else {return}
                for document in snap.documents{
                    let data = document.data()
                    let siparisId = data["siparisId"] as? Int ?? 0
                    self.siparisIdFromUser = siparisId
                }
                
            }
            
            onCompletion(self.siparisIdFromUser)
        }
        
    }
    

    //MARK: - Update siparisId
    func updateSiparisId(){
        let email = Auth.auth().currentUser?.email
        db.collection("Kullanıcılar").document("Email").collection(email!).getDocuments { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            }else {
                guard let snap = snapshot else {return}
                
                let document = snap.documents.first
                let data = document?.data()
                let id = data?["siparisId"] as? Int ?? 0
                document?.reference.updateData([
                    "siparisId": id + 1
                ])
            }
        }
    }
}



