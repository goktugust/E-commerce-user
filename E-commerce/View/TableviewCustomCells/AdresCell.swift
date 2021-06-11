//
//  AdresCell.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 13.05.2021.
//

import UIKit

class AdresCell: UITableViewCell {



    @IBOutlet weak var adresTarifi: UILabel!
    @IBOutlet weak var adresAdi: UILabel!
    @IBOutlet weak var adresView: UIView!
    @IBOutlet weak var home: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
