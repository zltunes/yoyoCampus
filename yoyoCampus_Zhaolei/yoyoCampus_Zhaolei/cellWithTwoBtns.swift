
//
//  cellWithTwoBtns.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/27.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class cellWithTwoBtns: UITableViewCell {

    @IBOutlet var minusBtn: UIButton!
    
    @IBOutlet var plusBnt: UIButton!
    
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var leftLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("cellWithTwoBtns")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
