//
//  FavorilerVC.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 17.05.2021.
//

import UIKit
import Firebase
import SDWebImage

class FavoritesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var favorites = [Favorites]()
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(false)
        self.favorites = []
        let anonFunc = {(fetchedFavorites: [Favorites]) in
            
            self.favorites = fetchedFavorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        loadDB(onCompletion: anonFunc)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        
    }
    
    func loadDB(onCompletion: @escaping ([Favorites]) -> ()){
        if let user = Auth.auth().currentUser?.email{
            db.collection("Favoriler").order(by: "date").whereField("user", isEqualTo: user).getDocuments { (snapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                }else {
                    guard let snap = snapshot else {return}
                    for document in snap.documents{
                        let data = document.data()
                        let title = data["title"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        let category = data["category"] as? String ?? ""
                        let id = data["id"] as? Int ?? 0
                        let image = data["image"] as? String ?? ""
                        let price = data["price"] as? Float ?? 0
                        let product = Favorites(category: category, description: description, id: id, image: image, price: price, title: title)
                        self.favorites.append(product)
                    }
                    onCompletion(self.favorites)
                }
            }
        }
    }

}

extension FavoritesVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let product = favorites[indexPath.row]
        cell.productImageView.sd_setImage(with: URL(string: product.image), placeholderImage: UIImage(named: "none") )
        cell.label.text = product.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let product = favorites[indexPath.row].title
        let user = Auth.auth().currentUser?.email
        if editingStyle == .delete{
            self.db.collection("Favoriler").whereField("user", isEqualTo: user!).whereField("title", isEqualTo: product).getDocuments { (snapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                }else {
                    guard let snap = snapshot else {return}
                    
                    for document in snap.documents{
                        document.reference.delete()
                    }
                }
            }
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
