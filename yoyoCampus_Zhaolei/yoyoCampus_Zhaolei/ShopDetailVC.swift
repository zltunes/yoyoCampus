//
//  ShopDetailVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 浩然 on 15/11/16.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

class ShopDetailVC: UIViewController {
    
    internal var shopID = String()
    
    var upView = UIView()
    var downView = DownView()
    var shopImage = UIImageView()
    var shopName = UILabel()
    
    var mainSale = UILabel()
    var shopPhone = UILabel()
    var shopAdd = UILabel()
    var shopDescription = UILabel()
    var shopText = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 235/255, green: 234/255, blue: 234/255, alpha: 1)
        self.setView()
        self.httpGetShopDetail()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func httpGetShopDetail(){
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/shop/" + self.shopID, headers: httpHeader).responseJSON(options:NSJSONReadingOptions.MutableContainers){
            response in
            let json = JSON(response.result.value!)
            
            self.shopImage.sd_setImageWithURL(NSURL(string: json["image"].string!))
            self.shopName .text = json["name"].string!
            self.mainSale.text = json["main"].string!
            self.shopPhone.text = json["phone_num"].string!
            self.shopAdd.text = json["address"].string!
            self.shopText.text = json["description"].string!

            Consts.setUpNavigationBarWithBackButton(self, title: self.shopName.text, backTitle: "<")

        }
    }
    
    func setView(){
        let upView = UIView(frame: CGRectMake(0,0,windowWidth,windowHeight*0.25))
        upView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(upView)
        self.upView = upView
        
        let downView = DownView(frame: CGRectMake(0,CGRectGetMaxY(upView.frame)+20,windowWidth,windowHeight*0.4))
        downView.backgroundColor = UIColor.whiteColor()
        downView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(downView)
        self.downView = downView
        
        let shopImage = UIImageView(frame: CGRectMake(windowWidth*0.5-40,10,80,80))
        shopImage.backgroundColor = UIColor.yellowColor()
        shopImage.layer.masksToBounds = true
        shopImage.layer.cornerRadius = 40
        self.upView.addSubview(shopImage)
        self.shopImage = shopImage
        
        let shopName = UILabel(frame: CGRectMake(0,CGRectGetMaxY(upView.frame)-20,windowWidth,10))
        shopName.textAlignment = NSTextAlignment.Center
        self.upView.addSubview(shopName)
        self.shopName = shopName
        
        let complainBtn = UIButton(type: UIButtonType.RoundedRect)
        complainBtn.frame = CGRectMake(40,CGRectGetMaxY(downView.frame)+20,windowWidth-80,40)
        complainBtn.backgroundColor = UIColor(red: 25/255, green: 182/255, blue: 160/255, alpha: 1)
        complainBtn.layer.masksToBounds = true
        complainBtn.layer.cornerRadius = 5
        complainBtn.setTitle("举 报 商 家", forState: UIControlState.Normal)
        complainBtn.tintColor = UIColor.whiteColor()
        self.view.addSubview(complainBtn)
        
        let shopText = UILabel(frame: CGRectMake(40,170,windowWidth-90,downView.frame.height-180))
        shopText.textColor = UIColor.grayColor()
        shopText.font = UIFont(name: "Verdana", size: 14)
        //自动换行！
        shopText.numberOfLines = 0
        shopText.lineBreakMode = NSLineBreakMode.ByCharWrapping
        self.downView.addSubview(shopText)
        self.shopText = shopText
        
        let mainSale = UILabel(frame: CGRectMake(115,18,windowWidth-115,20))
        mainSale.font = UIFont(name: "Verdana", size: 14)
        mainSale.textColor = UIColor.grayColor()
        self.downView.addSubview(mainSale)
        self.mainSale = mainSale
        
        let shopPhone = UILabel(frame: CGRectMake(115,CGRectGetMinY(mainSale.frame)+40,windowWidth-115,20))
        shopPhone.textColor = UIColor.grayColor()
        shopPhone.font = UIFont(name: "Verdana", size: 14)
        self.downView.addSubview(shopPhone)
        self.shopPhone = shopPhone
        
        let shopAdd = UILabel(frame: CGRectMake(115,CGRectGetMinY(shopPhone.frame)+40,windowWidth-115,20))
        shopAdd.textColor = UIColor.grayColor()
        shopAdd.font = UIFont(name: "Verdana", size: 14)
        self.downView.addSubview(shopAdd)
        self.shopAdd = shopAdd
        
    
    }
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
