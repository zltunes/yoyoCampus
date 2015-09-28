//
//  SettingViewController.swift
//  yoyoCampus
//
//  Created by DuZhiXia on 15/9/15.
//  Copyright © 2015年 DuZhiXia. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    ///设置列表
    var settingTable = UITableView()
    
    ///退出登录
    var logOutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        Consts.setUpNavigationBarWithBackButton(self, title: "个人设置", backTitle: "<")
        let right = UIBarButtonItem(title: "测试", style: .Plain, target: self, action: "test")
        right.tintColor = Consts.white
        self.navigationItem.rightBarButtonItem = right
    }
    
    func test(){
        let vc = TestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    func setUpInitialLooking(){
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
        self.logOutButton.bounds = CGRect(x: 0, y: 0, width: 500 * Consts.ratio, height: 64 * Consts.ratio)
        self.logOutButton.backgroundColor = Consts.tintGreen
        self.logOutButton.titleLabel?.font = Consts.ft14
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
        
        self.logOutButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
    }
    
    func setUpOnlineData(){
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func buttonClicked(sender: UIButton){
        if(sender.titleLabel?.text == "退 出 登 录"){
            print("退出登录")
            Tool.showSuccessHUD("退出登录")
        }
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
                print("check update")
                Tool.showSuccessHUD("检查更新")
            case 1:
                print("feedback")
                let vc = UserFeedbackViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
    
    func setUpTableViewCell(tableView: UITableView,indexPath:NSIndexPath, cell: SettingCell)-> SettingCell{
        if(tableView == self.settingTable){
//            cell.icon.frame = CGRect(x: 20 * Consts.ratio, y: 20 * Consts.ratio, width: 64 * Consts.ratio, height: 64 * Consts.ratio)
            cell.icon.image = Consts.imageFromColor(UIColor.orangeColor(), size: cell.icon.frame.size)
//            cell.addSubview(cell.icon)
            if(indexPath.section == 0){
                cell.label.text = "检查更新"
                cell.label.sizeToFit()
            }else if(indexPath.section == 1){
                cell.label.text = "用户反馈"
                cell.label.sizeToFit()
            }
//            cell.label.font = Consts.ft15
//            cell.label.textColor = Consts.lightGray
//            cell.label.sizeToFit()
//            cell.label.center = CGPoint(x: cell.icon.frame.maxX + 40 * Consts.ratio + cell.label.frame.width / 2, y: cell.icon.center.y)
//            cell.addSubview(cell.label)
//            cell.accessoryType = .DisclosureIndicator
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
