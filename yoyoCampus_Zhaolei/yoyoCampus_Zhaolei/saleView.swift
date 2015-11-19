//
//  saleView.swift
//  YouYouSchool-iOS
//
//  Created by 浩然 on 15/9/24.
//  Copyright © 2015年 浩然. All rights reserved.
//

import UIKit

class saleView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nameLabel = UILabel(frame: CGRectMake(0, 0, windowWidth, 30))
        nameLabel.text = "       闲置"
        nameLabel.font = UIFont.systemFontOfSize(16)
        self.addSubview(nameLabel)
        
        let image1 = UIImageView(frame: CGRectMake(30, CGRectGetMaxY(nameLabel.frame)+10, self.frame.size.width*0.25,self.frame.size.height*0.5))
        image1.image = UIImage(named: "sale_1")
        self.addSubview(image1)
        
        let image2 = UIImageView(frame: CGRectMake(CGRectGetMaxX(image1.frame)+30, image1.frame.origin.y, image1.frame.size.width, image1.frame.size.height))
        image2.image = UIImage(named: "sale_2")
        self.addSubview(image2)
        
        let image3 = UIImageView(frame: CGRectMake(CGRectGetMaxX(image2.frame)+30, image1.frame.origin.y, image1.frame.size.width, image1.frame.size.height))
        image3.image = UIImage(named: "sale_3")
        self.addSubview(image3)
        
        let image4 = UIImageView(frame: CGRectMake(windowWidth*0.93, 10, 7, 12))
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
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 10, 32)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), windowWidth-10, 32)
        CGContextStrokePath(UIGraphicsGetCurrentContext())
    }

}
