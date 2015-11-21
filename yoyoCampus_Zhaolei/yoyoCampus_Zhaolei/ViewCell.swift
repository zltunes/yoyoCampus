//
//  ViewCell.swift
//  YouYouSchool-iOS
//
//  Created by 浩然 on 15/11/9.
//  Copyright © 2015年 浩然. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ViewCell: UITableViewCell {
    var goodsImage = UIImageView()
    var goodsName = UILabel()
    var goodsShopName = UILabel()
    var viewNum = UILabel()
    var originalPrice = UILabel()
    var newPrice = UILabel()
    var goodsDiscount = UILabel()
    var isIdleCell :Bool = Bool()
    var dataCell = NSDictionary()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let goodsImage = UIImageView(frame: CGRectMake(40 * Consts.ratio, 20 * Consts.ratio, 174 * Consts.ratio, 130 * Consts.ratio))
        self.addSubview(goodsImage)
        self.goodsImage = goodsImage
        
        let goodsName = UILabel(frame: CGRectMake(CGRectGetMaxX(goodsImage.frame)+(30 * Consts.ratio), 20 * Consts.ratio, windowWidth/2, 16 * Consts.ratio))
        goodsName.font = UIFont(name: "Verdana", size: 16)
        self.goodsName = goodsName
        self.addSubview(goodsName)
        
        let goodsShopName = UILabel(frame: CGRectMake(CGRectGetMinX(goodsName.frame), CGRectGetMaxY(goodsName.frame)+(28 * Consts.ratio), windowWidth/3, 10))
        goodsShopName.font = UIFont(name: "Verdana", size: 12)
        goodsShopName.textColor = UIColor(red: 20/255, green: 120/255, blue: 100/255, alpha: 1)
        self.goodsShopName = goodsShopName
        self.addSubview(goodsShopName)
        
        let viewImage1 = UIImageView(frame: CGRectMake(CGRectGetMaxX(goodsImage.frame)+20, CGRectGetMaxY(goodsShopName.frame)+(28 * Consts.ratio), 10, 10))
        viewImage1.image = UIImage(named: "viewcell_1")
        self.addSubview(viewImage1)
        
        var viewNum = UILabel(frame: CGRectMake(CGRectGetMaxX(goodsImage.frame)+35, CGRectGetMaxY(goodsShopName.frame)+15, windowWidth/3, 10))
        viewNum.textColor = UIColor.grayColor()
        viewNum.font = UIFont(name: "Verdana", size: 11)
        self.viewNum = viewNum
        self.addSubview(viewNum)
        
        var originalPrice = UILabel(frame: CGRectMake(windowWidth*0.7, CGRectGetMaxY(goodsShopName.frame)+15, 50, 10))
        //originalPrice.text = "￥12345"
        originalPrice.textColor = UIColor.grayColor()
        originalPrice.font = UIFont(name: "Verdana", size: 12)
        self.originalPrice = originalPrice
        self.addSubview(originalPrice)
        
        var newPrice = UILabel(frame: CGRectMake(windowWidth*0.83, CGRectGetMaxY(goodsShopName.frame)+15, 70, 10))
        //newPrice.text = "￥9999"
        newPrice.textColor = UIColor.redColor()
        newPrice.font = UIFont(name: "Verdana", size: 15)
        self.newPrice = newPrice
        self.addSubview(newPrice)
        
        
        let viewImage2 = UIImageView(frame: CGRectMake(CGRectGetMaxX(goodsImage.frame)+20, CGRectGetMaxY(viewImage1.frame)+(22 * Consts.ratio), 10, 10))
        viewImage2.image = UIImage(named: "viewcell_2")
        self.addSubview(viewImage2)

        var goodsDiscount = UILabel(frame: CGRectMake(CGRectGetMaxX(goodsImage.frame)+35, CGRectGetMinY(viewImage2.frame), windowWidth/2, 10))
        //goodsDiscount.text = "凭借悠悠万能优惠卡减免10元"
        goodsDiscount.font = UIFont(name: "Verdana", size: 11)
        goodsDiscount.textColor = UIColor.grayColor()
        self.goodsDiscount = goodsDiscount
        self.addSubview(goodsDiscount)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: AnyObject){
        self.dataCell = data as! NSDictionary
        if(self.isIdleCell == false){
            self.goodsName.text = (data["name"]!! as! String)
            self.goodsShopName.text = (data["shop_name"]!! as! String)
            self.viewNum.text = String(data["view_number"]!!) + "人感兴趣"
            let tempOriPrice = (data["original_price"] as! CGFloat) / 100
            self.originalPrice.text = "￥" + String(tempOriPrice)
            let tempNewPrice = data["price"]as!CGFloat / 100
            self.newPrice.text = "￥" + String(tempNewPrice)
            self.goodsDiscount.text = "凭借悠悠万能优惠卡减免" + String(data["discount"]!!) + "元"
            
            self.goodsImage.sd_setImageWithURL(NSURL(string:data["image"]!! as! String))
        }
        if(self.isIdleCell == true){
            self.goodsName.text = (data["name"]!! as!String)
            self.goodsShopName.text = (data["user_name"]!! as!String)
            self.viewNum.text = String(data["view_number"]!!) + "人感兴趣"
            let tempNewPrice = data["price"]as!CGFloat / 100
            self.newPrice.text = "￥" + String(tempNewPrice)
            self.goodsImage.sd_setImageWithURL(NSURL(string: data["image"]!! as!String))
        }
    }
    
}
