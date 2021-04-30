//
//  ProductsViewController.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 29.04.2021.
//

import UIKit
import SDWebImage

class ProductsViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    
    
        
    var images: [ProductsScratch] = [
        ProductsScratch(image: #imageLiteral(resourceName: "goktug")),
        ProductsScratch(image: #imageLiteral(resourceName: "goktug")),
        ProductsScratch(image: #imageLiteral(resourceName: "goktug")),
        ProductsScratch(image: #imageLiteral(resourceName: "goktug"))
    ]
    
    
    var productsManager = ProductManager()
    //var products = Products()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        productsManager.allData()
    }


}

extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseIdentifier", for: indexPath)
        
        cell.imageView?.sd_setImage(with: URL(string: "https://fakestoreapi.com/img/61pHAEJ4NML._AC_UX679_.jpg"), placeholderImage: UIImage(named: "goktug") )
        return cell
    }
    
    
}
