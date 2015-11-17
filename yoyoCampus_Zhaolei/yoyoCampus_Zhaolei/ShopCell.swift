//
//  ShopCell.swift
//  yoyoCampus_Zhaolei
//
//  Created by 浩然 on 15/11/15.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

class ShopCell: UITableViewCell {

    var shopImage = UIImageView()
    var shopName = UILabel()
    var shopMain = UILabel()
    var shopAdd = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        print("a")
//
//    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //
        var shopImage = UIImageView(frame: CGRectMake(5, 15, windowWidth/3, windowWidth/6+20))
        shopImage.backgroundColor = UIColor.yellowColor()
        self.addSubview(shopImage)
        self.shopImage = shopImage
        
        var shopName = UILabel(frame: CGRectMake(CGRectGetMaxX(shopImage.frame)+20, 17, windowWidth/2, 10))
        shopName.font = UIFont(name: "Verdana", size: 17)
        self.shopName = shopName
        self.addSubview(shopName)
        
        var shopMain = UILabel(frame: CGRectMake(shopName.frame.origin.x, CGRectGetMaxY(shopName.frame)+20, windowWidth/2, 10))
        shopMain.font = UIFont(name: "Verdana", size: 13)
        shopMain.textColor = UIColor.grayColor()
        self.shopMain = shopMain
        self.addSubview(shopMain)
        
        var shopAdd = UILabel(frame: CGRectMake(shopName.frame.origin.x, CGRectGetMaxY(shopMain.frame)+20, windowWidth/2, 10))
        shopAdd.font = UIFont(name: "Verdana", size: 13)
        shopAdd.textColor = UIColor.grayColor()
        self.shopAdd = shopAdd
        self.addSubview(shopAdd)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data:AnyObject){
        self.shopImage.sd_setImageWithURL(NSURL(string: data["image"]!!as! String))
        self.shopName.text = (data["name"]!! as!String)
        self.shopMain.text = "主营：" + (data["main"]!! as!String)
        self.shopAdd.text = "地址：" + (data["address"]!! as!String)
    }
    

}
