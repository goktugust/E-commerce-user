//
//  SepetCell.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 9.05.2021.
//

import UIKit

class SepetCell: UITableViewCell {



    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    @IBOutlet weak var moneyView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleView.layer.cornerRadius = titleView.frame.size.height / 2
        moneyView.layer.cornerRadius = moneyView.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
