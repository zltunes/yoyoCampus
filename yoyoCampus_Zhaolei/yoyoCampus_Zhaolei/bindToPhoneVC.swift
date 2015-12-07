//
//  bindToPhoneVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/11/1.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

class bindToPhoneVC: UIViewController,APIDelegate {

    var img = UIImageView()
    
    var phoneView = UIView()
    
    var verifyCodeView = UIView()

    var phoneImg = UIImageView()
    
    var verifyCodeImg = UIImageView()
    
    var phoneTextField = UITextField()
    
    var verifyCodeTextField = UITextField()
    
    var bindBtn = UIButton()
    
    var api = YoYoAPI()
    
    var verifyCodeULR:String = ""
    
    var bindURL:String = ""
    
    var infoURL:String = ""
    
    var params:[String:AnyObject]? = ["":""]
    
    var plistDict:NSMutableDictionary = ["":""]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpNavigationBar()
        self.setUpInitialLooking()
        self.setUpActions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "绑  定", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height
        
        self.view.backgroundColor = Consts.grayView
        
        //头像
        self.img.frame = CGRect(x: 260 * Consts.ratio, y: 80 * Consts.ratio, width: 200 * Consts.ratio, height: 200 * Consts.ratio)
        self.img.contentMode = .ScaleAspectFit
        self.img.layer.cornerRadius = self.img.frame.width / 2   //圆角半径＝width/2，形成原型
        self.img.layer.masksToBounds = true
        //        self.img.image = Consts.imageFromColor(Consts.tintGreen, size: self.img.frame.size)
        self.img.image = UIImage(named: "register_icon_just a sign")
        self.view.addSubview(self.img)
        
        //手机号背景
        self.phoneView.frame = CGRect(x: 37 * Consts.ratio, y: 350 * Consts.ratio, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.phoneView.layer.cornerRadius = 7
        self.phoneView.layer.masksToBounds = true
        self.phoneView.backgroundColor = Consts.white
        self.view.addSubview(self.phoneView)
        
        //密码背景
        self.verifyCodeView.frame = CGRect(x: 37 * Consts.ratio, y: 460 * Consts.ratio, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.verifyCodeView.layer.cornerRadius = 7
        self.verifyCodeView.layer.masksToBounds = true
        self.verifyCodeView.backgroundColor = Consts.white
        self.view.addSubview(self.verifyCodeView)
        
        //手机号图标
        self.phoneImg.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 30 * Consts.ratio, height: 42 * Consts.ratio)
        self.phoneImg.image = UIImage.init(named: "register_button_phone")
        self.phoneView.addSubview(self.phoneImg)
        //密码图标
        self.verifyCodeImg.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 30 * Consts.ratio, height: 42 * Consts.ratio)
        self.verifyCodeImg.image = UIImage.init(named: "register_button_password")
        self.verifyCodeView.addSubview(self.verifyCodeImg)

        //手机号textField
        self.phoneTextField = Consts.setUpUITextField(CGRect(x: 0, y: 0, width: self.phoneView.frame.width - self.phoneImg.frame.width, height: 90 * Consts.ratio), origin_X: self.phoneImg.frame.maxX + 22 * Consts.ratio, font: Consts.ft15, textColor: Consts.lightGray, placeholder: "请输入手机号");
        self.phoneTextField.keyboardType = .NumberPad
        self.phoneView.addSubview(self.phoneTextField)
        //密码textfield
        self.verifyCodeTextField = Consts.setUpUITextField(CGRect(x: 0, y: 0, width: self.phoneView.frame.width/3, height: 90 * Consts.ratio),origin_X: self.verifyCodeImg.frame.maxX + 22 * Consts.ratio, font: Consts.ft15, textColor: Consts.lightGray, placeholder: "请输入密码")
        self.verifyCodeTextField.secureTextEntry = true
        self.verifyCodeView.addSubview(self.verifyCodeTextField)
        
