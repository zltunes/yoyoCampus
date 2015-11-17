//
//  SearchGoodsCell.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/11/16.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class SearchGoodsCell: UITableViewCell {

    @IBOutlet var label_goodsName: UILabel!
    
    @IBOutlet var label_price: UILabel!
    
    @IBOutlet var label_shopName: UILabel!
    
    @IBOutlet var label_hui: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
