//
//  remarkCell.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/6.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class remarkCell: UITableViewCell {

    @IBOutlet var photo: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var likeImgView: UIImageView!
    
    @IBOutlet var likeCountLabel: UILabel!
    
    @IBOutlet var remarkLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
