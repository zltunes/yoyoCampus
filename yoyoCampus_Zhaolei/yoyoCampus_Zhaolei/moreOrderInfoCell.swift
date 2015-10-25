//
//  moreOrderInfoCell.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/24.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class moreOrderInfoCell: UITableViewCell {

    @IBOutlet var label_orderNo: UILabel!
    
    @IBOutlet var label_time: UILabel!
    
    @IBOutlet var label_phone_num: UILabel!
    
    @IBOutlet var label_campus: UILabel!
    
    @IBOutlet var label_coupon: UILabel!
    
    @IBOutlet var label_remarks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
