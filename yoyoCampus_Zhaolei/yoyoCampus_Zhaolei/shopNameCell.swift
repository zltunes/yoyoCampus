//
//  shopNameCell.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/24.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class shopNameCell: UITableViewCell {

    @IBOutlet var shopNameLabel: UILabel!
    
    @IBOutlet var shopImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shopImage.layer.cornerRadius = shopImage.frame.width/2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
