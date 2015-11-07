//
//  MyUploadGoodsViewController.swift
//  yoyoCampus
//
//  Created by DuZhiXia on 15/9/15.
//  Copyright © 2015年 DuZhiXia. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyUploadGoodsViewController: UIViewController,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITableViewDataSource,AFPickerViewDataSource,AFPickerViewDelegate,UITextFieldDelegate,ACEExpandableTableViewDelegate,APIDelegate{
    
    ///tags:
    //101:商品名称textField
    //102:商品价格textField
    //103:商品分类button
    //104:下一步button
    
    ///提示第几步label
    var staticLabel1 = UILabel()
    
    ///提示图片label
    var staticLabel2 = UILabel()
    
    ///上传图片按钮
    var uploadButton = UIButton()
    
    ///下一步按钮
    var nextButton = UIButton()
    
    ///信息table
    var infoTable = UITableView()
    
    ///弹窗1-滚轮
    var alert1 = CustomIOSAlertView()
    
    ///弹窗2—确认信息
    var alert2 = CustomIOSAlertView()
    
    ///滚动选择
    var picker = AFPickerView()
    
    var api = YoYoAPI()
    
    
    ///上传
    var uploadURL:String = ""
    
    var uploadGoodsInfoURL:String = ""
    
    ///闲置创建
    
    ///滚动数据
    var pickerData : NSMutableArray = ["生活用品","数码电子","课本","xxx","yyy","1","2","3","4","5"]
    
    ///picker当前选择缓存
    var pickerCache = "商品分类"
    
    ///成功后图片
    
    var successImg = UIImageView()
    
    ///成功后提示label-大
    var successLabel1 = UILabel()
    
    ///成功后提示label-小
    var successLabel2 = UILabel()
    
    ///查看详情
    var toGoodsButton = UIButton()
    
    ///返回主页
    var toMainPageButton = UIButton()
    
    ///当前状态,对应第几步:1-初始;
    var currentState = 1
    
    ///用户选择分类暂存
    var infoData : NSMutableDictionary = ["category":"商品分类","other":"","name":"","price":""]
    
    ///当前textview行高
    var textHeight : CGFloat = 80 * Consts.ratio
    
    ///点击手势
    var tapGesture = UITapGestureRecognizer()
    
    ///图片上传标记
    var imgUploaded = false

//    api param
    var param = ["":""]
    
    var imgData = NSData()
//  name,{image},category,price,{description}
    
    ///七牛云上传所需token和key，从服务器获取
    var qiniuToken:String = ""
    var qiniuKey:String = ""
    
    ///七牛云manager
    var upManager = QNUploadManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setUpNavigationBar()
        self.setUpInitialLooking()
        self.setUpActions()
        self.setUpGestures()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "请选择商品照片", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height
        
        self.view.backgroundColor = Consts.grayView
        
        self.staticLabel1 = Consts.setUpLabel("第一步:上传照片", color: Consts.darkGray, font: Consts.ft16, x: 42 * Consts.ratio, y: 34 * Consts.ratio,centerX: nil)
        self.view.addSubview(self.staticLabel1)
        
        self.uploadButton.frame = CGRect(x: 258 * Consts.ratio, y: 130 * Consts.ratio + self.staticLabel1.frame.maxY, width: 206 * Consts.ratio, height: 206 * Consts.ratio)
        self.uploadButton.setBackgroundImage(UIImage.init(named: "photo_button_apply"), forState: .Normal)
        self.view.addSubview(self.uploadButton)
        
        self.infoTable.frame = CGRect(x: 62 * Consts.ratio, y: self.staticLabel1.frame.maxY + 52 * Consts.ratio, width: (720 - 62 * 2) * Consts.ratio, height: 550 * Consts.ratio)
        self.infoTable.layer.borderWidth = 0.5
        self.infoTable.layer.cornerRadius = Consts.radius
        self.infoTable.hidden = true
        self.infoTable.backgroundColor = Consts.white
        self.infoTable.separatorInset = UIEdgeInsetsZero
        self.infoTable.layoutMargins = UIEdgeInsetsZero
