//
//  studyView.swift
//  YouYouSchool-iOS
//
//  Created by 浩然 on 15/9/23.
//  Copyright © 2015年 浩然. All rights reserved.
//

import UIKit

class studyView: UIView {

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
        
        let nameLabel = UILabel(frame: CGRectMake(0, 0, windowWidth,50*Consts.ratio))
        nameLabel.text = "       留学"
        nameLabel.font = UIFont(name: "Verdana", size: 15)
        self.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.userInteractionEnabled = true
        nameLabel.tag = 3
        
        let greenView = UIView(frame: CGRectMake(40 * Consts.ratio, 15 * Consts.ratio, 3, 15))
        greenView.backgroundColor = UIColor(red: 25/255, green: 180/255, blue: 160/255, alpha: 1)
        self.addSubview(greenView)
        
        let image1 = UIImageView(frame: CGRectMake(40*Consts.ratio, CGRectGetMaxY(nameLabel.frame)+30*Consts.ratio,(windowWidth-240*Consts.ratio)/3,110*Consts.ratio))
        image1.image = UIImage(named: "study_3")
        self.addSubview(image1)
        
        let image2 = UIImageView(frame: CGRectMake(CGRectGetMaxX(image1.frame)+80*Consts.ratio, image1.frame.origin.y, image1.frame.size.width, image1.frame.size.height))
        image2.image = UIImage(named: "study_4")
        self.addSubview(image2)
        
        let image3 = UIImageView(frame: CGRectMake(CGRectGetMaxX(image2.frame)+80*Consts.ratio, image1.frame.origin.y, image1.frame.size.width, image1.frame.size.height))
        image3.image = UIImage(named: "study_1")
        self.addSubview(image3)
        
        let image4 = UIImageView(frame: CGRectMake(40*Consts.ratio, CGRectGetMaxY(image1.frame)+20*Consts.ratio, image1.frame.size.width, image1.frame.size.height))
        image4.image = UIImage(named: "study_5")
        self.addSubview(image4)
        
        let image5 = UIImageView(frame: CGRectMake(CGRectGetMaxX(image4.frame)+80*Consts.ratio, image4.frame.origin.y, image4.frame.size.width, image4.frame.size.height))
        image5.image = UIImage(named: "study_2")
        self.addSubview(image5)
        
        let image6 = UIImageView(frame: CGRectMake(CGRectGetMaxX(image5.frame)+80*Consts.ratio, image4.frame.origin.y, image4.frame.size.width, image4.frame.size.height))
        image6.image = UIImage(named: "study_6")
        self.addSubview(image6)
        
        let image7 = UIImageView(frame: CGRectMake(windowWidth-(40*Consts.ratio)-7, 10, 7, 12))
        image7.image = UIImage(named: "home_1")
        self.addSubview(image7)
        
        
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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
