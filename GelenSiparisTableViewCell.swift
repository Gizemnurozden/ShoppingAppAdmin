//
//  GelenSiparisTableViewCell.swift
//  ShoppingAppAdmin
//
//  Created by Gizemnur Özden on 2.07.2024.
//

import UIKit

class GelenSiparisTableViewCell: UITableViewCell {

  
    @IBOutlet weak var odemeAlinmistirLabel: UILabel!
    @IBOutlet weak var hucreArkaPlan: UIView!
    @IBOutlet weak var musteriMaili: UILabel!
    @IBOutlet weak var musteriAdres: UILabel!
    @IBOutlet weak var siparisTarihi: UILabel!
    @IBOutlet weak var urunAdi: UILabel!
    @IBOutlet weak var urunBedeni: UILabel!
    @IBOutlet weak var urunAdeti: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