        //注册
        self.bindBtn = Consts.setUpButton("绑  定", frame: CGRect(x: 70 * Consts.ratio, y: newHeight * 0.5, width: newWidth - 140 * Consts.ratio, height: 86 * Consts.ratio), font: Consts.ft20, radius: 4)
        self.view.addSubview(self.bindBtn)
    }

    func setUpOnlineData(tag:String){
        switch(tag){
            
        case "bind":
            self.bindURL = "\(Consts.mainUrl)/v1.0/auth/weixin/bind/"
            self.params = ["phone_num":self.phoneTextField.text!,"password":self.verifyCodeTextField.text!,"open_id":AppDelegate.wechat_openid,"access_token":AppDelegate.wechat_accessToken]
            api.httpRequest("POST", url: self.bindURL, params: self.params, tag: "bind")
            break
            
            
        case "info":
            self.api = YoYoAPI()
            self.api.delegate = self
            self.infoURL = "\(Consts.mainUrl)/v1.0/user/"
            api.httpRequest("GET", url: self.infoURL, params: nil, tag: "info")
            
        default:
            break
        }
    }
    
    
    func setUpActions(){
        self.api.delegate = self
        self.bindBtn.addTarget(self, action: "bind:", forControlEvents: .TouchUpInside)
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func bind(sender:UIButton){
        let phoneNum:String = self.phoneTextField.text!
        let verifyCode:NSString = self.verifyCodeTextField.text!
        if !Consts.checkPhoneNum(phoneNum){
            Tool.showErrorHUD("请输入正确的手机号!")
        }else if (!Consts.checkPassword(self.verifyCodeTextField.text!)){
            Tool.showErrorHUD("密码至少六位!")
        }else{
            setUpOnlineData("bind")
        }
    }

    
    func didReceiveJsonResults(json: JSON, tag: String) {
        switch(tag){
            case "bind":
                 print("微信绑定yoyo账号反馈:\(json)")
                 
                if let token = json["access_token"].string{
                    plistDict = NSMutableDictionary(contentsOfFile: AppDelegate.filePath)!
                        plistDict.setObject(token, forKey: "access_token")
                        plistDict.setObject(self.phoneTextField.text!, forKey:"tel")
                        plistDict.setObject(true, forKey: "isLogin")
                        plistDict.writeToFile(AppDelegate.filePath, atomically: true)
                        
                        AppDelegate.isLogin = true
                        AppDelegate.access_token = token
                        AppDelegate.tel = self.phoneTextField.text!
                        
                        Tool.showSuccessHUD("绑定成功!")
                        //查看个人信息是否完善
                        setUpOnlineData("info")
                    
                }else if(json["code"] == 404){
                    Tool.showErrorHUD("该号码未注册哦!")
                }else if(json["code"] == 406){
                    Tool.showErrorHUD("密码不对哦!")
                }else{
                    Tool.showErrorHUD("该号码已经被绑定过了哦!")
                 }
//                应考虑错误：号码未注册，号码已被绑定，密码不对
            break
            
            case "info":
                if(json["name"].string == nil){
                    //                    未完善个人信息
                    let personalInfoVC = PersonalInfoViewController()
                    PersonalInfoViewController.backTitle = nil
                    self.navigationController?.pushViewController(personalInfoVC, animated: true)
                }else{
                    plistDict["name"] = json["name"].string!
                    //                    plistDict["tel"] = json["phone_num"].string!
                    plistDict["photo"] = NSData(contentsOfURL: NSURL(string: json["image"].string!)!)
                    plistDict["enroll_year"] = json["enroll_year"].string!
                    plistDict["location"] = json["location"].string!
                    plistDict["weibo_bind"] = json["weibo_bind"].int!
                    plistDict["weixin_bind"] = json["weixin_bind"].int!
                    plistDict.writeToFile(AppDelegate.filePath, atomically: false)
                    let vc = PersonCenterVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            break
            
        default:
            break
        }

    }

    ///实现点击UIView内部关闭键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
