//
//  PersonalInfoViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/9/24.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class PersonalInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AFPickerViewDataSource,AFPickerViewDelegate{

    @IBOutlet var photoImgView: UIImageView!
    @IBOutlet var table: UITableView!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var alert: CustomIOSAlertView!
    @IBOutlet var picker: AFPickerView!
    @IBOutlet var alertDetail: UIView!
    
    @IBOutlet var alertLabel: UILabel!
    
    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet var confirmBtn: UIButton!
    
    ///滚动数据
    var pickerData: NSMutableArray = []
    
    ///picker当前选择缓存
    var pickerCache = "入学年份"
    
    
    ///用户所填写信息暂存
    var infoData:NSMutableDictionary = ["name":" ","school":" ","startYear":" "]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpNavigationController()
        self.setUpInitialLooking()
        self.setUpAlertView()
        self.setUpActions()
        self.setUpOnlineData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigationController(){
            Consts.setUpNavigationBarWithBackButton(self, title: "个人信息", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        self.view.backgroundColor = Consts.grayView
    }
    
    func setUpAlertView(){
        
        let filePath = NSBundle.mainBundle().pathForResource("data", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: filePath!)
        self.pickerData = dict?.valueForKey("pickerData") as! NSMutableArray
        
        //pickerView
        self.picker.backgroundColor = Consts.grayView
        self.picker.rowColorSelected = Consts.tintGreen
        self.picker.rowColorCommon = Consts.lightGray
        self.picker.rowFont = Consts.ft16
        self.picker.rowFontSelected = Consts.ft18
        self.picker.rowHeight = (self.picker.frame.height) / 3.02
        self.picker.halfRowNum = 1
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.reloadData()
        //alert
        self.alert.containerView = self.alertDetail
    }
    
    func showAlert(sender:UIButton){
        self.alert.show()
    }
    func setUpActions(){
        self.table.dataSource = self
        self.table.delegate = self
        self.table.registerClass(cellWithTextField.self, forCellReuseIdentifier: "cellWithTextField")
        self.table.registerClass(cellWithBtn.self, forCellReuseIdentifier: "cellWithBtn")
    }
    
    func setUpOnlineData(){
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldChanged(sender:UITextField){
        if sender.tag == 0{
            self.infoData.setValue(sender.text, forKey: "name")
        }else if sender.tag == 1{
            self.infoData.setValue(sender.text, forKey: "school")
        }
    }

    @IBAction func ButtonClicked(sender: UIButton) {
        if(sender.titleLabel?.text == "取消"){
            self.alert.close()
        }else if (sender.titleLabel?.text == "确定"){
            self.infoData.setValue(self.pickerCache, forKey: "startYear")
            self.table.reloadData()
            self.alert.close()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row != 2{
        let cell = self.table.dequeueReusableCellWithIdentifier("cellWithTextField", forIndexPath: indexPath)as! cellWithTextField
            switch(indexPath.row){
            case 0:
                cell.textLabel!.text = "昵称"
                cell.textField.text = self.infoData.objectForKey("name")as? String
                cell.textField.tag = 0
                break
            case 1:
                cell.textLabel?.text = "学校"
                cell.textField.text = self.infoData.objectForKey("school")as? String
                cell.textField.tag = 1
                break
            default:
                break
            }
            cell.textField.addTarget(self, action: "textFieldChanged:", forControlEvents: .EditingDidEnd)
            return cell
        }else{
            let cell = self.table.dequeueReusableCellWithIdentifier("cellWithBtn", forIndexPath: indexPath) as! cellWithBtn
            cell.button.setTitle(self.infoData.valueForKey("startYear")as? String, forState: .Normal)
            cell.separatorInset = Consts.tableSeperatorEdge
            cell.layoutMargins = Consts.tableSeperatorEdge
            cell.button.addTarget(self, action: "showAlert:", forControlEvents: .TouchUpInside)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.table.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //pickerView delegate
    
    func pickerView(pickerView: AFPickerView!, didSelectRow row: Int) {
        self.pickerCache = self.pickerData.objectAtIndex(row)as! String
    }
    
    func pickerView(pickerView: AFPickerView!, titleForRow row: Int) -> String! {
        return self.pickerData.objectAtIndex(row) as! String
    }
    
    func numberOfRowsInPickerView(pickerView: AFPickerView!) -> Int {
        return self.pickerData.count
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