//        self.infoTable.scrollEnabled = false
        self.view.addSubview(self.infoTable)
        
        self.staticLabel2 = Consts.setUpLabel("请为您的宝贝上传一张靓照吧!", color: Consts.lightGray, font: Consts.ft14, x: 146 * Consts.ratio, y: self.uploadButton.frame.maxY + 50 * Consts.ratio,centerX: self.uploadButton.center.x)
        self.view.addSubview(self.staticLabel2)
        
        self.nextButton = Consts.setUpButton("下 一 步", frame: CGRect(x: 74 * Consts.ratio, y: self.staticLabel2.frame.maxY + 86 * Consts.ratio, width: 572 * Consts.ratio, height: 96 * Consts.ratio),font: Consts.ft18, radius: Consts.radius)
        self.nextButton.tag = 104
        self.view.addSubview(self.nextButton)
        
        self.successImg.frame = CGRect(x: 0, y: 64 + 80 * Consts.ratio, width: 222 * Consts.ratio, height: 201 * Consts.ratio)
        self.successImg.center.x = newWidth / 2
        self.successImg.contentMode = .ScaleAspectFit
        self.successImg.image = Consts.imageFromColor(Consts.tintGreen, size: self.successImg.frame.size)
        self.successImg.hidden = true
        self.view.addSubview(self.successImg)
        
        self.successLabel1 = Consts.setUpLabel("发布成功!", color: Consts.tintGreen, font: Consts.ft24, x: 0, y: self.successImg.frame.maxY + 42 * Consts.ratio, centerX: newWidth / 2)
        self.successLabel1.hidden = true
        self.view.addSubview(self.successLabel1)
        
        self.successLabel2 = Consts.setUpLabel("商品售出后请及时下架哦", color: Consts.lightGray, font: Consts.ft14, x: 0, y: self.successLabel1.frame.maxY + 50 * Consts.ratio, centerX: newWidth / 2)
        self.successLabel2.hidden = true
        self.view.addSubview(self.successLabel2)
        
        self.toGoodsButton = Consts.setUpButton("查 看 商 品 详 情", frame: CGRect(x: 74 * Consts.ratio, y: self.successLabel2.frame.maxY + 84 * Consts.ratio, width: 572 * Consts.ratio, height: 96 * Consts.ratio), font: Consts.ft18, radius: Consts.radius)
        self.toGoodsButton.hidden = true
        self.view.addSubview(self.toGoodsButton)
        
        self.toMainPageButton = Consts.setUpButton("返 回 主 页", frame: CGRect(x: 74 * Consts.ratio, y: self.toGoodsButton.frame.maxY + 60 * Consts.ratio, width: 572 * Consts.ratio, height: 96 * Consts.ratio), font: Consts.ft18, radius: Consts.radius)
        self.toMainPageButton.hidden = true
        self.view.addSubview(self.toMainPageButton)
    }
    
    func setUpGestures(){
        self.tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.tapGesture.cancelsTouchesInView = false
        self.infoTable.addGestureRecognizer(self.tapGesture)
    }
    
    func setUpAlertViews(num:Int){
        self.alert1 = CustomIOSAlertView()
        self.alert2 = CustomIOSAlertView()
        if(num == 1){
            let alertDetail = UIView(frame: CGRect(x:0 , y: 0, width: 576 * Consts.ratio, height: 438 * Consts.ratio))
            alertDetail.backgroundColor = Consts.white
            
            let alertLabel = Consts.setUpLabel("商品分类", color: Consts.darkGray, font: Consts.ft18, x: 30 * Consts.ratio, y: 30 * Consts.ratio, centerX: nil)
            alertDetail.addSubview(alertLabel)
            
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
            self.alert1.containerView = alertDetail
            self.alert1.buttonTitles = nil
        }else if(num == 2){
            let alertDetail = UIView(frame: CGRect(x:0 , y: 0, width: 576 * Consts.ratio, height: 438 * Consts.ratio))
            alertDetail.backgroundColor = Consts.white
            
            let alertLabel = Consts.setUpLabel("确认商品信息", color: Consts.darkGray, font: Consts.ft18, x: 30 * Consts.ratio, y: 22 * Consts.ratio, centerX: nil)
            alertLabel.textAlignment = .Center
            alertDetail.addSubview(alertLabel)
            
            let goodsLabel1 = Consts.setUpLabel("商品名称:" + (self.infoData.objectForKey("name")as! String), color: Consts.tintGreen, font: Consts.ft18, x: 38 * Consts.ratio, y: alertLabel.frame.maxY + 40 * Consts.ratio, centerX: nil)
            alertDetail.addSubview(goodsLabel1)
            
            let goodsLabel2 = Consts.setUpLabel("商品价格:" + (self.infoData.objectForKey("price")as! String), color: Consts.tintGreen, font: Consts.ft18, x: goodsLabel1.frame.minX, y: goodsLabel1.frame.maxY + 46 * Consts.ratio, centerX: nil)
            alertDetail.addSubview(goodsLabel2)
            
            let goodsLabel3 = Consts.setUpLabel("信息描述:", color: Consts.tintGreen, font: Consts.ft18, x: goodsLabel1.frame.minX, y: goodsLabel2.frame.maxY + 46 * Consts.ratio, centerX: nil)
            alertDetail.addSubview(goodsLabel3)

            var str = self.infoData.objectForKey("other")as! NSString
            var checked = false
            var goodsLabel4 = UILabel()
            repeat{
                checked = true
                goodsLabel4 = Consts.setUpAttributedLabel(str as String,lineSpace: Consts.lineSpace, color: Consts.tintGreen, font: Consts.ft18, x: goodsLabel3.frame.maxX, y: goodsLabel3.frame.minY, width: alertDetail.frame.width - 38 * Consts.ratio - goodsLabel3.frame.maxX)
                if(goodsLabel4.frame.height > 250 * Consts.ratio){
                    str = str.substringToIndex(str.length - 4) + "..."
                    checked = false
                }
            }while(!checked)
            alertDetail.addSubview(goodsLabel4)
            
            let cancelButton = UIButton(frame: CGRect(x: 100 * Consts.ratio, y: goodsLabel4.frame.maxY + 42 * Consts.ratio, width: 0, height: 0))
            cancelButton.setTitle("返回修改", forState: .Normal)
            let testLabel = Consts.setUpLabel("返回修改", color: Consts.darkGray, font: Consts.ft18, x: 100 * Consts.ratio, y: goodsLabel4.frame.maxY + 42 * Consts.ratio, centerX: nil)
            cancelButton.titleLabel?.font = Consts.ft18
            cancelButton.sizeToFit()
            let btnUpMargin = (cancelButton.frame.height - testLabel.frame.height) / 2
            cancelButton.frame.origin.y -= btnUpMargin
            cancelButton.backgroundColor = Consts.white
            cancelButton.setTitleColor(Consts.darkGray, forState: .Normal)
            cancelButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
            alertDetail.addSubview(cancelButton)
            
            let confirmButton = UIButton(frame: CGRect(x: alertDetail.frame.width - cancelButton.frame.maxX, y: cancelButton.frame.origin.y, width: 0, height: 0))
            confirmButton.setTitle("确认提交", forState: .Normal)
            confirmButton.titleLabel?.font = Consts.ft18
            confirmButton.sizeToFit()
            confirmButton.backgroundColor = Consts.white
            confirmButton.setTitleColor(Consts.darkGray, forState: .Normal)
            confirmButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
            alertDetail.addSubview(confirmButton)
            
            alertDetail.frame = CGRect(x: alertDetail.frame.origin.x, y: alertDetail.frame.origin.y, width: alertDetail.frame.width, height: cancelButton.frame.maxY + 20 * Consts.ratio - btnUpMargin)
            alertDetail.layer.cornerRadius = Consts.alertRadius
            alertDetail.layer.masksToBounds = true
            self.alert2.containerView = alertDetail
            self.alert2.buttonTitles = nil
        }
    }
    
    func setUpActions(){
        api.delegate = self
        
        self.uploadButton.addTarget(self, action: "uploadImage", forControlEvents: .TouchUpInside)
        self.nextButton.addTarget(self, action: "nextClicked", forControlEvents: .TouchUpInside)
        
        self.infoTable.registerClass(UploadGoodsCell1.self, forCellReuseIdentifier: "UploadGoodsCell1")
        self.infoTable.registerClass(UploadGoodsCell2.self, forCellReuseIdentifier: "UploadGoodsCell2")
        self.infoTable.registerClass(UploadGoodsCell3.self, forCellReuseIdentifier: "UploadGoodsCell3")
        self.infoTable.delegate = self
        self.infoTable.dataSource = self
        
        self.toGoodsButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        self.toMainPageButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        
        
        
    }
    
    func setUpOnlineData(tag:String){
        switch(tag){
            case "token":
            self.uploadURL = "\(Consts.mainUrl)/v1.0/static/token/"
            api.httpRequest("POST", url: self.uploadURL, params: nil, tag: "token")
            break
        
            case "info":
            self.uploadGoodsInfoURL = "\(Consts.mainUrl)/v1.0/idle/"
            api.httpRequest("POST", url: self.uploadGoodsInfoURL, params: self.param, tag: "info")
            break
            
        default:
            break
        }
        
        
    }
    
    func goBack(){
        if(self.currentState == 1){
            self.navigationController?.popViewControllerAnimated(true)
        }else if(self.currentState == 2){
            self.staticLabel1.text = "第一步:上传照片"
            self.staticLabel1.sizeToFit()
            self.uploadButton.hidden = false
            self.staticLabel2.hidden = false
            self.infoTable.hidden = true
            self.nextButton.frame.origin.y = self.staticLabel2.frame.maxY + 86 * Consts.ratio
            Consts.setUpNavigationBarWithBackButton(self, title: "请选择商品照片", backTitle: "<")
            self.currentState = 1
        }
    }
    
    func buttonClicked(sender: UIButton){
        self.dismissKeyboard()
        if(sender.titleLabel?.text == "取消"){
            self.alert1.close()
        }else if (sender.titleLabel?.text == "确定"){
            self.infoData.setValue(self.pickerCache, forKey: "category")
            self.infoTable.reloadData()
            self.alert1.close()
        }else if (sender.titleLabel?.text == "返回修改"){
            self.alert2.close()
        }else if (sender.titleLabel?.text == "确认提交"){
            setUpOnlineData("token")
        }else if (sender.titleLabel?.text == "查 看 商 品 详 情"){
            print("前往商品详情")
        }else if (sender.titleLabel?.text == "返 回 主 页"){
            print("前往主页")
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func nextClicked(){
        self.dismissKeyboard()
        if(self.currentState == 1){
            if(!self.imgUploaded){
                Tool.showErrorHUD("请上传图片!")
            }else{
                self.staticLabel1.text = "第二步:填写信息"
                self.staticLabel1.sizeToFit()
                self.uploadButton.hidden = true
                self.staticLabel2.hidden = true
                self.infoTable.hidden = false
                self.nextButton.frame.origin.y = self.infoTable.frame.maxY + 80 * Consts.ratio
                Consts.setUpNavigationBarWithBackButton(self, title: "填写商品详情", backTitle: "<")
                self.currentState = 2
            }
        }else if(self.currentState == 2){
            if(self.infoData.objectForKey("name")as! String == ""){
                Tool.showErrorHUD("商品名称不能为空!")
            }else if(self.infoData.objectForKey("price")as! String == ""){
                Tool.showErrorHUD("商品价格不能为空!")
            }else if(self.infoData.objectForKey("category")as! String == "商品分类"){
                Tool.showErrorHUD("请选择商品分类!")
            }else if((self.infoData.objectForKey("other")as! NSString).length < 10){
                Tool.showErrorHUD("请输入至少十个字的介绍!")
            }else{
                param["name"] = self.infoData["name"] as! String
                param["price"] = self.infoData["price"] as! String
                param["category"] = self.infoData["category"] as! String
                param["description"] = self.infoData["other"] as! String
                
                self.showAlert(self.nextButton)
            }
        }
    }
    
    func uploadImage(){
        let newSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "相册")
        newSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if(buttonIndex == 1){
            self.goCamera()
        }else if(buttonIndex == 2){
            self.goImage()
        }else if(buttonIndex == 0){

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
    
    ///选择好照片后choose后执行的方法
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.uploadButton.frame = CGRect(x: 140 * Consts.ratio, y: self.staticLabel1.frame.maxY + 50 * Consts.ratio, width: 440 * Consts.ratio, height: 440 * Consts.ratio)
        self.uploadButton.setImage(image, forState: .Normal)
        self.staticLabel2.frame.origin.y = self.uploadButton.frame.maxY + 50 * Consts.ratio
        self.nextButton.frame.origin.y = self.staticLabel2.frame.maxY + 86 * Consts.ratio
        self.imgUploaded = true
        
        self.imgData = UIImageJPEGRepresentation(image, 1.0)!
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    ///cancel后执行的方法
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.hideExtraLinesInTableView(tableView, indexPath: indexPath)
        if(tableView == self.infoTable){
            if(indexPath.row < 2){
                var cell = tableView.dequeueReusableCellWithIdentifier("UploadGoodsCell1", forIndexPath: indexPath)as! UploadGoodsCell1
                cell = self.setUpTableViewCell(tableView, indexPath: indexPath, cell: cell)as! UploadGoodsCell1
                cell.separatorInset = Consts.tableSeperatorEdge
                cell.layoutMargins = Consts.tableSeperatorEdge
                return cell
            }else if(indexPath.row == 3){
                var cell = tableView.dequeueReusableCellWithIdentifier("UploadGoodsCell2", forIndexPath: indexPath)as! UploadGoodsCell2
                cell = self.setUpTableViewCell(tableView, indexPath: indexPath, cell: cell)as! UploadGoodsCell2
                cell.separatorInset = Consts.tableSeperatorEdge
                cell.layoutMargins = Consts.tableSeperatorEdge
                return cell
            }else if(indexPath.row == 2){
                var cell = tableView.dequeueReusableCellWithIdentifier("UploadGoodsCell3", forIndexPath: indexPath)as! UploadGoodsCell3
                cell = self.setUpTableViewCell(tableView, indexPath: indexPath, cell: cell)as! UploadGoodsCell3
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
    
    func setUpTableViewCell(tableView: UITableView,indexPath:NSIndexPath, cell: UITableViewCell)-> UITableViewCell{
        if(tableView == self.infoTable){
            if(cell.isKindOfClass(UploadGoodsCell1.self)){
                let cell = cell as!UploadGoodsCell1
                
//                cell.icon.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 32 * Consts.ratio, height: 32 * Consts.ratio)
//                cell.icon.contentMode = .ScaleAspectFit
                switch (indexPath.row){
                case 0:
                    cell.icon.image = Consts.imageFromColor(Consts.tintGreen, size: cell.icon.frame.size)
                case 1:
                    cell.icon.image = Consts.imageFromColor(Consts.tintGreen, size: cell.icon.frame.size)
//                case 2:
//                    cell.icon.image = Consts.imageFromColor(Consts.tintGreen, size: cell.icon.frame.size)
                default:
                    break
                }
//                cell.addSubview(cell.icon)
                
//                cell.input.bounds = CGRect(x: 0, y: 0, width: tableView.frame.width - cell.icon.frame.maxX - 22 * Consts.ratio, height: Consts.hoFt13)
//                cell.input.frame.origin.x = cell.icon.frame.maxX + 22 * Consts.ratio
//                cell.input.center.y = cell.icon.center.y
//                cell.input.font = Consts.ft13
//                cell.input.textColor = Consts.lightGray
                switch (indexPath.row){
                case 0:
                    cell.input.placeholder = "商品名称"
                    cell.input.text = self.infoData.objectForKey("name")as? String
                    cell.input.tag = 101
                case 1:
                    cell.input.placeholder = "商品价格"
                    cell.input.text = self.infoData.objectForKey("price")as? String
                    cell.input.tag = 102
//                case 2:
//                    cell.input.placeholder = "商品分类"
//                    cell.input.text = self.infoData.objectForKey("category")as? String
                default:
                    break
                }
//                cell.addSubview(cell.input)
                cell.input.addTarget(self, action: "textFieldChanged:", forControlEvents: .EditingDidEnd)
                
                return cell
                
            }else if(cell.isKindOfClass(UploadGoodsCell2.self)){
                let cell = cell as! UploadGoodsCell2
                
                cell.textView.text = self.infoData.objectForKey("other")as? String
                cell.expandableTableView = self.infoTable
                let frame = cell.frame
                cell.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: self.textHeight)
                return cell
            }else if(cell.isKindOfClass(UploadGoodsCell3)){
                let cell = cell as! UploadGoodsCell3
                cell.btn.setTitle(self.infoData.objectForKey("category")as? String, forState: .Normal)
                if(cell.btn.titleLabel?.text == "商品分类"){
                    cell.btn.setTitleColor(Consts.holderGray, forState: .Normal)
                }else{
                    cell.btn.setTitleColor(Consts.lightGray, forState: .Normal)
                }
                cell.btn.addTarget(self, action: "showAlert:", forControlEvents: .TouchUpInside)
                cell.btn.tag = 103
                return cell
            }else{
                return cell
            }
        }else{
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.infoTable){
            if(section == 0){
                return 4
            }else{
                return 1
            }
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView == self.infoTable){
            if(indexPath.row < 3){
                var cell = UploadGoodsCell1()
                cell = self.setUpTableViewCell(tableView, indexPath: indexPath, cell: cell)as! UploadGoodsCell1

                return cell.frame.height
            }else if (indexPath.row == 3){
                var cell = UploadGoodsCell2()
                cell = self.setUpTableViewCell(tableView, indexPath: indexPath, cell: cell)as! UploadGoodsCell2

                return cell.frame.height
            }else{
                return 200
            }
        }else{
            return 200
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func pickerView(pickerView: AFPickerView!, didSelectRow row: Int) {
//        self.infoData.setValue(self.pickerData.objectAtIndex(row)as! String, forKey: "category")
        self.pickerCache = self.pickerData.objectAtIndex(row)as! String
    }
    
    func pickerView(pickerView: AFPickerView!, titleForRow row: Int) -> String! {
        return self.pickerData.objectAtIndex(row) as! String
    }
    
    func numberOfRowsInPickerView(pickerView: AFPickerView!) -> Int {
        return self.pickerData.count
    }
    
    func showAlert(sender: UIButton){
        if(sender.tag == 103){
            self.setUpAlertViews(1)
            self.alert1.show()
        }else if(sender.tag == 104){
            self.setUpAlertViews(2)
            self.alert2.show()
        }
    }
    
    func textFieldChanged(sender: UITextField){
        if(sender.tag == 101){
            self.infoData.setValue(sender.text, forKey: "name")
        }else if(sender.tag == 102){
            self.infoData.setValue(sender.text, forKey: "price")
        }
    }
    
    func tableView(tableView: UITableView!, updatedText text: String!, atIndexPath indexPath: NSIndexPath!) {
        if(tableView == self.infoTable){
            self.infoData.setValue(text, forKey: "other")
        }
    }
    
    func tableView(tableView: UITableView!, updatedHeight height: CGFloat, atIndexPath indexPath: NSIndexPath!) {
        if(tableView == self.infoTable){
            self.textHeight = height
        }
    }
    
    func hideExtraLinesInTableView(tableView:UITableView!,indexPath: NSIndexPath){
        if(tableView == self.infoTable){
            if(tableView.numberOfRowsInSection(indexPath.section) == 0){
                tableView.separatorStyle = .None
            }else{
                tableView.separatorStyle = .SingleLine
                let footer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                footer.backgroundColor = UIColor.clearColor()
                tableView.tableFooterView = footer
            }
        }
    }
    
    ///实现点击UIView内部关闭键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    ///实现点击UITableView内部关闭键盘
    func dismissKeyboard(){
        let indexs : NSArray? = self.infoTable.indexPathsForVisibleRows
        if(indexs != nil){
            for i in indexs!{
                let v = self.infoTable.cellForRowAtIndexPath((i as! NSIndexPath))as? UploadGoodsCell1
                if(v != nil){
                    if(v!.input.isFirstResponder()){
                        v!.input.resignFirstResponder()
                    }
                }
            }
            for i in indexs!{
                let v = self.infoTable.cellForRowAtIndexPath((i as! NSIndexPath))as? UploadGoodsCell2
                if(v != nil){
                    if(v!.textView.isFirstResponder()){
                        v!.textView.resignFirstResponder()
                    }
                }
            }
        }
    }
    
    ///实现拖动时关闭键盘
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if(scrollView == self.infoTable){
            scrollView.endEditing(true)
        }
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        switch(tag){
        case "token":
            qiniuToken = json["token"].string!
            qiniuKey = json["key"].string!
            param["image"] = qiniuKey
            upManager.putData(self.imgData, key: qiniuKey, token: self.qiniuToken, complete: { (info, key, resp) -> Void in
                //                图片上传完毕后才向后台更新用户数据
                self.setUpOnlineData("info")
                }, option: nil)
            break
        case "info":
            let id = json["idle_id"].string!
            print("个人闲置发布成功!idle_id:\(id)")
            Tool.showSuccessHUD("提交成功!")
            self.alert2.close()
            self.staticLabel1.hidden = true
            self.successImg.hidden = false
            self.successLabel1.hidden = false
            self.successLabel2.hidden = false
            self.toGoodsButton.hidden = false
            self.toMainPageButton.hidden = false
            self.infoTable.hidden = true
            self.nextButton.hidden = true
            Consts.setUpNavigationBarWithBackButton(self, title: "发布成功", backTitle: nil)
            self.currentState = 3
            break
        default:
            break
            
        }

    }


}
