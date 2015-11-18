//
//  DownView.swift
//  yoyoCampus_Zhaolei
//
//  Created by 浩然 on 15/11/16.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class DownView: UIView {
    
    var mainSale = UILabel()
    var shopPhone = UILabel()
    var shopAdd = UILabel()
    var shopDescription = UILabel()
   

    var shopText = UITextField()
    
        override func drawRect(rect: CGRect) {
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 0.1)
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1.0)
            CGContextBeginPath(UIGraphicsGetCurrentContext())
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), windowWidth*0.3, 40)
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), windowWidth-50, 40)
            
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), windowWidth*0.3, 80)
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), windowWidth-50, 80)
            
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), windowWidth*0.3, 120)
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), windowWidth-50, 120)
            
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 40, 170)
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), windowWidth-50, 170)
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 40, 170)
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 40, self.frame.size.height-10)
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), windowWidth-50, 170)
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), windowWidth-50, self.frame.size.height-10)
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 40, self.frame.size.height-10)
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), windowWidth-50, self.frame.size.height-10)
            
            
            CGContextStrokePath(UIGraphicsGetCurrentContext())
            
            var mainSale = UILabel(frame: CGRectMake(40,18,75,20))
            mainSale.text = "经 营 范 围"
            mainSale.textColor = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
            mainSale.font = UIFont(name: "Verdana", size: 14)
            self.addSubview(mainSale)
            self.mainSale = mainSale
            
            var shopPhone = UILabel(frame: CGRectMake(40,CGRectGetMinY(mainSale.frame)+40,75,20))
            shopPhone.text = "联 系 电 话"
            shopPhone.textColor = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
            shopPhone.font = UIFont(name: "Verdana", size: 14)
            self.addSubview(shopPhone)
            self.shopPhone = shopPhone
            
            var shopAdd = UILabel(frame: CGRectMake(40,CGRectGetMinY(shopPhone.frame)+40,75,20))
            shopAdd.text = "联 系 地 址"
            shopAdd.textColor = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
            shopAdd.font = UIFont(name: "Verdana", size: 14)
            self.addSubview(shopAdd)
            self.shopAdd = shopAdd
            
            var shopDescription = UILabel(frame: CGRectMake(40,CGRectGetMinY(shopAdd.frame)+40,75,20))
            shopDescription.text = "店 铺 简 介"
            shopDescription.textColor = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
            shopDescription.font = UIFont(name: "Verdana", size: 14)
            self.addSubview(shopDescription)
            self.shopDescription = shopDescription
            
            
            
            
            
            

    
    }
}
