//
//  RegisterViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/9/22.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController,APIDelegate{
    
    var img = UIImageView()
    
    var phoneView = UIView()
    
    var verifyCodeView = UIView()
    
    var pwdView = UIView()
    
    var pwdAgainView = UIView()
    
    var phoneImg = UIImageView()
    
    var verifyCodeImg = UIImageView()
    
    var pwdImg = UIImageView()
    
    var pwdAgainImg = UIImageView()
    
    var phoneTextField = UITextField()
    
    var verifyCodeTextField = UITextField()
    
    var pwdTextField = UITextField()
    
    var pwdAgainTextField = UITextField()
    
    var getVerifyCodeBtn = UIButton()
    
    var registerBtn = UIButton()
    
    var api = YoYoAPI()
    
    var registerURL:String = ""
    
    var registerURL_wechat:String = ""
    
    var verifyCodeULR:String = ""
    
    var params:[String:AnyObject]? = ["":""]
    
//    注册有两种来源：普通注册／微信绑定注册,故设一标志位
    //0: 普通注册
    //1: 微信绑定注册
    internal var registerType:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setUpInitialLooking()
        self.setUpActions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "注  册", backTitle: "<")
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
        self.phoneView.frame = CGRect(x: 37 * Consts.ratio, y: 360 * Consts.ratio, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.phoneView.layer.cornerRadius = 7
        self.phoneView.layer.masksToBounds = true
        self.phoneView.backgroundColor = Consts.white
        self.view.addSubview(self.phoneView)
        
        //验证码背景
        self.verifyCodeView.frame = CGRect(x: 37 * Consts.ratio, y: 470 * Consts.ratio, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.verifyCodeView.layer.cornerRadius = 7
        self.verifyCodeView.layer.masksToBounds = true
        self.verifyCodeView.backgroundColor = Consts.white
        self.view.addSubview(self.verifyCodeView)
        
        //密码框背景
        self.pwdView.frame = CGRect(x: 37 * Consts.ratio, y: 580 * Consts.ratio, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.pwdView.layer.cornerRadius = 7
        self.pwdView.layer.masksToBounds = true
        self.pwdView.backgroundColor = Consts.white
        self.view.addSubview(self.pwdView)
    
        //再次输入密码背景
        self.pwdAgainView.frame = CGRect(x: 37 * Consts.ratio, y: 690 * Consts.ratio, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.pwdAgainView.layer.cornerRadius = 7
        self.pwdAgainView.layer.masksToBounds = true
        self.pwdAgainView.backgroundColor = Consts.white
        self.view.addSubview(self.pwdAgainView)
        
        //手机号图标
        self.phoneImg.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 30 * Consts.ratio, height: 42 * Consts.ratio)
        self.phoneImg.image = UIImage.init(named: "register_button_phone")
        self.phoneView.addSubview(self.phoneImg)
        //验证码图标
        self.verifyCodeImg.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 30 * Consts.ratio, height: 42 * Consts.ratio)
        self.verifyCodeImg.image = UIImage.init(named: "sign in_button_security code")
        self.verifyCodeView.addSubview(self.verifyCodeImg)
        //密码图标
        self.pwdImg.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 30 * Consts.ratio, height: 35 * Consts.ratio)
        self.pwdImg.image = UIImage.init(named: "register_button_password")
        self.pwdView.addSubview(self.pwdImg)
        //再次密码图标
        self.pwdAgainImg.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 30 * Consts.ratio, height: 35 * Consts.ratio)
        self.pwdAgainImg.image = UIImage.init(named: "register_button_password")
        self.pwdAgainView.addSubview(self.pwdAgainImg)
        
        //手机号textField
        self.phoneTextField = Consts.setUpUITextField(CGRect(x: 0, y: 0, width: self.phoneView.frame.width - self.phoneImg.frame.width, height: 90 * Consts.ratio), origin_X: self.phoneImg.frame.maxX + 22 * Consts.ratio, font: Consts.ft15, textColor: Consts.lightGray, placeholder: "请输入手机号");
        self.phoneView.addSubview(self.phoneTextField)
        //验证码textfield
        self.verifyCodeTextField = Consts.setUpUITextField(CGRect(x: 0, y: 0, width: self.phoneView.frame.width/3, height: 90 * Consts.ratio),origin_X: self.verifyCodeImg.frame.maxX + 22 * Consts.ratio, font: Consts.ft15, textColor: Consts.lightGray, placeholder: "请输入验证码")
        self.verifyCodeView.addSubview(self.verifyCodeTextField)
        //获取验证码btn
        self.getVerifyCodeBtn = UIButton(type: .Custom)
        self.getVerifyCodeBtn.frame = CGRect(x: self.verifyCodeTextField.frame.maxX + 100 * Consts.ratio, y: 0, width: self.verifyCodeView.frame.width/3.2, height: 65 * Consts.ratio)
        self.getVerifyCodeBtn.setTitle("发送验证码", forState: .Normal)
        self.getVerifyCodeBtn.titleLabel?.font = Consts.ft11
        self.getVerifyCodeBtn.setTitleColor(Consts.tintGreen, forState: .Normal)
        self.getVerifyCodeBtn.center.y = self.verifyCodeTextField.center.y
        self.getVerifyCodeBtn.layer.cornerRadius = 8.0
        self.getVerifyCodeBtn.layer.masksToBounds = true
        self.getVerifyCodeBtn.layer.borderWidth = 1.0
        self.getVerifyCodeBtn.layer.borderColor = Consts.tintGreen.CGColor
        self.verifyCodeView.addSubview(self.getVerifyCodeBtn)
        
        //密码textfield
        self.pwdTextField = Consts.setUpUITextField(CGRect(x: 0, y: 0, width: self.phoneView.frame.width - self.phoneImg.frame.width, height: 90 * Consts.ratio), origin_X: self.pwdImg.frame.maxX + 22 * Consts.ratio, font: Consts.ft15, textColor: Consts.tintGreen, placeholder: "请输入密码")
        self.pwdTextField.secureTextEntry = true
        self.pwdTextField.textColor = Consts.lightGray
        self.pwdView.addSubview(self.pwdTextField)
        //再次输入密码textField
        self.pwdAgainTextField = Consts.setUpUITextField(CGRect(x: 0, y: 0, width: self.phoneView.frame.width - self.phoneImg.frame.width, height: 90 * Consts.ratio), origin_X: self.pwdAgainImg.frame.maxX + 22 * Consts.ratio, font: Consts.ft15, textColor: Consts.tintGreen, placeholder: "请再次输入密码")
        self.pwdAgainTextField.secureTextEntry = true
        self.pwdAgainTextField.textColor = Consts.lightGray
        self.pwdAgainView.addSubview(self.pwdAgainTextField)
        
        //注册
        self.registerBtn = Consts.setUpButton("注  册", frame: CGRect(x: 70 * Consts.ratio, y: newHeight * 0.7, width: newWidth - 140 * Consts.ratio, height: 86 * Consts.ratio), font: Consts.ft24, radius: 7)
        self.view.addSubview(self.registerBtn)
    }
    
    func setUpOnlineData(tag:String){
        switch(tag){
            case "register":
                self.registerURL = "\(Consts.mainUrl)/v1.0/user/"
                self.params = ["phone_num":self.phoneTextField.text!,"code":self.verifyCodeTextField.text!,"password":self.pwdTextField.text!]
                api.httpRequest("POST", url: registerURL, params: params, tag: "register")
            break
            
            case "verify":
                self.verifyCodeULR = "\(Consts.mainUrl)/v1.0/auth/code/"
                self.params = ["phone_num":self.phoneTextField.text!]
                api.httpRequest("POST", url: verifyCodeULR, params: params, tag: "verify")
            break
            
            case "wechat_register":
                self.registerURL_wechat = "\(Consts.mainUrl)/v1.0/auth/weixin/register/"
                self.params = ["phone_num":self.phoneTextField.text!,"code":self.verifyCodeTextField.text!,"password":self.pwdTextField.text!,"open_id":AppDelegate.wechat_openid,"access_token":AppDelegate.wechat_accessToken]
                print("微信注册参数：\(self.params)")
                api.httpRequest("POST", url: self.registerURL_wechat, params: self.params, tag: "wechat_register")
            break
            
        default:
            break
        }
    }
    
    func setUpActions(){
        self.api.delegate = self
        self.registerBtn.addTarget(self, action: "register:", forControlEvents: .TouchUpInside)
        self.getVerifyCodeBtn.addTarget(self, action: "startTime", forControlEvents: .TouchUpInside)
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func register(sender:UIButton){
        let phoneNum:String = self.phoneTextField.text!
        let verifyCode:NSString = self.verifyCodeTextField.text!
        let pwd:String = self.pwdTextField.text!
        let pwdAgain:String = self.pwdAgainTextField.text!
        if !Consts.checkPhoneNum(phoneNum){
            Tool.showErrorHUD("请输入正确的手机号!")
        }else if verifyCode.length == 0{
            Tool.showErrorHUD("请输入验证码!")
        }else if !Consts.checkPassword(pwd){
             Tool.showErrorHUD("密码至少6位!")
        }else if pwd != pwdAgain{
            Tool.showErrorHUD("两次输入的密码不一致!")
        }else if(self.registerType == 0){
            self.setUpOnlineData("register")
        }else if(self.registerType == 1){
            self.setUpOnlineData("wechat_register")
        }
        
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        
        switch(tag){
            case "register":
                print("正常注册反馈:\(json)")
                if let token = json["access_token"].string{
                    //            注册成功-->完善个人信息-->登录到首页
                    if let plistDict = NSMutableDictionary(contentsOfFile: AppDelegate.filePath){
                        plistDict.setObject(token, forKey: "access_token")
                        plistDict.setObject(self.phoneTextField.text!, forKey:"tel")
                        plistDict.setObject(true, forKey: "isLogin")
                        plistDict.writeToFile(AppDelegate.filePath, atomically: true)
                        
                        AppDelegate.isLogin = true
                        AppDelegate.access_token = token
                        AppDelegate.tel = self.phoneTextField.text!
                        
                        Tool.showSuccessHUD("注册成功!")
                        let vc = PersonalInfoViewController()
                        PersonalInfoViewController.backTitle = nil
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else if json["code"].int == 406{//重复注册
                    Tool.showErrorHUD("该号码已经注册过了哦!")
                }else if json["code"].int == 404{//验证码错误
                    Tool.showErrorHUD("验证码不对哦!")
                }
            break
            
            case "wechat_register":
                print("微信绑定注册反馈:\(json)")
                if let token = json["access_token"].string{
                    if let plistDict = NSMutableDictionary(contentsOfFile: AppDelegate.filePath){
                        plistDict.setObject(token, forKey: "access_token")
                        plistDict.setObject(self.phoneTextField.text!, forKey:"tel")
                        plistDict.setObject(true, forKey: "isLogin")
                        plistDict.writeToFile(AppDelegate.filePath, atomically: true)
                        
                        AppDelegate.isLogin = true
                        AppDelegate.access_token = token
                        AppDelegate.tel = self.phoneTextField.text!
                        
                        Tool.showSuccessHUD("注册并绑定微信成功!")
                        let vc = PersonalInfoViewController()
                        PersonalInfoViewController.backTitle = nil
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else if json["code"].int == 406{//重复注册
                    Tool.showErrorHUD("该号码已经注册过了哦!")
                }else if json["code"].int == 404{//验证码错误
                    Tool.showErrorHUD("验证码不对哦!")
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
    
    func startTime(){
         if(Consts.checkPhoneNum(self.phoneTextField.text!)){
//        倒计时
        var timeout = 60
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(timer, dispatch_walltime(nil, 0), UInt64(1.0) * NSEC_PER_SEC, 0)//每秒执行
        dispatch_source_set_event_handler(timer, {
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(timer);
                dispatch_async(dispatch_get_main_queue(), {
                    //设置界面的按钮显示 根据自己需求设置
                    self.getVerifyCodeBtn.setTitle("发送验证码", forState: .Normal)
                    self.getVerifyCodeBtn.setTitleColor(Consts.tintGreen, forState: .Normal)
                    self.getVerifyCodeBtn.userInteractionEnabled = true;
                    });
            }else{
                let seconds = timeout % 61;
                let strTime = "\(seconds)"
                dispatch_async(dispatch_get_main_queue(), {
                //设置界面的按钮显示 根据自己需求设置
                self.getVerifyCodeBtn.setTitle("\(strTime)秒后重新发送", forState: .Normal)
                self.getVerifyCodeBtn.setTitleColor(Consts.lightGray, forState: .Normal)
                self.getVerifyCodeBtn.userInteractionEnabled = false
                });
                timeout--;
            }
            });
        dispatch_resume(timer);

        setUpOnlineData("verify")
        }
        else{
            Tool.showErrorHUD("请输入正确的手机号!")
        }
    }

}
