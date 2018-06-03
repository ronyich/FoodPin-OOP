//
//  RestaurantTableViewCell.swift
//  FoodPin
//
//  Created by Ron Yi on 2018/4/23.
//  Copyright © 2018年 Ron Yi. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel:UILabel?
    @IBOutlet var locationLabel:UILabel?
    @IBOutlet var typeLabel:UILabel?
    @IBOutlet var thumbnailImageView:UIImageView?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
