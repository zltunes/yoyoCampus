//
//  twoLabelCell.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/27.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class twoLabelCell: UITableViewCell {

    @IBOutlet var oldPriceLabel: UILabel!
    
    @IBOutlet var presentPriceLabel: UILabel!
    
    @IBOutlet var leftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
