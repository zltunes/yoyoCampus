
//
//  OrderCell.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/22.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet var label_shopName: UILabel!
    
    @IBOutlet var label_orderStatus: UILabel!
    
    @IBOutlet var orderImg: UIImageView!
    
    @IBOutlet var label_productName: UILabel!
    
    @IBOutlet var label_totalPrice: UILabel!
    
    @IBOutlet var label_totalCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
