//
//  PersonalInfoViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/9/24.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

class PersonalInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,AFPickerViewDataSource,AFPickerViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,APIDelegate{
    
    @IBOutlet var uploadBtn: UIButton!

    @IBOutlet var table: UITableView!
    @IBOutlet var nextBtn: UIButton!

    ///提示图片label
    var staticLabel2 = UILabel()
    //弹窗：滚轮
    var alert = CustomIOSAlertView()
    
    ///滚动选择
    var picker = AFPickerView()
    
    ///滚动数据
    var pickerData: NSMutableArray = []
    
    ///picker当前选择缓存
    var pickerCache = "入学年份"
    
    ///点击手势----tableview点击键盘消失
    var tapGesture = UITapGestureRecognizer()
    
    ///图片上传标记
    var imgUploaded = false
    
    
    ///七牛云上传所需token，从服务器获取
    var upToken:String = ""
    
    ///七牛云manager
    var upManager = QNUploadManager()
    
    ///图片编码
    var imgData = NSData()
    
    ///用户所填写信息暂存
    var infoData:NSMutableDictionary = ["name":"","school":"","startYear":""]
    
    ///上传
    var uploadURL:String = Consts.mainUrl
    
    ///用户信息更新
    var userInfoUpdateURL:String = Consts.mainUrl
    
    var api = YoYoAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpNavigationController()
        self.setUpInitialLooking()
        self.setUpAlertView()
        self.setUpActions()
        self.setUpGestures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func uploadImage(sender: UIButton) {
        let newSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","相册")
        newSheet.showInView(self.view)
    
    }
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if(buttonIndex == 1){
            self.goCamera()
        }else if(buttonIndex == 2){
            self.goImage()
        }else if(buttonIndex == 0){
            print("取消选择")
        }
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
        
        self.uploadBtn.setImage(image,forState: .Normal)
        self.imgUploaded = true
        
//        将选好的img转化为nsdata型，图片为jpeg格式
        self.imgData = UIImageJPEGRepresentation(image, 1.0)!
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    ///取消选择后
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
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
        alertDetail.addSubview(cancelButton)
        
        let confirmButton = UIButton(frame: CGRect(x: alertDetail.frame.width - cancelButton.frame.maxX, y: cancelButton.frame.origin.y, width: 0, height: 0))
        confirmButton.setTitle("确定", forState: .Normal)
        confirmButton.titleLabel?.font = Consts.ft18
        confirmButton.sizeToFit()
        confirmButton.backgroundColor = Consts.white
        confirmButton.setTitleColor(Consts.darkGray, forState: .Normal)
        confirmButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        alertDetail.addSubview(confirmButton)
        
        alertDetail.frame = CGRect(x: alertDetail.frame.origin.x, y: alertDetail.frame.origin.y, width: alertDetail.frame.width, height: cancelButton.frame.maxY + 20 * Consts.ratio - btnUpMargin)
        alertDetail.layer.cornerRadius = Consts.alertRadius
        alertDetail.layer.masksToBounds = true
        self.alert.containerView = alertDetail
        self.alert.buttonTitles = nil

    }
    
    func showAlert(sender:UIButton){
        self.alert.show()
    }
    func setUpActions(){
        self.table.dataSource = self
        self.table.delegate = self
        let nibWithTextField = UINib(nibName: "cellWithTextField", bundle: nil)
        let nibWithBtn = UINib(nibName: "cellWithBtn", bundle: nil)
        self.table.registerNib(nibWithTextField, forCellReuseIdentifier: "cellWithTextField")
        self.table.registerNib(nibWithBtn, forCellReuseIdentifier: "cellWithBtn")
        self.api.delegate = self
    }
    
    func setUpOnlineData(){
        self.uploadURL = self.uploadURL.stringByAppendingString("/v1.0/static/token/")
        self.userInfoUpdateURL = self.userInfoUpdateURL.stringByAppendingString("/v1.0/user/")
        
        //            1:获取token
        api.httpRequest("POST", url: self.uploadURL, params: nil, tag: "0")
        //            用户信息更新
        //            向服务器上传图片
        upManager.putData(self.imgData, key: "key", token: self.upToken, complete: { (info, key, resp) -> Void in
            print(info)//QNResponseInfo
            print(resp)//NSDictionary
            }, option: nil)
        
        //           2:更新用户信息
        
    }
    
    func setUpGestures(){
        self.tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.tapGesture.cancelsTouchesInView = false
        self.table.addGestureRecognizer(self.tapGesture)
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

    @IBAction func buttonClicked(sender: UIButton) {
        self.dismissKeyboard()
        if(sender.titleLabel?.text == "取消"){
            self.alert.close()
        }else if (sender.titleLabel?.text == "确定"){
            self.infoData.setValue(self.pickerCache, forKey: "startYear")
            self.table.reloadData()
            self.alert.close()
        }
    }
    
    //下一步
    
    @IBAction func nextBtnClicked(sender: UIButton) {
        if !self.imgUploaded{
            Tool.showErrorHUD("请上传照片!")
        }else if (self.infoData["name"]?.isEqualToString("") == true){
            Tool.showErrorHUD("请输入昵称!")
        }else if (self.infoData["school"]?.isEqualToString("") == true){
            Tool.showErrorHUD("请输入学校!")
        }else if (self.infoData["startYear"]?.isEqualToString("") == true){
            Tool.showErrorHUD("请选择入学年份!")
        }else{

        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row != 2{
        let cell = self.table.dequeueReusableCellWithIdentifier("cellWithTextField", forIndexPath: indexPath)as! cellWithTextField
            switch(indexPath.row){
            case 0:
                cell.label.text = "昵称"
                cell.textField.text = self.infoData.objectForKey("name")as? String
                cell.textField.tag = 0
                break
            case 1:
                cell.label.text = "学校"
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
            cell.label.text = "入学年份"
            cell.button.setTitle(self.infoData.valueForKey("startYear")as? String, forState: .Normal)
            if(cell.button.titleLabel?.text == ""){
                cell.button.setTitleColor(Consts.holderGray, forState: .Normal)
            }else{
                cell.button.setTitleColor(Consts.lightGray, forState: .Normal)
            }
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
    
    
    ///实现点击UIView内部关闭键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    ///实现点击UITableView内部关闭键盘
    func dismissKeyboard(){
        let indexs : NSArray? = self.table.indexPathsForVisibleRows
        if(indexs != nil){
            for i in indexs!{
                let v = self.table.cellForRowAtIndexPath((i as! NSIndexPath))as? cellWithTextField
                if(v != nil){
                    if(v!.textField.isFirstResponder()){
                        v!.textField.resignFirstResponder()
                    }
                }
            }
        }
    }
    
    ///实现拖动时关闭键盘
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if(scrollView == self.table){
            scrollView.endEditing(true)
        }
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        switch tag{
        case 0://token
            self.upToken = json["token"].string
            break
        
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
