//
//  campView.swift
//  YouYouSchool-iOS
//
//  Created by 浩然 on 15/9/24.
//  Copyright © 2015年 浩然. All rights reserved.
//

import UIKit

class campView: UIView {

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
        nameLabel.text = "       旅游"
        nameLabel.font = UIFont(name: "Verdana", size: 15)
        self.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.userInteractionEnabled = true
        nameLabel.tag = 0
        
        let greenView = UIView(frame: CGRectMake(40 * Consts.ratio, 15 * Consts.ratio, 3, 15))
        greenView.backgroundColor = UIColor(red: 25/255, green: 180/255, blue: 160/255, alpha: 1)
        self.addSubview(greenView)
        
        let image1 = UIImageView(frame: CGRectMake(70*Consts.ratio, CGRectGetMaxY(nameLabel.frame)+20*Consts.ratio,(windowWidth-300*Consts.ratio)/3,95*Consts.ratio))
        image1.image = UIImage(named: "camp_1")
        self.addSubview(image1)
        
        let image2 = UIImageView(frame: CGRectMake(CGRectGetMaxX(image1.frame)+80*Consts.ratio, image1.frame.origin.y, image1.frame.size.width, image1.frame.size.height))
        image2.image = UIImage(named: "camp_2")
        self.addSubview(image2)
        
        let image3 = UIImageView(frame: CGRectMake(CGRectGetMaxX(image2.frame)+80*Consts.ratio, image1.frame.origin.y, image1.frame.size.width, image1.frame.size.height))
        image3.image = UIImage(named: "camp_3")
        self.addSubview(image3)
        
        let image4 = UIImageView(frame: CGRectMake(70*Consts.ratio, CGRectGetMaxY(image1.frame)+20*Consts.ratio, image1.frame.size.width, image1.frame.size.height))
        image4.image = UIImage(named: "camp_4")
        self.addSubview(image4)
        
        let image5 = UIImageView(frame: CGRectMake(CGRectGetMaxX(image4.frame)+80*Consts.ratio, image4.frame.origin.y, image4.frame.size.width, image4.frame.size.height))
        image5.image = UIImage(named: "camp_5")
        self.addSubview(image5)
        
        let image6 = UIImageView(frame: CGRectMake(CGRectGetMaxX(image5.frame)+80*Consts.ratio, image4.frame.origin.y, image4.frame.size.width, image4.frame.size.height))
        image6.image = UIImage(named: "camp_6")
        self.addSubview(image6)
        
        let image7 = UIImageView(frame: CGRectMake(windowWidth-(40*Consts.ratio)-7, 10, 7, 12))
        image7.image = UIImage(named: "home_1")
        self.addSubview(image7)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override func drawRect(rect: CGRect) {
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 0.1)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1.0)
        CGContextBeginPath(UIGraphicsGetCurrentContext())
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 40 * Consts.ratio, 32)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), windowWidth-(40 * Consts.ratio), 32)
        CGContextStrokePath(UIGraphicsGetCurrentContext())
    }

}
