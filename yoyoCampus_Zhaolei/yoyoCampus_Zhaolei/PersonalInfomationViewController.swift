//
//  PersonalInfomationViewController.swift
//  yoyoCampus
//
//  Created by DuZhiXia on 15/9/19.
//  Copyright © 2015年 DuZhiXia. All rights reserved.
//

import UIKit
import SwiftyJSON

class PersonalInfomationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,AFPickerViewDataSource,AFPickerViewDelegate ,APIDelegate,UINavigationControllerDelegate{

    var personTable = UITableView()
    
    //弹窗：滚轮
    var alert = CustomIOSAlertView()
    
    //弹窗：编辑昵称
    var alertWithName = CustomIOSAlertView()
    
    ///滚动选择
    var picker = AFPickerView()
    
    ///编辑昵称输入框
    var changeNameTextField = UITextField()
    
    ///滚动数据
    var pickerData: NSMutableArray = []
    
    ///picker当前选择缓存
    var pickerCache = "入学年份"
    
    ///图片上传标记
    var imgUploaded = false
    
    
    ///七牛云上传所需token和key，从服务器获取
    var qiniuToken:String = ""
    var qiniuKey:String = ""
    
    ///七牛云manager
    var upManager = QNUploadManager()
    
    ///图片编码
    var imgData = NSData()
    
    ///用户所填写信息暂存
//    var infoData = ["name":"呵呵","location":"东南大学","enroll_year":"2014","image":"","phone_num":"15651907759"]
    
    var param = ["":""]
    
    var plisDict = NSMutableDictionary()
    
    ///上传
    var uploadURL:String = ""
    
    ///用户信息更新
    var userInfoUpdateURL:String = ""
    
    var api = YoYoAPI()
    
