//
//  TCustomCell.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 2.05.2021.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detailsView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsView.layer.cornerRadius = detailsView.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
