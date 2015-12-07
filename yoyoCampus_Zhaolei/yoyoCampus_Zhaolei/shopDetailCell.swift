//
//  shopDetailCell.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/8.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class shopDetailCell: UITableViewCell {

    @IBOutlet var tagLabel: UILabel!
    
    @IBOutlet var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = Consts.grayView
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
