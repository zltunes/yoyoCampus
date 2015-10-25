//
//  myRemarkCell.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/24.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class myRemarkCell: UITableViewCell {

    @IBOutlet var photoImgView: UIImageView!
    
    @IBOutlet var label_name: UILabel!
    
    @IBOutlet var label_remarkTime: UILabel!
    
    @IBOutlet var label_remark: UILabel!
    
    @IBOutlet var label_likeCount: UILabel!
    
    @IBOutlet var star1: UIImageView!
    
    @IBOutlet var star2: UIImageView!
    
    @IBOutlet var star3: UIImageView!
    
    @IBOutlet var star4: UIImageView!
    
    @IBOutlet var star5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStars(startCount:Int){
        switch(startCount){
        case 1:
            self.star1.image = UIImage(named: "star_light")
            break
        case 2:
            self.star1.image = UIImage(named: "star_light")
            self.star2.image = UIImage(named: "star_light")
            break
        case 3:
            self.star1.image = UIImage(named: "star_light")
            self.star2.image = UIImage(named: "star_light")
            self.star3.image = UIImage(named: "star_light")
            break
        case 4:
            self.star1.image = UIImage(named: "star_light")
            self.star2.image = UIImage(named: "star_light")
            self.star3.image = UIImage(named: "star_light")
            self.star4.image = UIImage(named: "star_light")
            break
        case 5:
            self.star1.image = UIImage(named: "star_light")
            self.star2.image = UIImage(named: "star_light")
            self.star3.image = UIImage(named: "star_light")
            self.star4.image = UIImage(named: "star_light")
            self.star5.image = UIImage(named: "star_light")
            break
        default:
            break
        }
    }
}
