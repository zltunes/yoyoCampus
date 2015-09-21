//
//  PersonalCenterViewController.swift
//  yoyoCampus
//
//  Created by DuZhiXia on 15/9/19.
//  Copyright © 2015年 DuZhiXia. All rights reserved.
//

import UIKit

class PersonalCenterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var personTable = UITableView()
    
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
        Consts.setUpNavigationBarWithBackButton(self, title: "个人中心", backTitle: nil)
    }
    
    func setUpInitialLooking(){
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height
        
        self.view.backgroundColor = Consts.grayView
        
        let wtf = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(wtf)
        
        self.personTable.frame = CGRect(x: 0, y: 64, width: newWidth, height: newHeight - 96 * Consts.ratio)
        self.personTable.backgroundColor = Consts.grayView
        self.personTable.layoutMargins = UIEdgeInsetsZero
        self.personTable.separatorInset = UIEdgeInsetsZero
        self.view.addSubview(self.personTable)
    }
    
    func setUpActions(){
        self.personTable.delegate = self
        self.personTable.dataSource = self
        self.personTable.registerClass(PersonCenterCell2.self, forCellReuseIdentifier: "PersonCenterCell2")
        self.personTable.registerClass(PersonalCenterCell1.self, forCellReuseIdentifier: "PersonalCenterCell1")
    }
    
    func setUpOnlineData(){
        
    }
    
    func goBack(){
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(tableView == self.personTable){
            if(indexPath.section == 0){
                if(indexPath.row == 0){
                    let cell = tableView.dequeueReusableCellWithIdentifier("PersonCenterCell2", forIndexPath: indexPath)as! PersonCenterCell2
                    cell.img.userInteractionEnabled = false
                    cell.img.image = Consts.imageFromColor(UIColor.orangeColor(), size: cell.img.frame.size)
                    cell.img.center.x = CGFloat(tableView.frame.width) / 2
                    cell.label.text = "麦伊"
                    cell.label.sizeToFit()
                    cell.label.center.x = cell.img.center.x
                    cell.separatorInset = Consts.tableSeperatorEdge
                    cell.layoutMargins = Consts.tableSeperatorEdge
                    return cell
                }else if(indexPath.row > 0)&&(indexPath.row < 4){
                    let cell = tableView.dequeueReusableCellWithIdentifier("PersonalCenterCell1", forIndexPath: indexPath)as! PersonalCenterCell1
                    cell.icon.image = Consts.imageFromColor(Consts.tintGreen, size: cell.icon.frame.size)
                    switch (indexPath.row){
                    case 1:
                        cell.label.text = "我的闲置"
                    case 2:
                        cell.label.text = "我的收藏"
                    case 3:
                        cell.label.text = "我的店铺"
                    default:
                        break
                    }
                    cell.label.sizeToFit()
                    cell.separatorInset = Consts.tableSeperatorEdge
                    cell.layoutMargins = Consts.tableSeperatorEdge
                    return cell
                }else{
                    return UITableViewCell()
                }
            }else if(indexPath.section == 1){
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonalCenterCell1", forIndexPath: indexPath)as! PersonalCenterCell1
                cell.icon.image = Consts.imageFromColor(Consts.tintGreen, size: cell.icon.frame.size)
                switch (indexPath.row){
                case 0:
                    cell.label.text = "设置"
                case 1:
                    cell.label.text = "关于"
                default:
                    break
                }
                cell.label.sizeToFit()
                cell.separatorInset = Consts.tableSeperatorEdge
                cell.layoutMargins = Consts.tableSeperatorEdge
                return cell
            }else{
                return UITableViewCell()
            }
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.personTable){
            if(section == 0){
                return 4
            }else if(section == 1){
                return 2
            }else{
                return 1
            }
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView == self.personTable){
            if(indexPath.section == 0){
                if(indexPath.row == 0){
                    let cell = PersonCenterCell2()
                    return cell.frame.height
                }else if(indexPath.row > 0)&&(indexPath.row < 4){
                    let cell = PersonalCenterCell1()
                    return cell.frame.height
                }else{
                    return 60
                }
            }else if(indexPath.section == 1){
                let cell = PersonalCenterCell1()
                return cell.frame.height
            }else{
                return 60
            }
        }else{
            return 60
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if(section == 0){
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100 * Consts.ratio))
            footer.backgroundColor = Consts.grayView
            return footer
        }else if(section == 1){
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 150 * Consts.ratio))
            footer.backgroundColor = Consts.grayView
            return footer
        }else{
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 0){
            return 100 * Consts.ratio
        }else if(section == 1){
            return 150 * Consts.ratio
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.personTable){
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            if(indexPath.section == 0){
                if(indexPath.row == 0){
                    let vc = PersonalInfomationViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if(indexPath.row == 1){
                    Tool.showSuccessHUD("前往我的闲置")
                }else if(indexPath.row == 2){
                    Tool.showSuccessHUD("前往我的收藏")
                }else if(indexPath.row == 3){
                    Tool.showSuccessHUD("前往我的店铺")
                }
            }else if(indexPath.section == 1){
                if(indexPath.row == 0){
                    let vc = SettingViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if(indexPath.row == 1){
                    Tool.showSuccessHUD("创梦空间\n(DreamSpace Ltd. 2015)")
                }
            }
        }
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
