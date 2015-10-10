//
//  shopRemarkCell.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/7.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class shopRemarkCell: UITableViewCell {

    @IBOutlet var photo: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var remarkLabel: UILabel!
    
    @IBOutlet var likeBtn: UIButton!
    
    @IBOutlet var likeCountLabel: UILabel!
    
    @IBOutlet var star1: UIImageView!
    
    @IBOutlet var star2: UIImageView!
    
    @IBOutlet var star3: UIImageView!
    
    @IBOutlet var star4: UIImageView!
    
    @IBOutlet var star5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Consts.grayView
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
