//
//  PersonCenterVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/22.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

class PersonCenterVC: UIViewController,APIDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var photoBtn: UIButton!//tag:0
    
    @IBOutlet var nameBtn: UIButton!
    
    @IBOutlet var idleBtn: UIButton!//tag:1
    
    @IBOutlet var collectBtn: UIButton!//tag:2
    
    @IBOutlet var table: UITableView!
    
    var plistDict = NSMutableDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setUpInitialLooking()
        self.setUpActions()
    }

    override func viewWillAppear(animated: Bool) {
//      由于perosninfomationviewcontroller中的修改对本页显示内容有影响，
//       从A push到 B,再从B pop 到 A,A中viewDidLoad()不会再调用,而viewWillAppear()会重新调用
        self.setUpInitialLooking()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "个人中心", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        self.view.backgroundColor = Consts.grayView
        
        self.plistDict = NSMutableDictionary(contentsOfFile: AppDelegate.filePath)!
        
//        发现plistDict仍只有三个元素
        
//      用户未登录时
        if(self.plistDict["isLogin"] as! Bool == false){
            self.photoBtn.setBackgroundImage(UIImage.init(named: "photo_button_apply"), forState: .Normal)
            self.nameBtn.setTitle("登录 / 注册", forState: .Normal)
            self.nameBtn.setTitleColor(Consts.tintGreen, forState: .Normal)
            self.nameBtn.layer.borderColor = Consts.tintGreen.CGColor
            self.nameBtn.layer.cornerRadius = 3
            self.nameBtn.layer.borderWidth = 1
            self.nameBtn.tag = 3
            
        }else{
            self.photoBtn.setBackgroundImage(UIImage.init(data: plistDict["photo"] as! NSData), forState: .Normal)
            self.nameBtn.setTitle(plistDict["name"] as! String, forState: .Normal)
            self.nameBtn.layer.borderWidth = 0
            self.nameBtn.setTitleColor(Consts.black, forState: .Normal)
            self.nameBtn.tag = 0
        }
        
    }
    
    func setUpActions(){
        let nib = UINib(nibName: "cellWithLabel", bundle: nil)
        self.table.registerNib(nib, forCellReuseIdentifier: "cellWithLabel")
    }
    
    func setUpOnlineData(){
        
    }

    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnClicked(sender: UIButton) {
        switch(sender.tag){
        case 0://个人信息
            if(!AppDelegate.isLogin){
                Tool.showErrorHUD("请先登录!")
            }else{
                let vc = PersonalInfomationViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case 1://闲置
            if(!AppDelegate.isLogin){
                Tool.showErrorHUD("请先登录!")
            }else{
                
            }
            break
        case 2://收藏
            if(!AppDelegate.isLogin){
                Tool.showErrorHUD("请先登录!")
            }else{
                
            }
            break
        case 3://提示去注册/登录
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            
            break
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 3
        }else{
            return 2
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if (section == 0){
            return 25 * Consts.ratio
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = cellWithLabel()
        return cell.frame.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithIdentifier("cellWithLabel", forIndexPath: indexPath) as! cellWithLabel
        if(indexPath.section == 0){
            switch(indexPath.row){
            case 0:
                cell.imgView?.image = UIImage.init(named: "my center_button_idle things")
                cell.label?.text = "我的订单"
                break
            case 1:
                cell.imgView?.image = UIImage.init(named: "my center_button_idle things")
                cell.label?.text = "我的万能优惠卡"
                break
            case 2:
                cell.imgView?.image = UIImage.init(named: "my center_button_idle things")
                cell.label?.text = "申请开店"
                break
            default:
                break
            }
        }else{
            switch(indexPath.row){
            case 0:
                cell.imgView?.image = UIImage(named: "my center_button_set")
                cell.label?.text = "设置"
                break
            case 1:
                cell.imgView?.image = UIImage.init(named: "setting_icon_suggestion")
                cell.label?.text = "意见反馈"
                break
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.table.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.section == 0){
            switch(indexPath.row){
            case 0://我的订单
                if(!AppDelegate.isLogin){
                    Tool.showErrorHUD("请先登录!")
                }else{
                    let vc = OrdersVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case 1://优惠卡
                if(!AppDelegate.isLogin){
                    Tool.showErrorHUD("请先登录!")
                }else{
                    let vc = CouponViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case 2://申请开店
                if(!AppDelegate.isLogin){
                    Tool.showErrorHUD("请先登录!")
                }else{
                    
                }
                break
            default:
                break
            }
        }else{
            switch(indexPath.row){
            case 0:
                if(!AppDelegate.isLogin){
                    Tool.showErrorHUD("请先登录!")
                }else{
                    let vc = SettingViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case 1:
                if(!AppDelegate.isLogin){
                    Tool.showErrorHUD("请先登录!")
                }else{
                    let vc = UserFeedbackViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            default:
                break
            }
        }
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        
    }
}
