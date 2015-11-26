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

class MyIdleCell: UITableViewCell,APIDelegate{
    
    var idleImageView = UIImageView()
    var idleNameLabel = UILabel()
    var idlePriceLabel = UILabel()
    
    var idleImageStr:String = ""
    var idleName:String = ""
    var idlePrice:Int = 0
    var idelDescription:String = ""
    var idleCategory:String = ""
    
    var api = YoYoAPI()
    var idleDetailURL:String = ""
    
    var btnEdit = UIButton()
    var btnState = UIButton()
    var isActive : Bool = Bool()
    var idleID = String()

    var belongedVC = MyIdleVC()
    var cellIndex = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        api.delegate = self
        
        let idleImage = UIImageView(frame: CGRectMake(5, 15, windowWidth/3, windowWidth/6+20))
        idleImage.backgroundColor = UIColor.yellowColor()
        self.addSubview(idleImage)
        self.idleImageView = idleImage
        
        let idleName = UILabel(frame: CGRectMake(CGRectGetMaxX(idleImage.frame)+20, 17, windowWidth/3, 20))
        idleName.font = UIFont(name: "Verdana", size: 17)
        self.idleNameLabel = idleName
        self.addSubview(idleName)
        
        let idlePrice = UILabel(frame: CGRectMake(idleName.frame.origin.x,CGRectGetMaxY(idleName.frame)+30, 100, 20))
        idlePrice.textColor = UIColor.redColor()
        self.addSubview(idlePrice)
        self.idlePriceLabel = idlePrice
        
        let btnEdit = UIButton(frame: CGRectMake(windowWidth*0.8, 20, 60, 25))
        btnEdit.layer.borderWidth = 1
        btnEdit.layer.masksToBounds = true
        btnEdit.layer.cornerRadius = 5
        btnEdit.layer.borderUIColor = UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1)
        btnEdit.setTitle("编辑", forState: UIControlState.Normal)
        btnEdit.setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
        btnEdit.titleLabel?.font = UIFont(name: "Verdana", size: 14)
        btnEdit.addTarget(self, action: "edit", forControlEvents: .TouchUpInside)
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
        
        self.idleImageStr = data["image"]as! String
        self.idleName = data["name"]as! String
        self.idlePrice = data["price"]as! Int

        
        self.idleImageView.sd_setImageWithURL(NSURL(string: idleImageStr))
        self.idleNameLabel.text = idleName
        self.idlePriceLabel.text = "￥ \(self.idlePrice)"
        
        self.idleID = data["idle_id"]as! String
        
        idleDetailURL = "\(Consts.mainUrl)/v1.0/idle/\(idleID)"
        
        api.httpRequest("GET", url: idleDetailURL, params: nil, tag: "detail")
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        self.idelDescription = json["description"].string!
        self.idleCategory = json["category"].string!
    }
    
    func clickOff(sender : UIButton){
        Alamofire.request(.PUT, "http://api2.hloli.me:9001/v1.0/idle/\(self.idleID)" ,headers:httpHeader,parameters:["is_active":0],encoding:.JSON).responseJSON{
            response in
            self.belongedVC.resultOffArray.addObject(self.belongedVC.resultOnArray.objectAtIndex(self.cellIndex))
            self.belongedVC.resultOnArray.removeObjectAtIndex(self.cellIndex)
            self.belongedVC.tableViewOn.reloadData()
            
        }
    }
    
    func clickOn(sender : UIButton){
        Alamofire.request(.PUT, "http://api2.hloli.me:9001/v1.0/idle/\(self.idleID)" ,headers:httpHeader,parameters:["is_active":1],encoding:.JSON).responseJSON{
            response in
            self.belongedVC.resultOnArray.addObject(self.belongedVC.resultOffArray.objectAtIndex(self.cellIndex))
            self.belongedVC.resultOffArray.removeObjectAtIndex(self.cellIndex)
            self.belongedVC.tableViewOff.reloadData()
        }
    }
    
    func edit(){
        let vc = MyUploadGoodsViewController()
        vc.infoData = ["category":idleCategory,"name":idleName,"price":idlePrice,"other":idelDescription]
        vc.imgData = NSData(contentsOfURL: NSURL(string: self.idleImageStr)!)!
        vc.imgUploaded = true
        vc.idleID = self.idleID
        vc.isEditIdleGoods = true
        vc.uploadButton.sd_setImageWithURL(NSURL(string: self.idleImageStr), forState: .Normal)
        
        AppDelegate.navigationController_my.visibleViewController?.hidesBottomBarWhenPushed = true
        AppDelegate.navigationController_my.pushViewController(vc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
