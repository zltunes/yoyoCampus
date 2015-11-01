//
//  bindVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/31.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

class bindVC: UIViewController,APIDelegate {
    
    internal var wechatOpenid = ""
    
    internal var wechatAccessToken = ""
    
    var api = YoYoAPI()
    
    var wechatRegisterURL:String = ""
    
    var wechatBindURL:String = ""
    
    @IBOutlet var photo: UIImageView!
    
    @IBOutlet var wechat_nameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationBar()
        self.setUpActions()
        self.setUpInitialLooking()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "关联账号", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        self.view.backgroundColor = Consts.grayView
        
        self.photo.sd_setImageWithURL(AppDelegate.wechat_photoURL, placeholderImage: UIImage.init(named: "bear_icon_register"))
        self.wechat_nameLabel.text = AppDelegate.wechat_name
        
    }
    
    func setUpActions(){
        self.api.delegate = self
        
    }
    
    func setUpOnlineData(tag:String){
        switch(tag){
            case "wechatRegister":
                self.wechatRegisterURL = "\(Consts.mainUrl)/v1.0/auth/weixin/register/"
                
            break
            
            case "wechatBind":
                self.wechatBindURL = "\(Consts.mainUrl)/v1.0/auth/weixin/bind/"
            break
            
        default:
            break
        }
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        switch(tag){
            case "wechatRegister":
                
            break
            
            case "wechatBind":
            
            break
            
        default:
            break
        }
    }
    
    @IBAction func btnClicked(sender: UIButton) {
        if(sender.tag == 0){
//            注册
            let vc = RegisterViewController()
            vc.registerType = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
//            关联
            setUpOnlineData("wechatBind")
        }
    }

}
