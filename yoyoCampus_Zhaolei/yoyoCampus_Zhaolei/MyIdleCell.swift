//
//  MyIdleCell.swift
//  yoyoCampus_Zhaolei
//
//  Created by 浩然 on 15/11/17.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

class MyIdleCell: UITableViewCell {
    var idleImage = UIImageView()
    var idleName = UILabel()
    var idlePrice = UILabel()
    var btnEdit = UIButton()
    var btnState = UIButton()
    var isActive : Bool = Bool()
    var idleID = String()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let idleImage = UIImageView(frame: CGRectMake(5, 15, windowWidth/3, windowWidth/6+20))
        idleImage.backgroundColor = UIColor.yellowColor()
        self.addSubview(idleImage)
        self.idleImage = idleImage
        
        let idleName = UILabel(frame: CGRectMake(CGRectGetMaxX(idleImage.frame)+20, 17, windowWidth/3, 20))
        idleName.font = UIFont(name: "Verdana", size: 17)
        self.idleName = idleName
        self.addSubview(idleName)
        
        let idlePrice = UILabel(frame: CGRectMake(idleName.frame.origin.x,CGRectGetMaxY(idleName.frame)+30, 100, 20))
        idlePrice.textColor = UIColor.redColor()
        self.addSubview(idlePrice)
        self.idlePrice = idlePrice
        
        let btnEdit = UIButton(frame: CGRectMake(windowWidth*0.8, 20, 60, 25))
        btnEdit.layer.borderWidth = 1
        btnEdit.layer.masksToBounds = true
        btnEdit.layer.cornerRadius = 5
        btnEdit.layer.borderUIColor = UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1)
        btnEdit.setTitle("编辑", forState: UIControlState.Normal)
        btnEdit.setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
        btnEdit.titleLabel?.font = UIFont(name: "Verdana", size: 14)
        self.contentView.addSubview(btnEdit)
        self.btnEdit = btnEdit
        
        
        let btnState = UIButton(frame: CGRectMake(windowWidth*0.8, CGRectGetMaxY(btnEdit.frame)+25, 60, 25))
        btnState.backgroundColor = UIColor.whiteColor()
        btnState.layer.borderColor = UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1).CGColor
        btnState.layer.borderWidth = 1
        btnState.titleLabel?.font = UIFont(name: "Verdana", size: 14)
        btnState.setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
        btnState.layer.masksToBounds = true
        btnState.layer.cornerRadius = 5
        self.contentView.addSubview(btnState)
        self.btnState = btnState
        
        
    }

    func setCellData(data : AnyObject){
        if(self.isActive == true){
            btnState.setTitle("下架", forState: UIControlState.Normal)
            btnState.addTarget(self, action: Selector("clickOff:"), forControlEvents: UIControlEvents.TouchUpInside)
        }
        if(self.isActive == false){
            btnState.setTitle("上架", forState: UIControlState.Normal)
            btnState.addTarget(self, action: Selector("clickOn:"), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        self.idleImage.sd_setImageWithURL(NSURL(string: data["image"]!! as! String))
        self.idleName.text = (data["name"]!! as! String)
        self.idlePrice.text = "￥" + String(data["price"]as! Int)
        
        self.idleID = data["idle_id"]!! as! String
    }
    
    func clickOff(sender : UIButton){
        Alamofire.request(.PUT, "http://api2.hloli.me:9001/v1.0/idle/\(self.idleID)" ,headers:httpHeader,parameters:["is_active":0],encoding:.JSON).responseJSON{
            response in
            print(response.result.value)
        }
    }
    func clickOn(sender : UIButton){
        Alamofire.request(.PUT, "http://api2.hloli.me:9001/v1.0/idle/\(self.idleID)" ,headers:httpHeader,parameters:["is_active":1],encoding:.JSON).responseJSON{
            response in
            print(response.result.value)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
