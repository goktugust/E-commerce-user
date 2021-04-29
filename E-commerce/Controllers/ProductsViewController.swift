//
//  ProductsViewController.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 29.04.2021.
//

import UIKit

class ProductsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reuseCell: UITableViewCell!
    
    
    var productsManager = ProductManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productsManager.allData()
    }


}
