//
//  SettingViewController.swift
//  yoyoCampus
//
//  Created by DuZhiXia on 15/9/15.
//  Copyright © 2015年 DuZhiXia. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,APIDelegate {
    
    ///设置列表
    var settingTable = UITableView()
    
    ///退出登录
    var logOutButton = UIButton()
    
    var api = YoYoAPI()
    
    var logoutURL:String = ""
    
    var plistDict = NSMutableDictionary()

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
        Consts.setUpNavigationBarWithBackButton(self, title: "设置", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        plistDict = NSMutableDictionary(contentsOfFile: AppDelegate.filePath)!
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height - 64
        
        self.view.backgroundColor = Consts.grayView
        
        let wtf = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(wtf)
        
        self.settingTable.frame = CGRect(x: 0, y: 64 + 20 * Consts.ratio, width: newWidth, height: 250 * Consts.ratio)
        self.settingTable.backgroundColor = Consts.grayView
        self.settingTable.scrollEnabled = false
        self.view.addSubview(self.settingTable)
        
        self.logOutButton.center = CGPoint(x: newWidth / 2, y: 64 + newHeight / 2)
        self.logOutButton.bounds = CGRect(x: 0, y: 0, width: 600 * Consts.ratio, height: 90 * Consts.ratio)
        self.logOutButton.backgroundColor = Consts.tintGreen
        self.logOutButton.titleLabel?.font = Consts.ft20
        self.logOutButton.layer.cornerRadius = Consts.radius
        self.logOutButton.layer.masksToBounds = true
        self.logOutButton.setTitle("退 出 登 录", forState: .Normal)
        self.logOutButton.setTitleColor(Consts.btnTitleColor, forState: .Normal)
        self.logOutButton.setTitleColor(Consts.highlightedLightGray, forState: .Highlighted)
        self.view.addSubview(self.logOutButton)
    }
    
    func setUpActions(){
        self.settingTable.registerClass(SettingCell.self, forCellReuseIdentifier: "settingCell")
        self.settingTable.delegate = self
        self.settingTable.dataSource = self
        api.delegate = self
        
        self.logOutButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
    }
    
    func setUpOnlineData(tag:String){
        self.logoutURL = "\(Consts.mainUrl)/v1.0/auth/logout/"
        switch(tag){
            case "logout":
                print("onlinedata")
                api.httpRequest("DELETE", url: self.logoutURL, params: nil, tag: "logout")
            break
            
            case "update":
            
            break
            
        default:
            break
        }
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func buttonClicked(sender: UIButton){
        setUpOnlineData("logout")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath)as! SettingCell
        cell = self.setUpTableViewCell(tableView, indexPath: indexPath, cell: cell)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.settingTable){
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            switch (indexPath.section){
            case 0:
                Tool.showSuccessHUD("当前已是最新版!")
                break
            case 1://跳转至关于界面
                let vc = AboutVC()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
        }
    }
    
    func setUpTableViewCell(tableView: UITableView,indexPath:NSIndexPath, cell: SettingCell)-> SettingCell{
        if(tableView == self.settingTable){
            if(indexPath.section == 0){
                cell.icon.image = UIImage.init(named: "setting_icon_update")
                cell.label.text = "检查更新"
                cell.label.sizeToFit()
            }else if(indexPath.section == 1){
                cell.icon.image = UIImage.init(named: "my center_button_about")
                cell.label.text = "关于我们"
                cell.label.sizeToFit()
            }
            return cell
        }else{
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cell = SettingCell()
        cell = self.setUpTableViewCell(tableView, indexPath: indexPath, cell: cell)
        return cell.frame.height
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1))
        return footer
    }

    func didReceiveJsonResults(json: JSON, tag: String) {
        switch(tag){
            case "logout":
                print("logout")
                plistDict.setObject(false, forKey: "isLogin")
                plistDict.setObject("", forKey: "tel")
                plistDict.setObject("", forKey: "access_token")
                plistDict.setObject("", forKey: "photo")
                plistDict.setObject("", forKey: "name")
                plistDict.setObject("", forKey: "enroll_year")
                plistDict.setObject("", forKey: "location")
                plistDict.setObject(0, forKey: "weibo_bind")
                plistDict.setObject(0, forKey: "weixin_bind")
                plistDict.writeToFile(AppDelegate.filePath, atomically: true)
            
                AppDelegate.isLogin = false
                AppDelegate.access_token = ""
                AppDelegate.tel = ""
                AppDelegate.location = ""
            
            self.logOutButton.hidden = true
            
            case "update":
            
            break
            
        default:
            break
        }
    }

}
