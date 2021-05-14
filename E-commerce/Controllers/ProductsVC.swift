//
//  ProductsViewController.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 29.04.2021.
//

import UIKit
import SDWebImage
import Firebase

class ProductsVC: UIViewController{
    
    let adress = PersonalVC()
    let productDetails = ProductDetailsVC()
    let productManager = ProductManager()
    var productArray = [Products]()
//    var cartTotal = [Any]()
    var loading = true
    
    @IBOutlet var cart: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var adresLabel: UILabel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        let anonFunc = { (fetchedProductList: [Products]) in
            self.productArray = fetchedProductList
            self.loading = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        productManager.fetchProduct(onCompletion: anonFunc)
    }
    
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
//        do{
//            try Auth.auth().signOut()
//            navigationController?.popToRootViewController(animated: true)
//            print("Log out")
//            
//        }catch let signOutError as NSError{
//            print("Error signing out: %@", signOutError)
//        }
//        
    }
    
    
}
//MARK: - Tableview handling
extension ProductsVC:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading{
            return 1
        }else {
            return productArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.selectionStyle = .none
        if loading {
            cell.label.text = "Loading..."
        }else {
            let product = productArray[indexPath.row]
            cell.label.text = product.title
            cell.productImageView.sd_setImage(with: URL(string: product.image), placeholderImage: UIImage(named: "none"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detailsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProductDetailsVC{
//
//            print(tableView.indexPathForSelectedRow!)
//            print(productArray[tableView.indexPathForSelectedRow!.row])
            
            destination.ident = productArray[tableView.indexPathForSelectedRow!.row].title
            destination.image = productArray[tableView.indexPathForSelectedRow!.row].image
            destination.category = productArray[tableView.indexPathForSelectedRow!.row].category
            destination.detail = productArray[tableView.indexPathForSelectedRow!.row].description
            destination.price = productArray[tableView.indexPathForSelectedRow!.row].price
            destination.detailedView.append(productArray[tableView.indexPathForSelectedRow!.row])
            destination.id = productArray[tableView.indexPathForSelectedRow!.row].id
            
                
        }
    }
}










