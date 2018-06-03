//
//  RestaurantDetailTableViewCell.swift
//  FoodPin
//
//  Created by Ron Yi on 2018/5/6.
//  Copyright © 2018年 Ron Yi. All rights reserved.
//

import UIKit

class RestaurantDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