    var lastVC = PersonCenterVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpNavigationBar()
        self.setUpInitialLooking()
        self.setUpActions()
        self.setUpAlertView()
        self.setUpAlertViewWithName()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.plisDict["location"] = AppDelegate.location
        self.plisDict.writeToFile(AppDelegate.filePath, atomically: true)
        self.param["location"] = AppDelegate.location
        self.personTable.reloadData()
        super.viewWillAppear(animated)
    }
    
    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "个人信息", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        
        self.plisDict = NSMutableDictionary(contentsOfFile: AppDelegate.filePath)!

        
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height
        
        self.view.backgroundColor = Consts.grayView
        
        let wtf = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(wtf)
        
        self.personTable.frame = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        self.personTable.backgroundColor = Consts.grayView
        self.personTable.layoutMargins = UIEdgeInsetsZero
        self.personTable.separatorInset = UIEdgeInsetsZero
        self.view.addSubview(self.personTable)
    }
    
    func setUpActions(){
        self.personTable.delegate = self
        self.personTable.dataSource = self
        self.personTable.scrollEnabled = false
        self.personTable.registerClass(PersonInfomationCell1.self, forCellReuseIdentifier: "PersonInfomationCell1")
        self.personTable.registerClass(PersonInfomationCell2.self, forCellReuseIdentifier: "PersonInfomationCell2")
        self.personTable.registerClass(PersonInfomationCell3.self, forCellReuseIdentifier: "PersonInfomationCell3")

        self.api.delegate = self
        
        let manager = IQKeyboardManager.sharedManager;
        manager().enable = true;
        //设置点击背景键盘收回
        manager().shouldResignOnTouchOutside = true;
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
    
    
    func setUpOnlineData(tag:String){
        
        switch(tag){
            
        case "token":
            self.uploadURL = "\(Consts.mainUrl)/v1.0/static/token/"
            //1:获取token
            api.httpRequest("POST", url: self.uploadURL, params: nil, tag: "token")
            break
            
        case "info":
            self.userInfoUpdateURL = "\(Consts.mainUrl)/v1.0/user/"
            //2:更新用户信息
            api.httpRequest("PUT", url: self.userInfoUpdateURL, params: self.param, tag: "info")
            break
            
        default:
            break
            
        }

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
                    cell.img.image = UIImage.init(data: plisDict["photo"] as! NSData)
                    cell.separatorInset = Consts.tableSeperatorEdge
                    cell.layoutMargins = Consts.tableSeperatorEdge
                    return cell
                }else if(indexPath.row > 0)&&(indexPath.row < 2){
                    let cell = tableView.dequeueReusableCellWithIdentifier("PersonInfomationCell2", forIndexPath: indexPath)as! PersonInfomationCell2
                    switch (indexPath.row){
                    case 1:
                        cell.label1.text = "昵称"
                        cell.label1.sizeToFit()
//                        cell.label2.text = self.infoData["name"]
                        cell.label2.text = self.plisDict["name"] as? String
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
                    cell.label2.text = self.plisDict["tel"] as? String
                    cell.accessoryType = .None
                    cell.label2.sizeToFit()
                case 1:
                    cell.label1.text = "学校"
                    cell.label1.sizeToFit()
                    cell.label2.text = self.plisDict["location"] as? String
                    cell.label2.sizeToFit()
                case 2:
                    cell.label1.text = "入学年份"
                    cell.label1.sizeToFit()
                    cell.label2.text = self.plisDict["enroll_year"] as? String
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
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.personTable){
            if(section == 0){
                return 2
            }else if(section == 1){
                return 3
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
        return 2
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
            
            if(indexPath.section == 0){//section0
                switch(indexPath.row){
                case 0://头像
                    self.uploadImage()
                    break
                case 1://昵称
                    self.alertWithName.show()
                    break
                default:
                    break
                }
            }else if(indexPath.section == 1){//section1
                switch(indexPath.row){
                case 0://绑定手机
                    
                    break
                case 1://学校
                    let vc = SelectLocationVC()
                    vc.isEditPersonInfo = true
                    self.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case 2://入学年份
                    self.alert.show()
                    break
                default:
                    break
                }
            }
        }
    }

    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if(buttonIndex == 1){
            self.goCamera()
        }else if(buttonIndex == 2){
            self.goImage()
        }else if(buttonIndex == 0){
            
        }
    }
    
    func uploadImage() {
        let newSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","相册")
        newSheet.showInView(self.view)
    }

    ///打开相机
    func goCamera(){
        
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        var sourceType = UIImagePickerControllerSourceType.Camera
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
        
        self.presentViewController(picker, animated: true, completion: nil)//进入照相界面
    }
    
    func goImage(){
        
        let pickerImage = UIImagePickerController()
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            pickerImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(pickerImage.sourceType)!
        }
        
        pickerImage.delegate = self
        pickerImage.allowsEditing = true
        
        self.presentViewController(pickerImage, animated: true, completion: nil)
    }
    ///选好照片后
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    
        let indexpath = NSIndexPath(forRow: 0, inSection: 0)
        let cell =  self.personTable.cellForRowAtIndexPath(indexpath) as! PersonInfomationCell1
        let operatedImg = Consts.handlePicture(image, aimSize: cell.img.frame.size, zipped: false)
        cell.img.image = operatedImg
        self.imgUploaded = true
        
        //        将选好的img转化为nsdata型，图片为jpeg格式
        self.imgData = UIImageJPEGRepresentation(operatedImg, 1.0)!
        
        setUpOnlineData("token")
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    ///取消选择后
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setUpAlertView(){
        let filePath = NSBundle.mainBundle().pathForResource("data", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: filePath!)
        self.pickerData = dict?.objectForKey("pickerData") as! NSMutableArray
        
        self.alert = CustomIOSAlertView()
        
        let alertDetail = UIView(frame: CGRect(x:0 , y: 0, width: 576 * Consts.ratio, height: 438 * Consts.ratio))
        alertDetail.backgroundColor = Consts.white
        
        let alertLabel = Consts.setUpLabel("入学年份", color: Consts.darkGray, font: Consts.ft18, x: 30 * Consts.ratio, y: 30 * Consts.ratio, centerX: nil)
        alertDetail.addSubview(alertLabel)
        
        //pickerView
        self.picker = AFPickerView(frame: CGRect(x: 0, y: 100 * Consts.ratio, width: 456 * Consts.ratio, height: 242 * Consts.ratio))
        self.picker.center.x = alertDetail.frame.width / 2
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
        alertDetail.addSubview(self.picker)
        
        let cancelButton = UIButton(frame: CGRect(x: 100 * Consts.ratio, y: picker.frame.maxY + 42 * Consts.ratio, width: 0, height: 0))
        cancelButton.setTitle("取消", forState: .Normal)
        let testLabel = Consts.setUpLabel("取消", color: Consts.darkGray, font: Consts.ft18, x: 100 * Consts.ratio, y: picker.frame.maxY + 42 * Consts.ratio, centerX: nil)
        cancelButton.titleLabel?.font = Consts.ft18
        cancelButton.sizeToFit()
        let btnUpMargin = (cancelButton.frame.height - testLabel.frame.height) / 2
        cancelButton.frame.origin.y -= btnUpMargin
        cancelButton.backgroundColor = Consts.white
        cancelButton.setTitleColor(Consts.darkGray, forState: .Normal)
        cancelButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        cancelButton.tag = 1
        alertDetail.addSubview(cancelButton)
        
        let confirmButton = UIButton(frame: CGRect(x: alertDetail.frame.width - cancelButton.frame.maxX, y: cancelButton.frame.origin.y, width: 0, height: 0))
        confirmButton.setTitle("确定", forState: .Normal)
        confirmButton.titleLabel?.font = Consts.ft18
        confirmButton.sizeToFit()
        confirmButton.backgroundColor = Consts.white
        confirmButton.setTitleColor(Consts.darkGray, forState: .Normal)
        confirmButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        confirmButton.tag = 2
        alertDetail.addSubview(confirmButton)
        
        alertDetail.frame = CGRect(x: alertDetail.frame.origin.x, y: alertDetail.frame.origin.y, width: alertDetail.frame.width, height: cancelButton.frame.maxY + 20 * Consts.ratio - btnUpMargin)
        alertDetail.layer.cornerRadius = Consts.alertRadius
        alertDetail.layer.masksToBounds = true
        self.alert.containerView = alertDetail
        self.alert.buttonTitles = nil
    }
    
    func setUpAlertViewWithName(){
        let alertDetail = UIView(frame: CGRect(x:0 , y: 0, width: 576 * Consts.ratio, height: 138 * Consts.ratio))
        alertDetail.backgroundColor = Consts.white
        
        let alertLabel = Consts.setUpLabel("编辑昵称", color: Consts.darkGray, font: Consts.ft18, x: 30 * Consts.ratio, y: 30 * Consts.ratio, centerX: nil)
        alertDetail.addSubview(alertLabel)
        
        self.changeNameTextField = UITextField(frame: CGRect(x: 0, y: 100 * Consts.ratio, width: 500 * Consts.ratio, height: 100 * Consts.ratio))
        self.changeNameTextField.font = Consts.ft15
        self.changeNameTextField.text = self.plisDict["name"] as? String
        self.changeNameTextField.center.x = alertDetail.frame.width/2
        self.changeNameTextField.backgroundColor = Consts.white
        self.changeNameTextField.layer.borderWidth = 1.0
        self.changeNameTextField.layer.borderColor = Consts.lightGray.CGColor
        self.changeNameTextField.layer.cornerRadius = 3.0
        alertDetail.addSubview(self.changeNameTextField)
        
        let cancelButton = UIButton(frame: CGRect(x: 100 * Consts.ratio, y: changeNameTextField.frame.maxY + 42 * Consts.ratio, width: 0, height: 0))
        cancelButton.setTitle("取消", forState: .Normal)
        let testLabel = Consts.setUpLabel("取消", color: Consts.darkGray, font: Consts.ft18, x: 100 * Consts.ratio, y: changeNameTextField.frame.maxY + 42 * Consts.ratio, centerX: nil)
        cancelButton.titleLabel?.font = Consts.ft18
        cancelButton.sizeToFit()
        let btnUpMargin = (cancelButton.frame.height - testLabel.frame.height) / 2
        cancelButton.frame.origin.y -= btnUpMargin
        cancelButton.backgroundColor = Consts.white
        cancelButton.setTitleColor(Consts.darkGray, forState: .Normal)
        cancelButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        cancelButton.tag = 3
        alertDetail.addSubview(cancelButton)
        
        let confirmButton = UIButton(frame: CGRect(x: alertDetail.frame.width - cancelButton.frame.maxX, y: cancelButton.frame.origin.y, width: 0, height: 0))
        confirmButton.setTitle("确定", forState: .Normal)
        confirmButton.titleLabel?.font = Consts.ft18
        confirmButton.sizeToFit()
        confirmButton.backgroundColor = Consts.white
        confirmButton.setTitleColor(Consts.darkGray, forState: .Normal)
        confirmButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        confirmButton.tag = 4
        alertDetail.addSubview(confirmButton)
        
        alertDetail.frame = CGRect(x: alertDetail.frame.origin.x, y: alertDetail.frame.origin.y, width: alertDetail.frame.width, height: cancelButton.frame.maxY + 20 * Consts.ratio - btnUpMargin)
        alertDetail.layer.cornerRadius = Consts.alertRadius
        alertDetail.layer.masksToBounds = true
        self.alertWithName.containerView = alertDetail
        self.alertWithName.buttonTitles = nil

    }
    
    func buttonClicked(sender: UIButton) {
        if(sender.tag == 1){//picker取消
            self.alert.close()
        }else if (sender.tag == 2){//picker确定
//            self.infoData.updateValue(self.pickerCache, forKey: "enroll_year")
            self.plisDict["enroll_year"] = self.pickerCache
            self.plisDict.writeToFile(AppDelegate.filePath, atomically: true)
            self.param = ["enroll_year":self.pickerCache]
            
//            更新enroll_year
            setUpOnlineData("info")
            
            self.personTable.reloadData()
            self.alert.close()
        }else if(sender.tag == 3){//编辑昵称取消
            self.alertWithName.close()
        }else{//编辑昵称确定
            if(self.changeNameTextField.text == ""){
                Tool.showErrorHUD("昵称不可为空!")
            }else{
//                self.infoData.updateValue(self.changeNameTextField.text!, forKey: "name")
                self.plisDict["name"] = self.changeNameTextField.text
                self.plisDict.writeToFile(AppDelegate.filePath, atomically: true)
                
                self.param = ["name":self.changeNameTextField.text!]
//                更新用户名
                setUpOnlineData("info")
                
                self.personTable.reloadData()
                self.alertWithName.close()
            }
        }
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        switch tag{
        case "token":
            qiniuToken = json["token"].string!
            qiniuKey = json["key"].string!
            self.param = ["image":qiniuKey]
            Tool.showProgressHUD("上传中")
            
            upManager.putData(self.imgData, key: qiniuKey, token: self.qiniuToken, complete: { (info, key, resp) -> Void in
                //                图片上传完毕后才向后台更新用户数据,同时更新plistDict
                self.plisDict["photo"] = self.imgData
                self.plisDict.writeToFile(AppDelegate.filePath, atomically: true)
                self.setUpOnlineData("info")
                }, option: nil)
            break
            
        case "info":
            Tool.showSuccessHUD("修改成功!")
            break
            
        default:
            break
        }
    }

}
