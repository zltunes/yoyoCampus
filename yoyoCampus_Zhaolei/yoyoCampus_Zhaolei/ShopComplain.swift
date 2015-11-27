//
//  ShopComplain.swift
//  yoyoCampus_Zhaolei
//
//  Created by 浩然 on 15/11/27.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

class ShopComplain: UIViewController,UITextViewDelegate {
    var btnCommit = UIButton()
    var placeLabel = UILabel()
    var complainText = UITextView()
    var shopId = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        Consts.setUpNavigationBarWithBackButton(self, title: "举 报 商 家", backTitle: "<")
        self.view.backgroundColor = Consts.grayView
        
        let upView = UIView(frame: CGRectMake(0,0,windowWidth,windowHeight*0.4))
        upView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(upView)
        
        let btnCommit = UIButton(type: UIButtonType.RoundedRect)
        btnCommit.frame = CGRectMake(40,CGRectGetMaxY(upView.frame)+30,windowWidth-80,40)
        btnCommit.backgroundColor = UIColor(red: 25/255, green: 182/255, blue: 160/255, alpha: 1)
        btnCommit.layer.masksToBounds = true
        btnCommit.layer.cornerRadius = 5
        btnCommit.setTitle("确 认 提 交", forState: UIControlState.Normal)
        btnCommit.tintColor = UIColor.whiteColor()
        btnCommit.addTarget(self, action: Selector("gotoCommit:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.btnCommit = btnCommit
        self.view.addSubview(btnCommit)
        
        let complainText = UITextView(frame: CGRectMake(30,20,windowWidth-60,windowHeight*0.3))
        complainText.layer.borderColor = UIColor.grayColor().CGColor
        complainText.delegate = self
        complainText.layer.borderWidth = 0.5
        complainText.layer.cornerRadius = 10
        complainText.layer.masksToBounds = true
        complainText.font = UIFont(name: "Verdana", size: 13)
        complainText.textColor = UIColor.grayColor()
        complainText.keyboardType = UIKeyboardType.Default
        self.complainText = complainText
        upView.addSubview(complainText)
        
        let placeLabel = UILabel(frame: CGRectMake(0 ,0,windowWidth,20))
        placeLabel.textColor = UIColor.grayColor()
        placeLabel.font = UIFont(name: "Verdana", size: 13)
        placeLabel.text = "我们会根据您的反馈及时处理，保障您的权益"
        self.placeLabel = placeLabel
        complainText.addSubview(placeLabel)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    func gotoCommit(sender:UIButton){
        Alamofire.request(.POST, "http://api2.hloli.me:9001/v1.0/report/",headers:httpHeader,parameters:["shop_id":self.shopId,"content":self.complainText.text!],encoding:.JSON).responseJSON(){
            response in
            
        }
    }
 
    func textViewDidChange(textView: UITextView) {
        if(textView.text.characters.count == 0){
            self.placeLabel.hidden = false
            self.complainText.endEditing(true)
        }
        else{
            self.placeLabel.hidden = true
        }
    }

}
