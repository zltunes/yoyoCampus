//
//  shopView.swift
//  YouYouSchool-iOS
//
//  Created by 浩然 on 15/9/24.
//  Copyright © 2015年 浩然. All rights reserved.
//

import UIKit

class shopView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nameLabel = UILabel(frame: CGRectMake(0, 0, windowWidth, 50*Consts.ratio))
        nameLabel.text = "       人气小店"
        nameLabel.font = UIFont(name: "Verdana", size: 15)
        self.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.userInteractionEnabled = true
        nameLabel.tag = 4
        
        let greenView = UIView(frame: CGRectMake(40 * Consts.ratio, 15 * Consts.ratio, 3, 15))
        greenView.backgroundColor = UIColor(red: 25/255, green: 180/255, blue: 160/255, alpha: 1)
        self.addSubview(greenView)
        
        let image1 = UIImageView(frame: CGRectMake(44*Consts.ratio, CGRectGetMaxY(nameLabel.frame)+20*Consts.ratio, 120*Consts.ratio,120*Consts.ratio))
        image1.image = UIImage(named: "shop_1")
        image1.layer.cornerRadius = 120*Consts.ratio/2
        self.addSubview(image1)
        
        let image2 = UIImageView(frame: CGRectMake(CGRectGetMaxX(image1.frame)+48*Consts.ratio, image1.frame.origin.y, image1.frame.width,image1.frame.height))
        image2.image = UIImage(named: "shop_2")
        image2.layer.cornerRadius = image2.frame.size.width/2
        self.addSubview(image2)
        
        let image3 = UIImageView(frame: CGRectMake(CGRectGetMaxX(image2.frame)+48*Consts.ratio, image1.frame.origin.y, image1.frame.width,image1.frame.height))
        image3.image = UIImage(named: "shop_3")
        image3.layer.cornerRadius = image3.frame.size.width/2
        self.addSubview(image3)
        
        let image4 = UIImageView(frame: CGRectMake(windowWidth-(40*Consts.ratio)-7, 10, 7, 12))
        image4.image = UIImage(named: "home_1")
        self.addSubview(image4)

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 0.1)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1.0)
        CGContextBeginPath(UIGraphicsGetCurrentContext())
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(),40 * Consts.ratio, 32)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), windowWidth-(40 * Consts.ratio), 32)
        CGContextStrokePath(UIGraphicsGetCurrentContext())

    }
}
