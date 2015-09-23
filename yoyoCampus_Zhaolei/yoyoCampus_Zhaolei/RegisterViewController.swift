//
//  RegisterViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/9/22.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var img = UIImage()
    
    var phoneView = UIView()
    
    var verifyCodeView = UIView()
    
    var pwdView = UIView()
    
    var pwdAgainView = UIView()
    
    var phoneImg = UIImageView()
    
    var verifyCodeImage = UIImageView()
    
    var pwdImage = UIImageView()
    
    var pwdAgainImage = UIImageView()
    
    var phoneTextField = UITextField()
    
    var verifyCodeTextField = UITextField()
    
    var pwdTextField = UITextField()
    
    var pwdAgainTextField = UITextField()
    
    var getVerifyCodeLabel = UILabel()
    
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
        Consts.setUpNavigationBarWithBackButton(self, title: "注册", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height
        
        self.view.backgroundColor = Consts.grayView
        
        
    }
    
    func setUpOnlineData(){
        
    }
    
    func setUpActions(){
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
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
