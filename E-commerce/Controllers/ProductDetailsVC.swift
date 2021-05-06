//
//  ProductDetailsVC.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 4.05.2021.
//

import UIKit
import SDWebImage
class ProductDetailsVC: UIViewController {
    
    var category = ""
    var detail = ""
    var price: Float = 0
    var ident = ""
    var image = ""

    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var detailsText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //categoryText.text = category
        detailsText.text = detail
        titleText.text = ident
        priceText.text = "$\(price)"
        productImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "none"))
        
        
    }
}
