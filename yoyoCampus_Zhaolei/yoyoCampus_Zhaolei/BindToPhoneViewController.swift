//
//  BindToPhoneViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/9/23.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class BindToPhoneViewController: UIViewController{

    @IBOutlet var verifyCodeView: UIView!
    @IBOutlet var phoneView: UIView!
    @IBOutlet var phoneImgView: UIImageView!
    @IBOutlet var verifyCodeImgView: UIImageView!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var veriftCodeTextField: UITextField!
    @IBOutlet var getVerifyCodeBtn: UIButton!
    @IBOutlet var finishBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUpNavigationController()
        self.setUpInitialLooking()
        self.setUpActions()
        self.setUpOnlineData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigationController(){
        Consts.setUpNavigationBarWithBackButton(self, title: "绑定手机", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        self.view.backgroundColor = Consts.grayView
        //phoneView
        self.phoneView.layer.cornerRadius = 7.0
        self.verifyCodeView.layer.cornerRadius = 7.0
        
        //phoneImgView
//        self.phoneImgView.image = Consts.imageFromColor(Consts.tintGreen, size: self.phoneImgView.frame.size)
        
        //verifyCodeImgView
//        self.verifyCodeImgView.image = Consts.imageFromColor(Consts.tintGreen, size: self.verifyCodeImgView.frame.size)
        
        //verifyCodeBtn
        self.getVerifyCodeBtn.layer.borderColor = Consts.tintGreen.CGColor
        
    }
    
    func setUpActions(){
        
    }

    func setUpOnlineData(){
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func finish(sender: UIButton) {
        let verifyCode:NSString = self.veriftCodeTextField.text!
        if !Consts.checkPhoneNum(self.phoneTextField.text!){
            Tool.showErrorHUD("请输入正确的手机号!")
        }else if verifyCode.length == 0{
            Tool.showErrorHUD("请输入验证码!")//此处需要检测验证码!!!
        }else{
            //绑定手机完成后去设置个人信息
        let personalInfoViewController = PersonalInfoViewController()
        self.navigationController?.pushViewController(personalInfoViewController, animated: true)
        }
    }

    @IBAction func startTime(sender: UIButton) {
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
        
    ///实现点击UIView内部关闭键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
