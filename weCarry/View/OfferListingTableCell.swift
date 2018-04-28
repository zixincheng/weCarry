//
//  OfferListingTableCell.swift
//  weCarry
//
//  Created by zixin cheng on 2/7/18.
//  Copyright © 2018 zixin cheng. All rights reserved.
//

import UIKit

class OfferListingTableCell: UITableViewCell {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromCityLabel: UILabel!
    @IBOutlet weak var toCityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weightLimitLabel: UILabel!
    @IBOutlet weak var serviceLabel1: UILabel!
    @IBOutlet weak var serviceLabel2: UILabel!
    @IBOutlet weak var serviceLabel3: UILabel!
    @IBOutlet weak var packageLabel1: UILabel!
    @IBOutlet weak var packageLabel2: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
