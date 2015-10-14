//
//  FindPwdViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/9/22.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class FindPwdViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setUpInitialLooking()
        self.setUpActions()
        self.setUpOnlineData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "找回密码", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height
            
        self.view.backgroundColor = Consts.grayView
        
        //头像
        self.img.frame = CGRect(x: 260 * Consts.ratio, y: 200 * Consts.ratio, width: 200 * Consts.ratio, height: 200 * Consts.ratio)
        self.img.contentMode = .ScaleAspectFit
        self.img.layer.cornerRadius = self.img.frame.width / 2   //圆角半径＝width/2，形成原型
        self.img.layer.masksToBounds = true
//        self.img.image = Consts.imageFromColor(Consts.tintGreen, size: self.img.frame.size)
        self.img.image = UIImage(named: "register_icon_just a sign")
        self.view.addSubview(self.img)
        
        //手机号背景
        self.phoneView.frame = CGRect(x: 37 * Consts.ratio, y: 480 * Consts.ratio, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.phoneView.layer.cornerRadius = 7
        self.phoneView.layer.masksToBounds = true
        self.phoneView.backgroundColor = Consts.white
        self.view.addSubview(self.phoneView)
        
        //验证码背景
        self.verifyCodeView.frame = CGRect(x: 37 * Consts.ratio, y: 590 * Consts.ratio, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.verifyCodeView.layer.cornerRadius = 7
        self.verifyCodeView.layer.masksToBounds = true
        self.verifyCodeView.backgroundColor = Consts.white
        self.view.addSubview(self.verifyCodeView)
        
        //密码框背景
        self.pwdView.frame = CGRect(x: 37 * Consts.ratio, y: 700 * Consts.ratio, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.pwdView.layer.cornerRadius = 7
        self.pwdView.layer.masksToBounds = true
        self.pwdView.backgroundColor = Consts.white
        self.view.addSubview(self.pwdView)
        
        //再次输入密码背景
        self.pwdAgainView.frame = CGRect(x: 37 * Consts.ratio, y: 810 * Consts.ratio, width: 650 * Consts.ratio, height: 90 * Consts.ratio)
        self.pwdAgainView.layer.cornerRadius = 7
        self.pwdAgainView.layer.masksToBounds = true
        self.pwdAgainView.backgroundColor = Consts.white
        self.view.addSubview(self.pwdAgainView)
        
        //手机号图标
        self.phoneImg.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 42 * Consts.ratio, height: 42 * Consts.ratio)
        self.phoneImg.image = Consts.imageFromColor(Consts.tintGreen, size: self.phoneImg.frame.size)
        self.phoneView.addSubview(self.phoneImg)
        //验证码图标
        self.verifyCodeImg.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 42 * Consts.ratio, height: 42 * Consts.ratio)
        self.verifyCodeImg.image = Consts.imageFromColor(Consts.tintGreen, size: self.verifyCodeImg.frame.size)
        self.verifyCodeView.addSubview(self.verifyCodeImg)
        //密码图标
        self.pwdImg.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 42 * Consts.ratio, height: 42 * Consts.ratio)
        self.pwdImg.image = Consts.imageFromColor(Consts.tintGreen, size: self.pwdImg.frame.size)
        self.pwdView.addSubview(self.pwdImg)
        //再次密码图标
        self.pwdAgainImg.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 42 * Consts.ratio, height: 42 * Consts.ratio)
        self.pwdAgainImg.image = Consts.imageFromColor(Consts.tintGreen, size: self.pwdAgainImg.frame.size)
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
        self.pwdTextField.textColor = Consts.lightGray
        self.pwdTextField.secureTextEntry = true
        self.pwdView.addSubview(self.pwdTextField)
        //再次输入密码textField
        self.pwdAgainTextField = Consts.setUpUITextField(CGRect(x: 0, y: 0, width: self.phoneView.frame.width - self.phoneImg.frame.width, height: 90 * Consts.ratio), origin_X: self.pwdAgainImg.frame.maxX + 22 * Consts.ratio, font: Consts.ft15, textColor: Consts.tintGreen, placeholder: "请再次输入密码")
        self.pwdAgainTextField.textColor = Consts.lightGray
        self.pwdAgainTextField.secureTextEntry = true
        self.pwdAgainView.addSubview(self.pwdAgainTextField)
        
        //注册
        self.registerBtn = Consts.setUpButton("完  成", frame: CGRect(x: 70 * Consts.ratio, y: newHeight * 0.8, width: newWidth - 140 * Consts.ratio, height: 86 * Consts.ratio), font: Consts.ft24, radius: 7)
        self.view.addSubview(self.registerBtn)
    }
    
    func setUpOnlineData(){
        
    }
    
    func setUpActions(){
        self.registerBtn.addTarget(self, action: "finish:", forControlEvents: .TouchUpInside)
        self.getVerifyCodeBtn.addTarget(self, action: "startTime", forControlEvents: .TouchUpInside)
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func finish(sender:UIButton){
        let phoneNum:String = self.phoneTextField.text!
        let verifyCode:NSString = self.verifyCodeTextField.text!
        let pwd:String = self.pwdTextField.text!
        let pwdAgain:String = self.pwdAgainTextField.text!
        if !Consts.checkPhoneNum(phoneNum){
            Tool.showErrorHUD("请输入正确的手机号!")
        }else if verifyCode.length == 0{
            Tool.showErrorHUD("请输入验证码!")//验证码的正确性验证需要结合后台
        }else if !Consts.checkPassword(pwd){
            Tool.showErrorHUD("密码至少6位!")
        }else if pwd != pwdAgain{
            Tool.showErrorHUD("两次输入的密码不一致!")
        }else{
            //修改密码成功
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    ///实现点击UIView内部关闭键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func startTime(){
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
                //            int minutes = timeout / 60;
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
    }
}
