//
//  CurrencyTableViewCell.swift
//  test_blackstone_app
//
//  Created by Ragy Bahgat on 12/18/20.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var currency: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(currencyModel: CurrencyModel) {
        city.text = currencyModel.city
        currency.text = "\(currencyModel.currency)"
    }
    
}
