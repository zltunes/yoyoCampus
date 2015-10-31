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
    
    internal var starsCount:Int = 0
    
    internal var hasLike:Bool = false
    
    internal var likeCount:Int = 0
    
    internal var commentID:String = ""

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
            self.star1.image = UIImage(named: "xiangqing_icon_star2")
            self.star2.image = UIImage(named: "xiangqing_icon_star")
            self.star3.image = UIImage(named: "xiangqing_icon_star")
            self.star4.image = UIImage(named: "xiangqing_icon_star")
            self.star5.image = UIImage(named: "xiangqing_icon_star")
            break
        case 2:
            self.star1.image = UIImage(named: "xiangqing_icon_star2")
            self.star2.image = UIImage(named: "xiangqing_icon_star2")
            self.star3.image = UIImage(named: "xiangqing_icon_star")
            self.star4.image = UIImage(named: "xiangqing_icon_star")
            self.star5.image = UIImage(named: "xiangqing_icon_star")
            break
        case 3:
            self.star1.image = UIImage(named: "xiangqing_icon_star2")
            self.star2.image = UIImage(named: "xiangqing_icon_star2")
            self.star3.image = UIImage(named: "xiangqing_icon_star2")
            self.star4.image = UIImage(named: "xiangqing_icon_star")
            self.star5.image = UIImage(named: "xiangqing_icon_star")
            break
        case 4:
            self.star1.image = UIImage(named: "xiangqing_icon_star2")
            self.star2.image = UIImage(named: "xiangqing_icon_star2")
            self.star3.image = UIImage(named: "xiangqing_icon_star2")
            self.star4.image = UIImage(named: "xiangqing_icon_star2")
            self.star5.image = UIImage(named: "xiangqing_icon_star")
            break
        case 5:
            self.star1.image = UIImage(named: "xiangqing_icon_star2")
            self.star2.image = UIImage(named: "xiangqing_icon_star2")
            self.star3.image = UIImage(named: "xiangqing_icon_star2")
            self.star4.image = UIImage(named: "xiangqing_icon_star2")
            self.star5.image = UIImage(named: "xiangqing_icon_star2")
            break
        default:
            break
        }
    }
}
