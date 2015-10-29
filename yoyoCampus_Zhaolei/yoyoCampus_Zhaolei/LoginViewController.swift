//
//  LoginViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/9/22.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController,APIDelegate{
    
    var img = UIImageView()
    
    var phoneView = UIView()
    
    var pwdView = UIView()
    
    var phoneImg = UIImageView()
    
    var pwdImg = UIImageView()
    
    var phoneTextField = UITextField()
    
    var pwdTextField = UITextField()
    
    var loginBtn = UIButton()
    
    var fogetPwdBtn = UIButton()
    
    var registerBtn = UIButton()
    
    var leftLine = UIView()
    
    var rightLine = UIView()
    
    var fastLoginLabel = UILabel()
    
    var wechatBtn = UIButton()
    
    var weiboBtn = UIButton()
    
    var wechatLabel = UILabel()
    
    var weiboLabel = UILabel()
    
    var api = YoYoAPI()
    
    var loginURL:String = ""
    
    var infoURL:String = ""
    
    var params = ["":""]
    
    var plistDict = NSMutableDictionary()
    
    //测试btn，进入其他页面
    var gerenxianzhiBtn = UIButton()
    
    var shangpinxiangqingBtn = UIButton()
    
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
        Consts.setUpNavigationBarWithBackButton(self, title: "登  录", backTitle:"<")
        let right = UIBarButtonItem(title: "test", style: .Plain, target: self, action: "test")
        right.tintColor = Consts.white
        self.navigationItem.rightBarButtonItem = right
    }

    func setUpInitialLooking(){
        let newWidth = self.view.frame.width
        
        self.view.backgroundColor = Consts.grayView
        
        //头像
        self.img.frame = CGRect(x: 260 * Consts.ratio, y: 200 * Consts.ratio, width: 200 * Consts.ratio, height: 200 * Consts.ratio)
        self.img.contentMode = .ScaleAspectFit
        self.img.layer.cornerRadius = self.img.frame.width / 2   //圆角半径＝width/2，形成原型
        self.img.layer.masksToBounds = true
        self.img.image = UIImage(named: "register_icon_just a sign")
        self.view.addSubview(self.img)
        
        //手机号背景
        self.phoneView.frame = CGRect(x: 37 * Consts.ratio, y: 480 * Consts.ratio, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.phoneView.layer.cornerRadius = 7
        self.phoneView.layer.masksToBounds = true
        self.phoneView.backgroundColor = Consts.white
        self.view.addSubview(self.phoneView)
        
        //手机号图标
        self.phoneImg.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 30 * Consts.ratio, height: 42 * Consts.ratio)
        self.phoneImg.image = UIImage.init(named: "register_button_phone")
        self.phoneView.addSubview(self.phoneImg)
        
        //手机号输入框
        self.phoneTextField.frame = CGRect(x: 0, y: 0, width: self.phoneView.frame.width - self.phoneImg.frame.width, height: 90 * Consts.ratio)
        self.phoneTextField.frame.origin.x = self.phoneImg.frame.maxX + 22 * Consts.ratio
        self.phoneTextField.font = Consts.ft15
        self.phoneTextField.textColor = Consts.lightGray
        self.phoneTextField.placeholder = "请输入手机号"
        self.phoneView.addSubview(self.phoneTextField)
        
        //密码框背景
        self.pwdView.frame = CGRect(x: 37 * Consts.ratio, y: 600 * Consts.ratio, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.pwdView.layer.cornerRadius = 7
        self.pwdView.layer.masksToBounds = true
        self.pwdView.backgroundColor = Consts.white
        self.view.addSubview(self.pwdView)
        
        //密码图标
        self.pwdImg.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 30 * Consts.ratio, height: 35 * Consts.ratio)
        self.pwdImg.image = UIImage.init(named: "register_button_password")
        self.pwdView.addSubview(self.pwdImg)
        
        //密码输入框 
        self.pwdTextField.frame = CGRect(x: 0, y: 0, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.pwdTextField.frame.origin.x = self.pwdImg.frame.maxX + 22 * Consts.ratio
        self.pwdTextField.font = Consts.ft15
        self.pwdTextField.textColor = Consts.lightGray
        self.pwdTextField.secureTextEntry = true
        self.pwdTextField.placeholder = "请输入密码"
        self.pwdView.addSubview(self.pwdTextField)
        
        //登录按钮
        self.loginBtn = Consts.setUpButton("登  录", frame: CGRect(x: 52 * Consts.ratio, y: 750 * Consts.ratio, width: 600 * Consts.ratio, height: 94 * Consts.ratio), font: Consts.ft24, radius: 7)
        self.loginBtn.center.x = self.view.center.x
        self.view.addSubview(self.loginBtn)
        
        //忘记按钮
        self.fogetPwdBtn = UIButton(type: .System)
        self.fogetPwdBtn.frame = CGRect(x: 0, y: 880 * Consts.ratio, width: 150 * Consts.ratio, height: 45 * Consts.ratio)
        self.fogetPwdBtn.center.x = self.view.center.x/2
        self.fogetPwdBtn.setTitle("忘记密码", forState: .Normal)
        self.fogetPwdBtn.tintColor = Consts.lightGray
        self.fogetPwdBtn.titleLabel?.font = Consts.ft14
        self.view.addSubview(self.fogetPwdBtn)
        
        //马上注册
        self.registerBtn = UIButton(type: .System)
        self.registerBtn.frame = CGRect(x: 0, y: 880 * Consts.ratio, width: 150 * Consts.ratio, height: 45 * Consts.ratio)
        self.registerBtn.center.x = self.view.center.x * 1.5
        self.registerBtn.setTitle("马上注册", forState: .Normal)
        self.registerBtn.tintColor = Consts.lightGray
        self.registerBtn.titleLabel?.font = Consts.ft14
        self.view.addSubview(self.registerBtn)
        
        //leftLine
        self.leftLine.frame = CGRect(x: 65 * Consts.ratio, y: 1000 * Consts.ratio, width: newWidth/3-10 * Consts.ratio, height: 0.5)
        self.leftLine.backgroundColor = Consts.lightGray
        self.view.addSubview(self.leftLine)
        
        //快速登录
        self.fastLoginLabel = Consts.setUpLabel("快速登录", color: Consts.lightGray, font: Consts.ft13, x: 70 + newWidth/4, y: 980 * Consts.ratio, centerX: self.view.center.x)
        self.view.addSubview(self.fastLoginLabel)
        
        //rightLine
        self.rightLine.frame = CGRect(x: 425 * Consts.ratio, y: 1000 * Consts.ratio, width: newWidth/3-10 * Consts.ratio, height: 0.5)
        self.rightLine.backgroundColor = Consts.lightGray
        self.view.addSubview(self.rightLine)
        
        //微信图像
        self.wechatBtn.frame = CGRect(x: 0, y: 1100 * Consts.ratio, width: 85 * Consts.ratio, height: 85 * Consts.ratio)
        self.wechatBtn.center.x = self.view.center.x/2
        self.wechatBtn.setBackgroundImage(UIImage(named: "Personal information_icon_weixin"), forState: .Normal)
        self.view.addSubview(self.wechatBtn)
        
        //微信label
        self.wechatLabel = Consts.setUpLabel("微信登录", color: Consts.lightGray, font: Consts.ft12, x: 0, y: 1200 * Consts.ratio, centerX: self.view.center.x/2)
        self.view.addSubview(self.wechatLabel)
        
        //微博图像 
        self.weiboBtn.frame = CGRect(x: 0, y: 1100 * Consts.ratio, width: 95 * Consts.ratio, height: 95 * Consts.ratio)
        self.weiboBtn.center.x = self.view.center.x * 1.5
        self.weiboBtn.setBackgroundImage(UIImage(named: "Personal information_icon_weibo"), forState: .Normal)
        self.view.addSubview(self.weiboBtn)
        
        //微博label
        self.weiboLabel = Consts.setUpLabel("微博登录", color: Consts.lightGray, font: Consts.ft12, x: 0, y: 1200 * Consts.ratio, centerX: self.view.center.x * 1.5)
        self.view.addSubview(self.weiboLabel)
        
    }
    
    func setUpActions(){
        self.loginBtn.addTarget(self, action: "login:", forControlEvents: .TouchUpInside)
        self.fogetPwdBtn.addTarget(self, action: "foget:", forControlEvents: .TouchUpInside)
        self.registerBtn.addTarget(self, action: "register:", forControlEvents: .TouchUpInside)
        self.wechatBtn.addTarget(self, action: "wechatFastLogin:", forControlEvents: .TouchUpInside)
        self.weiboBtn.addTarget(self, action: "weiboFastLogin:", forControlEvents: .TouchUpInside)
        api.delegate = self
    }
    
    func setUpOnlineData(tag:String){
        switch(tag){
            case "login":
                self.loginURL = "\(Consts.mainUrl)/v1.0/auth/login/"
                self.params = ["phone_num":self.phoneTextField.text!,"password":self.pwdTextField.text!]
                api.httpRequest("POST", url: loginURL, params: params, tag: "login")
            break
            
            case "inof":
                self.infoURL = "\(Consts.mainUrl)/v1.0/user/"
                api.httpRequest("GET", url: infoURL, params: nil, tag: "info")
            break
            
            default:
            break
        }
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        switch(tag){
            case "login":
                if let token = json["access_token"].string{
                    plistDict.setValue(token, forKey: "access_token")
                    plistDict.setValue(self.phoneTextField.text, forKey: "tel")
                    plistDict.setValue(true, forKey: "isLogin")
                    plistDict.writeToFile(AppDelegate.filePath, atomically: false)
//                    检测个人信息是否完整
                    setUpOnlineData("info")
                    }else if (json["code"] == 404){
                    Tool.showErrorHUD("该手机号未注册!")
                }else if (json["code"] == 406){
                    Tool.showErrorHUD("密码不对哦!")
                }
            break
            
            case "info":
                if(json["name"].string == ""){
//                    未完善个人信息
                    let personalInfoVC = PersonalInfoViewController()
                    PersonalInfoViewController.backTitle = nil
                    self.navigationController?.pushViewController(personalInfoVC, animated: true)
                }else{
                    plistDict["name"] = json["name"].string
                    plistDict["photo"] = NSData(contentsOfURL: NSURL(fileURLWithPath: json["image"].string!))
                    plistDict["enroll_year"] = json["enroll_year"].string
                    plistDict["location"] = json["location"].string
                    plistDict["weibo_bind"] = json["weibo_bind"].int
                    plistDict["weixin_bind"] = json["weixin_bind"].int
                    goBack()
            }
            
        default:
            break
        }
    }
    
    func login(sender:UIButton){
        //检查手机号码、密码格式
        let phoneNum:String = self.phoneTextField.text!
        let pwd:String = self.pwdTextField.text!
        if !Consts.checkPhoneNum(phoneNum){
            Tool.showErrorHUD("请输入正确的手机号码!")
        }
        else if !Consts.checkPassword(pwd){
            Tool.showErrorHUD("密码至少6位!")
        }else{
            setUpOnlineData("login")
        }
    }
    
    func foget(sender:UIButton){
        let findPwdVC = FindPwdViewController()
        self.navigationController?.pushViewController(findPwdVC, animated: true)
    }
    
    func register(sender:UIButton){
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func wechatFastLogin(sender:UIButton){
        
        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToWechatSession)
        
        let socialControllerService = UMSocialControllerService.defaultControllerService()
        snsPlatform.loginClickHandler(self,socialControllerService,true){
            (UMSocialResponseEntity response) in
            if (response.responseCode == UMSResponseCodeSuccess){
                let snsAccount = UMSocialAccountManager.socialAccountDictionary()[UMShareToWechatSession]
                print("微信登录->userName:\(snsAccount?.userName)\nuid->\(snsAccount?.usid)\ntoken->\(snsAccount?.accessToken)\nurl->\(snsAccount?.iconURL)")
            }
        }
        
//        授权完成后调用获取用户信息
        UMSocialDataService.defaultDataService().requestSnsInformation(UMShareToWechatSession) { (response) -> Void in
            print("snsinfomation->\(response.data)")
        }
        
        
//        let bindVC = ConnectPhoneViewController()
//        self.ler(bindVC, animated: true)
    }
    
    func weiboFastLogin(sender:UIButton){
        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToSina)
        
        let socialControllerService = UMSocialControllerService.defaultControllerService()
        snsPlatform.loginClickHandler(self,socialControllerService,true){
            (UMSocialResponseEntity response) in
            if (response.responseCode == UMSResponseCodeSuccess){
                let snsAccount = UMSocialAccountManager.socialAccountDictionary()[UMShareToSina]
                print("微博登录->userName:\(snsAccount?.userName)\nuid->\(snsAccount?.usid)\ntoken->\(snsAccount?.accessToken)\nurl->\(snsAccount?.iconURL)")
            }
        }
        
        //        授权完成后调用获取用户信息
        UMSocialDataService.defaultDataService().requestSnsInformation(UMShareToSina) { (response) -> Void in
            print("snsinfomation->\(response.data)")
        }
        

    }
    ///实现点击UIView内部关闭键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    测试进入其他界面
    func test(){
        let vc = TestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}
