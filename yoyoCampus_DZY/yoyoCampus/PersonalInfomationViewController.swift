//
//  PersonalInfomationViewController.swift
//  yoyoCampus
//
//  Created by DuZhiXia on 15/9/19.
//  Copyright © 2015年 DuZhiXia. All rights reserved.
//

import UIKit

class PersonalInfomationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

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
        Consts.setUpNavigationBarWithBackButton(self, title: "个人信息", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height
        
        self.view.backgroundColor = Consts.grayView
        
        let wtf = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(wtf)
        
        self.personTable.frame = CGRect(x: 0, y: 64, width: newWidth, height: newHeight)
        self.personTable.backgroundColor = Consts.grayView
        self.personTable.layoutMargins = UIEdgeInsetsZero
        self.personTable.separatorInset = UIEdgeInsetsZero
        self.view.addSubview(self.personTable)
    }
    
    func setUpActions(){
        self.personTable.delegate = self
        self.personTable.dataSource = self
        self.personTable.registerClass(PersonInfomationCell1.self, forCellReuseIdentifier: "PersonInfomationCell1")
        self.personTable.registerClass(PersonInfomationCell2.self, forCellReuseIdentifier: "PersonInfomationCell2")
        self.personTable.registerClass(PersonInfomationCell3.self, forCellReuseIdentifier: "PersonInfomationCell3")
    }
    
    func setUpOnlineData(){
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }


    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(tableView == self.personTable){
            if(indexPath.section == 0){
                if(indexPath.row == 0){
                    let cell = tableView.dequeueReusableCellWithIdentifier("PersonInfomationCell1", forIndexPath: indexPath)as! PersonInfomationCell1
                    cell.img.center.x = tableView.frame.width / 2
                    cell.separatorInset = Consts.tableSeperatorEdge
                    cell.layoutMargins = Consts.tableSeperatorEdge
                    return cell
                }else if(indexPath.row > 0)&&(indexPath.row < 3){
                    let cell = tableView.dequeueReusableCellWithIdentifier("PersonInfomationCell2", forIndexPath: indexPath)as! PersonInfomationCell2
                    switch (indexPath.row){
                    case 1:
                        cell.label1.text = "昵称"
                        cell.label1.sizeToFit()
                        cell.label2.text = "哈哈呼呼"
                        cell.label2.sizeToFit()
                    case 2:
                        cell.label1.text = "性别"
                        cell.label1.sizeToFit()
                        cell.label2.text = "男"
                        cell.label2.sizeToFit()
                    default:
                        break
                    }
                    cell.separatorInset = Consts.tableSeperatorEdge
                    cell.layoutMargins = Consts.tableSeperatorEdge
                    return cell
                }else{
                    return UITableViewCell()
                }
            }else if(indexPath.section == 1){
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonInfomationCell2", forIndexPath: indexPath)as! PersonInfomationCell2
                switch (indexPath.row){
                case 0:
                    cell.label1.text = "绑定手机"
                    cell.label1.sizeToFit()
                    cell.label2.text = "13365208080"
                    cell.label2.sizeToFit()
                case 1:
                    cell.label1.text = "学校"
                    cell.label1.sizeToFit()
                    cell.label2.text = "东南大学"
                    cell.label2.sizeToFit()
                case 2:
                    cell.label1.text = "入学年份"
                    cell.label1.sizeToFit()
                    cell.label2.text = "2014"
                    cell.label2.sizeToFit()
                default:
                    break
                }
                cell.separatorInset = Consts.tableSeperatorEdge
                cell.layoutMargins = Consts.tableSeperatorEdge
                return cell
            }else if(indexPath.section == 2){
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonInfomationCell3", forIndexPath: indexPath)as! PersonInfomationCell3
                switch (indexPath.row){
                case 0:
                    cell.img.image = Consts.imageFromColor(UIColor.redColor(), size: cell.img.frame.size)
                case 1:
                    cell.img.image = Consts.imageFromColor(UIColor.greenColor(), size: cell.img.frame.size)
                default:
                    break
                }
                cell.label.frame.origin.x = tableView.frame.width - cell.label.frame.width - 20 * Consts.ratio
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
                return 3
            }else if(section == 1){
                return 3
            }else if(section == 2){
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
                    let cell = PersonInfomationCell1()
                    return cell.frame.height
                }else if(indexPath.row > 0)&&(indexPath.row < 3){
                    let cell = PersonInfomationCell2()
                    return cell.frame.height
                }else{
                    return 60
                }
            }else if(indexPath.section == 1){
                let cell = PersonInfomationCell2()
                return cell.frame.height
            }else if(indexPath.section == 2){
                let cell = PersonInfomationCell3()
                return cell.frame.height
            }else{
                return 60
            }
        }else{
            return 60
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if(tableView == self.personTable){
            if(section < 2){
                let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30 * Consts.ratio))
                footer.backgroundColor = Consts.grayView
                return footer
            }else if(section == 2){
                let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60 * Consts.ratio))
                footer.backgroundColor = Consts.grayView
                return footer
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section < 2){
            return 30 * Consts.ratio
        }else if(section == 2){
            return 60 * Consts.ratio
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.personTable){
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
