//
//  ShopUploadGoodsViewController.swift
//  yoyoCampus
//
//  Created by DuZhiXia on 15/9/18.
//  Copyright © 2015年 DuZhiXia. All rights reserved.
//

import UIKit

class ShopUploadGoodsViewController: UIViewController,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,ACEExpandableTableViewDelegate,AFPickerViewDataSource,AFPickerViewDelegate {
    
    ///tags:
    //101:商品优惠button
    //102:商品分类button
    //103:商品标签button
    //104:下一步button
    //105:商品名称textfield
    //106:商品价格textfield
    //107:alert内添加按钮


    ///信息table
    var infoTable = UITableView()
    
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
    
    ///优惠弹窗
    var discountAlert = CustomIOSAlertView()
    
    ///新增优惠弹窗
    var newDiscountAlert = CustomIOSAlertView()
    
    ///优惠滚轮
    var discountPicker = AFPickerView()
    
    ///优惠滚轮数据
    var discountPickerData : NSMutableArray = ["九折","八折","七折","六折","五折"]

    ///优惠滚轮缓存
    var discountPickerCache = "商品优惠"

    ///分类弹窗
    var categoryAlert = CustomIOSAlertView()
    
    ///新增分类弹窗
    var newCategoryAlert = CustomIOSAlertView()

    ///分类滚轮
    var categoryPicker = AFPickerView()
    
    ///分类滚轮数据
    var categoryPickerData : NSMutableArray = ["食品","书籍","工具","票务","旅游","驾校","留学","家教"]
    
    ///分类滚轮缓存
    var categoryPickerCache = "商品分类"
    
    ///标签弹窗
    var tagAlert = CustomIOSAlertView()
    
//    ///新增标签弹窗
//    var newTagAlert = CustomIOSAlertView()
    
    ///标签滚轮
    var tagPicker = AFPickerView()
    
    ///标签滚轮数据
    var tagPickerData : NSMutableArray = ["标签1","标签2","标签3","标签4","标签5","标签6","标签7"]

    ///标签滚轮缓存
    var tagPickerCache = "标签"
    
    ///新建内容缓存
    var newSomethingCache = ""

    ///table数据
    var tableData : NSMutableDictionary = ["name":"","price":"","discount":"商品优惠","category":"商品分类","tag":"标签","other":""]
    
    ///上传图片缓存
    var tmpImg = UIImageView(image: Consts.imageFromColor(Consts.tintGreen, size: CGSize(width: 100 * Consts.ratio, height: 100 * Consts.ratio)))
    
    ///添加按钮
    var addButton = UIButton()
    
    ///当前textview行高
    var textHeight : CGFloat = 200 * Consts.ratio
    
    ///点击手势监听
    var tapGesture = UITapGestureRecognizer()
    
    ///图片已上传标记
    var imgUploaded = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setUpNavigationBar()
        self.setUpInitialLooking()
        self.setUpActions()
        self.setUpOnlineData()
        self.setUpGestures()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "商品添加", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height
        
        self.view.backgroundColor = Consts.grayView
        
        let wtf = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(wtf)
        
        self.infoTable.frame = CGRect(x: 64 * Consts.ratio, y: 64 + 30 * Consts.ratio, width: 592 * Consts.ratio, height: 872 * Consts.ratio)
        self.infoTable.layer.cornerRadius = Consts.radius
        self.infoTable.layer.borderWidth = 0.5
        self.infoTable.separatorInset = UIEdgeInsetsZero
        self.infoTable.layoutMargins = UIEdgeInsetsZero
        self.view.addSubview(self.infoTable)
        
        self.addButton = Consts.setUpButton("添 加", frame: CGRect(x: 74 * Consts.ratio, y: self.infoTable.frame.maxY + 60 * Consts.ratio, width: newWidth - 74 * 2 * Consts.ratio, height: 96 * Consts.ratio), font: Consts.ft18, radius: Consts.radius)
        self.view.addSubview(self.addButton)
        
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
    
    func setUpActions(){
        self.infoTable.delegate = self
        self.infoTable.dataSource = self
        self.infoTable.registerClass(UploadGoodsCell1.self, forCellReuseIdentifier: "UploadGoodsCell1")
        self.infoTable.registerClass(UploadGoodsCell2.self, forCellReuseIdentifier: "UploadGoodsCell2")
        self.infoTable.registerClass(UploadGoodsCell3.self, forCellReuseIdentifier: "UploadGoodsCell3")
        self.infoTable.registerClass(UploadGoodsCell4.self, forCellReuseIdentifier: "UploadGoodsCell4")
        
        self.toGoodsButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        self.toMainPageButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        self.addButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
    }
    
    func setUpOnlineData(){
        
    }
    
    func setUpGestures(){
        self.tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.tapGesture.cancelsTouchesInView = false
        self.infoTable.addGestureRecognizer(self.tapGesture)
    }
    
    func showAlert(sender: UIButton){
        if(sender.tag == 101){
            self.reloadAlertViews(1)
            self.discountAlert.show()
        }else if(sender.tag == 102){
            self.reloadAlertViews(2)
            self.categoryAlert.show()
        }else if(sender.tag == 103){
            self.reloadAlertViews(3)
            self.tagAlert.show()
        }
    }
    
    func reloadAlertViews(alertNum: Int){
//        self.discountAlert = CustomIOSAlertView()
//        self.categoryAlert = CustomIOSAlertView()
//        self.tagAlert = CustomIOSAlertView()

        if(alertNum == 1){
            let alertDetail = UIView(frame: CGRect(x:0 , y: 0, width: 576 * Consts.ratio, height: 438 * Consts.ratio))
            alertDetail.backgroundColor = Consts.white
            
            let alertLabel = Consts.setUpLabel("商品优惠", color: Consts.darkGray, font: Consts.ft18, x: 30 * Consts.ratio, y: 30 * Consts.ratio, centerX: nil)
            alertDetail.addSubview(alertLabel)
            
            let addBtn = UIButton(frame: CGRect(x: 480 * Consts.ratio, y: alertLabel.frame.minY, width: 40 * Consts.ratio, height: 32 * Consts.ratio))
            addBtn.setImage(Consts.imageFromColor(UIColor.orangeColor(), size: addBtn.frame.size), forState: .Normal)
            addBtn.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
            addBtn.tag = 107
            alertDetail.addSubview(addBtn)
            
            self.discountPicker = AFPickerView(frame: CGRect(x: 0, y: 100 * Consts.ratio, width: 456 * Consts.ratio, height: 242 * Consts.ratio))
            self.discountPicker.center.x = alertDetail.frame.width / 2
            self.discountPicker.backgroundColor = Consts.grayView
            self.discountPicker.rowColorSelected = Consts.tintGreen
            self.discountPicker.rowColorCommon = Consts.lightGray
            self.discountPicker.rowFont = Consts.ft16
            self.discountPicker.rowFontSelected = Consts.ft18
            self.discountPicker.rowHeight = (self.discountPicker.frame.height) / 3.02
            self.discountPicker.halfRowNum = 1
            self.discountPicker.delegate = self
            self.discountPicker.dataSource = self
            self.discountPicker.reloadData()
            alertDetail.addSubview(self.discountPicker)
            
            let cancelButton = UIButton(frame: CGRect(x: 100 * Consts.ratio, y: self.discountPicker.frame.maxY + 42 * Consts.ratio, width: 0, height: 0))
            cancelButton.setTitle("取消", forState: .Normal)
            let testLabel = Consts.setUpLabel("取消", color: Consts.darkGray, font: Consts.ft18, x: 100 * Consts.ratio, y: self.discountPicker.frame.maxY + 42 * Consts.ratio, centerX: nil)
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
            self.discountAlert.containerView = alertDetail
            self.discountAlert.buttonTitles = nil
        }else if(alertNum == 2){
            let alertDetail = UIView(frame: CGRect(x:0 , y: 0, width: 576 * Consts.ratio, height: 438 * Consts.ratio))
            alertDetail.backgroundColor = Consts.white
            
            let alertLabel = Consts.setUpLabel("商品分类", color: Consts.darkGray, font: Consts.ft18, x: 30 * Consts.ratio, y: 30 * Consts.ratio, centerX: nil)
            alertDetail.addSubview(alertLabel)
            
            let addBtn = UIButton(frame: CGRect(x: 480 * Consts.ratio, y: alertLabel.frame.minY, width: 40 * Consts.ratio, height: 32 * Consts.ratio))
            addBtn.setImage(Consts.imageFromColor(UIColor.orangeColor(), size: addBtn.frame.size), forState: .Normal)
            addBtn.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
            addBtn.tag = 107
            alertDetail.addSubview(addBtn)
            
            self.categoryPicker = AFPickerView(frame: CGRect(x: 0, y: 100 * Consts.ratio, width: 456 * Consts.ratio, height: 242 * Consts.ratio))
            self.categoryPicker.center.x = alertDetail.frame.width / 2
            self.categoryPicker.backgroundColor = Consts.grayView
            self.categoryPicker.rowColorSelected = Consts.tintGreen
            self.categoryPicker.rowColorCommon = Consts.lightGray
            self.categoryPicker.rowFont = Consts.ft16
            self.categoryPicker.rowFontSelected = Consts.ft18
            self.categoryPicker.rowHeight = (self.categoryPicker.frame.height) / 3.02
            self.categoryPicker.halfRowNum = 1
            self.categoryPicker.delegate = self
            self.categoryPicker.dataSource = self
            self.categoryPicker.reloadData()
            alertDetail.addSubview(self.categoryPicker)
            
            let cancelButton = UIButton(frame: CGRect(x: 100 * Consts.ratio, y: self.categoryPicker.frame.maxY + 42 * Consts.ratio, width: 0, height: 0))
            cancelButton.setTitle("取消", forState: .Normal)
            let testLabel = Consts.setUpLabel("取消", color: Consts.darkGray, font: Consts.ft18, x: 100 * Consts.ratio, y: self.categoryPicker.frame.maxY + 42 * Consts.ratio, centerX: nil)
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
            self.categoryAlert.containerView = alertDetail
            self.categoryAlert.buttonTitles = nil
        }else if(alertNum == 3){
            let alertDetail = UIView(frame: CGRect(x:0 , y: 0, width: 576 * Consts.ratio, height: 438 * Consts.ratio))
            alertDetail.backgroundColor = Consts.white
            
            let alertLabel = Consts.setUpLabel("标签", color: Consts.darkGray, font: Consts.ft18, x: 30 * Consts.ratio, y: 30 * Consts.ratio, centerX: nil)
            alertDetail.addSubview(alertLabel)
            
//            let addBtn = UIButton(frame: CGRect(x: 480 * Consts.ratio, y: alertLabel.frame.minY, width: 40 * Consts.ratio, height: 32 * Consts.ratio))
//            addBtn.setImage(Consts.imageFromColor(UIColor.orangeColor(), size: addBtn.frame.size), forState: .Normal)
//            addBtn.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
//            addBtn.tag = 107
//            alertDetail.addSubview(addBtn)
            
            self.tagPicker = AFPickerView(frame: CGRect(x: 0, y: 100 * Consts.ratio, width: 456 * Consts.ratio, height: 242 * Consts.ratio))
            self.tagPicker.center.x = alertDetail.frame.width / 2
            self.tagPicker.backgroundColor = Consts.grayView
            self.tagPicker.rowColorSelected = Consts.tintGreen
            self.tagPicker.rowColorCommon = Consts.lightGray
            self.tagPicker.rowFont = Consts.ft16
            self.tagPicker.rowFontSelected = Consts.ft18
            self.tagPicker.rowHeight = (self.tagPicker.frame.height) / 3.02
            self.tagPicker.halfRowNum = 1
            self.tagPicker.delegate = self
            self.tagPicker.dataSource = self
            self.tagPicker.reloadData()
            alertDetail.addSubview(self.tagPicker)
            
            let cancelButton = UIButton(frame: CGRect(x: 100 * Consts.ratio, y: self.tagPicker.frame.maxY + 42 * Consts.ratio, width: 0, height: 0))
            cancelButton.setTitle("取消", forState: .Normal)
            let testLabel = Consts.setUpLabel("取消", color: Consts.darkGray, font: Consts.ft18, x: 100 * Consts.ratio, y: self.tagPicker.frame.maxY + 42 * Consts.ratio, centerX: nil)
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
            self.tagAlert.containerView = alertDetail
            self.tagAlert.buttonTitles = nil
        }else if(alertNum == 4){
            let alertDetail = UIView(frame: CGRect(x:0 , y: 0, width: 482 * Consts.ratio, height: 280 * Consts.ratio))
            alertDetail.backgroundColor = Consts.white
            
            let alertLabel = Consts.setUpLabel("新建商品优惠", color: Consts.tintGreen, font: Consts.ft18, x: 26 * Consts.ratio, y: 34 * Consts.ratio, centerX: nil)
            alertDetail.addSubview(alertLabel)
            
            let input = UITextField(frame: CGRect(x: 36 * Consts.ratio, y: alertLabel.frame.maxY + 60 * Consts.ratio, width: 410 * Consts.ratio, height: Consts.hoFt16))
            input.font = Consts.ft16
            input.textColor = Consts.lightGray
            input.placeholder = "输入文字"
            input.tag = 108
            input.addTarget(self, action: "textFieldChanged:", forControlEvents: .EditingDidEnd)
            alertDetail.addSubview(input)
            
            let cancelButton = UIButton(frame: CGRect(x: 82 * Consts.ratio, y: input.frame.maxY + 74 * Consts.ratio, width: 0, height: 0))
            cancelButton.setTitle("取 消", forState: .Normal)
            let testLabel = Consts.setUpLabel("取 消", color: Consts.darkGray, font: Consts.ft18, x: 100 * Consts.ratio, y: self.tagPicker.frame.maxY + 42 * Consts.ratio, centerX: nil)
            cancelButton.titleLabel?.font = Consts.ft16
            cancelButton.sizeToFit()
            let btnUpMargin = (cancelButton.frame.height - testLabel.frame.height) / 2
            cancelButton.frame.origin.y -= btnUpMargin
            cancelButton.backgroundColor = Consts.white
            cancelButton.setTitleColor(Consts.darkGray, forState: .Normal)
            cancelButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
            alertDetail.addSubview(cancelButton)
            
            let confirmButton = UIButton(frame: CGRect(x: alertDetail.frame.width - cancelButton.frame.maxX, y: cancelButton.frame.origin.y, width: 0, height: 0))
            confirmButton.setTitle("确 定", forState: .Normal)
            confirmButton.titleLabel?.font = Consts.ft16
            confirmButton.sizeToFit()
            confirmButton.backgroundColor = Consts.white
            confirmButton.setTitleColor(Consts.darkGray, forState: .Normal)
            confirmButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
            alertDetail.addSubview(confirmButton)
            
            alertDetail.frame = CGRect(x: alertDetail.frame.origin.x, y: alertDetail.frame.origin.y, width: alertDetail.frame.width, height: cancelButton.frame.maxY + 16 * Consts.ratio - btnUpMargin)
            alertDetail.layer.cornerRadius = Consts.alertRadius
            alertDetail.layer.masksToBounds = true
            self.newDiscountAlert.containerView = alertDetail
            self.newDiscountAlert.buttonTitles = nil
        }else if(alertNum == 5){
            let alertDetail = UIView(frame: CGRect(x:0 , y: 0, width: 482 * Consts.ratio, height: 280 * Consts.ratio))
            alertDetail.backgroundColor = Consts.white
            
            let alertLabel = Consts.setUpLabel("新建商品分类", color: Consts.tintGreen, font: Consts.ft18, x: 26 * Consts.ratio, y: 34 * Consts.ratio, centerX: nil)
            alertDetail.addSubview(alertLabel)
            
            let input = UITextField(frame: CGRect(x: 36 * Consts.ratio, y: alertLabel.frame.maxY + 60 * Consts.ratio, width: 410 * Consts.ratio, height: Consts.hoFt16))
            input.font = Consts.ft16
            input.textColor = Consts.lightGray
            input.placeholder = "输入文字"
            input.tag = 109
            input.addTarget(self, action: "textFieldChanged:", forControlEvents: .EditingDidEnd)
            alertDetail.addSubview(input)
            
            let cancelButton = UIButton(frame: CGRect(x: 82 * Consts.ratio, y: input.frame.maxY + 74 * Consts.ratio, width: 0, height: 0))
            cancelButton.setTitle("取 消", forState: .Normal)
            let testLabel = Consts.setUpLabel("取 消", color: Consts.darkGray, font: Consts.ft18, x: 100 * Consts.ratio, y: self.tagPicker.frame.maxY + 42 * Consts.ratio, centerX: nil)
            cancelButton.titleLabel?.font = Consts.ft16
            cancelButton.sizeToFit()
            let btnUpMargin = (cancelButton.frame.height - testLabel.frame.height) / 2
            cancelButton.frame.origin.y -= btnUpMargin
            cancelButton.backgroundColor = Consts.white
            cancelButton.setTitleColor(Consts.darkGray, forState: .Normal)
            cancelButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
            alertDetail.addSubview(cancelButton)
            
            let confirmButton = UIButton(frame: CGRect(x: alertDetail.frame.width - cancelButton.frame.maxX, y: cancelButton.frame.origin.y, width: 0, height: 0))
            confirmButton.setTitle("确 定", forState: .Normal)
            confirmButton.titleLabel?.font = Consts.ft16
            confirmButton.sizeToFit()
            confirmButton.backgroundColor = Consts.white
            confirmButton.setTitleColor(Consts.darkGray, forState: .Normal)
            confirmButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
            alertDetail.addSubview(confirmButton)
            
            alertDetail.frame = CGRect(x: alertDetail.frame.origin.x, y: alertDetail.frame.origin.y, width: alertDetail.frame.width, height: cancelButton.frame.maxY + 16 * Consts.ratio - btnUpMargin)
            alertDetail.layer.cornerRadius = Consts.alertRadius
            alertDetail.layer.masksToBounds = true
            self.newCategoryAlert.containerView = alertDetail
            self.newCategoryAlert.buttonTitles = nil
//        }else if(alertNum == 6){
//            let alertDetail = UIView(frame: CGRect(x:0 , y: 0, width: 482 * Consts.ratio, height: 280 * Consts.ratio))
//            alertDetail.backgroundColor = Consts.white
//            
//            let alertLabel = Consts.setUpLabel("新建标签", color: Consts.tintGreen, font: Consts.ft18, x: 26 * Consts.ratio, y: 34 * Consts.ratio, centerX: nil)
//            alertDetail.addSubview(alertLabel)
//            
//            let input = UITextField(frame: CGRect(x: 36 * Consts.ratio, y: alertLabel.frame.maxY + 60 * Consts.ratio, width: 410 * Consts.ratio, height: Consts.hoFt16))
//            input.font = Consts.ft16
//            input.textColor = Consts.lightGray
//            input.placeholder = "输入文字"
//            input.tag = 110
//            input.addTarget(self, action: "textFieldChanged:", forControlEvents: .EditingDidEnd)
//            alertDetail.addSubview(input)
//            
//            let cancelButton = UIButton(frame: CGRect(x: 82 * Consts.ratio, y: input.frame.maxY + 74 * Consts.ratio, width: 0, height: 0))
//            cancelButton.setTitle("取 消", forState: .Normal)
//            let testLabel = Consts.setUpLabel("取 消", color: Consts.darkGray, font: Consts.ft18, x: 100 * Consts.ratio, y: self.tagPicker.frame.maxY + 42 * Consts.ratio, centerX: nil)
//            cancelButton.titleLabel?.font = Consts.ft16
//            cancelButton.sizeToFit()
//            let btnUpMargin = (cancelButton.frame.height - testLabel.frame.height) / 2
//            cancelButton.frame.origin.y -= btnUpMargin
//            cancelButton.backgroundColor = Consts.white
//            cancelButton.setTitleColor(Consts.darkGray, forState: .Normal)
//            cancelButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
//            alertDetail.addSubview(cancelButton)
//            
//            let confirmButton = UIButton(frame: CGRect(x: alertDetail.frame.width - cancelButton.frame.maxX, y: cancelButton.frame.origin.y, width: 0, height: 0))
//            confirmButton.setTitle("确 定", forState: .Normal)
//            confirmButton.titleLabel?.font = Consts.ft16
//            confirmButton.sizeToFit()
//            confirmButton.backgroundColor = Consts.white
//            confirmButton.setTitleColor(Consts.darkGray, forState: .Normal)
//            confirmButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
//            alertDetail.addSubview(confirmButton)
//            
//            alertDetail.frame = CGRect(x: alertDetail.frame.origin.x, y: alertDetail.frame.origin.y, width: alertDetail.frame.width, height: cancelButton.frame.maxY + 16 * Consts.ratio - btnUpMargin)
//            alertDetail.layer.cornerRadius = Consts.alertRadius
//            alertDetail.layer.masksToBounds = true
//            self.newTagAlert.containerView = alertDetail
//            self.newTagAlert.buttonTitles = nil
//        }
        }
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func buttonClicked(sender: UIButton){
        if(sender.titleLabel?.text == "取消"){
            if(sender.superview == self.discountAlert.containerView){
                self.discountAlert.close()
            }else if(sender.superview == self.categoryAlert.containerView){
                self.categoryAlert.close()
            }else if(sender.superview == self.tagAlert.containerView){
                self.tagAlert.close()
            }
        }else if(sender.titleLabel?.text == "确定"){
            
            if(sender.superview == self.discountAlert.containerView){
                self.tableData.setValue(self.discountPickerCache, forKey: "discount")
                self.infoTable.reloadData()
                self.discountAlert.close()
            }else if(sender.superview == self.categoryAlert.containerView){
                self.tableData.setValue(self.categoryPickerCache, forKey: "category")
                self.infoTable.reloadData()
                self.categoryAlert.close()
            }else if(sender.superview == self.tagAlert.containerView){
                self.tableData.setValue(self.tagPickerCache, forKey: "tag")
                self.infoTable.reloadData()
                self.tagAlert.close()
            }
        }else if(sender.tag == 107){
            if(sender.superview == self.discountAlert.containerView){
                self.discountAlert.close()
                self.reloadAlertViews(4)
                self.newDiscountAlert.show()
            }else if(sender.superview == self.categoryAlert.containerView){
                self.categoryAlert.close()
                self.reloadAlertViews(5)
                self.newCategoryAlert.show()
//            }else if(sender.superview == self.tagAlert.containerView){
//                self.tagAlert.close()
//                self.reloadAlertViews(6)
//                self.newTagAlert.show()
//            }
            }
        }else if(sender.titleLabel?.text == "取 消"){
            if(sender.superview == self.newDiscountAlert.containerView){
                self.newSomethingCache = ""
                self.newDiscountAlert.close()
            }else if(sender.superview == self.newCategoryAlert.containerView){
                self.newSomethingCache = ""
                self.newCategoryAlert.close()
//            }else if(sender.superview == self.newTagAlert.containerView){
//                self.newSomethingCache = ""
//                self.newTagAlert.close()
//            }
            }
        }else if(sender.titleLabel?.text == "确 定"){
            if(sender.superview == self.newDiscountAlert.containerView){
                self.newDiscountAlert.containerView.endEditing(true)
                self.discountPickerData.addObject(self.newSomethingCache)
                self.discountPicker.reloadData()
                self.newSomethingCache = ""
                self.newDiscountAlert.close()
                Tool.showSuccessHUD("添加成功!")
            }else if(sender.superview == self.newCategoryAlert.containerView){
                self.newCategoryAlert.containerView.endEditing(true)
                self.categoryPickerData.addObject(self.newSomethingCache)
                self.categoryPicker.reloadData()
                self.newSomethingCache = ""
                self.newCategoryAlert.close()
                Tool.showSuccessHUD("添加成功!")
//            }else if(sender.superview == self.newTagAlert.containerView){
//                self.newTagAlert.containerView.endEditing(true)
//                self.tagPickerData.addObject(self.newSomethingCache)
//                self.tagPicker.reloadData()
//                self.newSomethingCache = ""
//                self.newTagAlert.close()
//                Tool.showSuccessHUD("添加成功!")
//            }
            }
        }else if (sender.titleLabel?.text == "查 看 商 品 详 情"){
            print("前往商品详情")
        }else if (sender.titleLabel?.text == "返 回 主 页"){
            print("前往主页")
            self.navigationController?.popToRootViewControllerAnimated(true)
        }else if (sender.titleLabel?.text == "添 加"){
            if(!self.imgUploaded){
                Tool.showErrorHUD("请上传图片!")
            }else if(self.tableData.objectForKey("name")as! String == ""){
                Tool.showErrorHUD("商品名称不能为空!")
            }else if(self.tableData.objectForKey("price")as! String == ""){
                Tool.showErrorHUD("商品价格不能为空!")
            }else if(self.tableData.objectForKey("discount")as! String == "商品优惠"){
                Tool.showErrorHUD("请选择商品优惠!")
            }else if(self.tableData.objectForKey("category")as! String == "商品分类"){
                Tool.showErrorHUD("请选择商品分类!")
            }else if(self.tableData.objectForKey("tag")as! String == "标签"){
                Tool.showErrorHUD("请选择标签!")
            }else if((self.tableData.objectForKey("other")as! NSString).length < 10){
                Tool.showErrorHUD("请输入至少十个字的介绍!")
            }else{
                self.successImg.hidden = false
                self.successLabel1.hidden = false
                self.successLabel2.hidden = false
                self.toGoodsButton.hidden = false
                self.toMainPageButton.hidden = false
                self.infoTable.hidden = true
                self.addButton.hidden = true
                Consts.setUpNavigationBarWithBackButton(self, title: "发布成功", backTitle: nil)
                Tool.showSuccessHUD("提交成功!")
            }
        }
    }
    
    func textFieldChanged(sender: UITextField){
        if(sender.tag == 105){
            self.tableData.setValue(sender.text, forKey: "name")
        }else if(sender.tag == 106){
            self.tableData.setValue(sender.text, forKey: "price")
        }else if(sender.tag == 108){
            self.newSomethingCache = sender.text!
        }else if(sender.tag == 109){
            self.newSomethingCache = sender.text!
        }else if(sender.tag == 110){
            self.newSomethingCache = sender.text!
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
    
    ///选择好照片后choose后执行的方法
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("choose--------->>")
        
        print(editingInfo)
        
        self.tmpImg.image = image
        self.infoTable.reloadData()
        self.imgUploaded = true
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    ///cancel后执行的方法
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        print("cancel--------->>")
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.hideExtraLinesInTableView(tableView, indexPath: indexPath)
        if(tableView == self.infoTable){
            if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCellWithIdentifier("UploadGoodsCell4", forIndexPath: indexPath)as! UploadGoodsCell4
                cell.img.setImage(self.tmpImg.image, forState: .Normal)
                cell.img.addTarget(self, action: "uploadImage", forControlEvents: .TouchUpInside)
                return cell
            }else if(indexPath.row > 0)&&(indexPath.row < 3){
                let cell = tableView.dequeueReusableCellWithIdentifier("UploadGoodsCell1", forIndexPath: indexPath)as! UploadGoodsCell1
                if(indexPath.row == 1){
                    cell.icon.image = Consts.imageFromColor(Consts.tintGreen, size: cell.icon.frame.size)
                    cell.input.placeholder = "商品名称"
                    cell.input.text = self.tableData.objectForKey("name")as? String
                    cell.input.tag = 105
                    cell.input.addTarget(self, action: "textFieldChanged:", forControlEvents: .EditingDidEnd)
                }else if(indexPath.row == 2){
                    cell.icon.image = Consts.imageFromColor(Consts.tintGreen, size: cell.icon.frame.size)
                    cell.input.placeholder = "商品价格"
                    cell.input.text = self.tableData.objectForKey("price")as? String
                    cell.input.tag = 106
                    cell.input.addTarget(self, action: "textFieldChanged:", forControlEvents: .EditingDidEnd)
                }
                return cell
            }else if(indexPath.row > 2)&&(indexPath.row < 6){
                let cell = tableView.dequeueReusableCellWithIdentifier("UploadGoodsCell3", forIndexPath: indexPath)as! UploadGoodsCell3
                switch(indexPath.row){
                case 3:
                    cell.icon.image = Consts.imageFromColor(Consts.tintGreen, size: cell.icon.frame.size)
                    cell.btn.setTitle(self.tableData.objectForKey("discount")as? String, forState: .Normal)
                    if(cell.btn.titleLabel?.text == "商品优惠"){
                        cell.btn.setTitleColor(Consts.holderGray, forState: .Normal)
                    }else{
                        cell.btn.setTitleColor(Consts.lightGray, forState: .Normal)
                    }
                    cell.btn.tag = 101
                    cell.btn.addTarget(self, action: "showAlert:", forControlEvents: .TouchUpInside)
                case 4:
                    cell.icon.image = Consts.imageFromColor(Consts.tintGreen, size: cell.icon.frame.size)
                    cell.btn.setTitle(self.tableData.objectForKey("category")as? String, forState: .Normal)
                    if(cell.btn.titleLabel?.text == "商品分类"){
                        cell.btn.setTitleColor(Consts.holderGray, forState: .Normal)
                    }else{
                        cell.btn.setTitleColor(Consts.lightGray, forState: .Normal)
                    }
                    cell.btn.tag = 102
                    cell.btn.addTarget(self, action: "showAlert:", forControlEvents: .TouchUpInside)
                case 5:
                    cell.icon.image = Consts.imageFromColor(Consts.tintGreen, size: cell.icon.frame.size)
                    cell.btn.setTitle(self.tableData.objectForKey("tag")as? String, forState: .Normal)
                    if(cell.btn.titleLabel?.text == "标签"){
                        cell.btn.setTitleColor(Consts.holderGray, forState: .Normal)
                    }else{
                        cell.btn.setTitleColor(Consts.lightGray, forState: .Normal)
                    }
                    cell.btn.tag = 103
                    cell.btn.addTarget(self, action: "showAlert:", forControlEvents: .TouchUpInside)
                default:
                    break
                }
                return cell
            }else if(indexPath.row == 6){
                let cell = tableView.dequeueReusableCellWithIdentifier("UploadGoodsCell2", forIndexPath: indexPath)as! UploadGoodsCell2
                cell.icon.image = Consts.imageFromColor(Consts.tintGreen, size: cell.icon.frame.size)
                cell.expandableTableView = self.infoTable
                cell.textView.text = self.tableData.objectForKey("other")as? String
                return cell
            }else{
                return UITableViewCell()
            }
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            let cell = UploadGoodsCell4()
            return cell.frame.height
        }else if(indexPath.row > 0)&&(indexPath.row < 3){
            let cell = UploadGoodsCell1()
            return cell.frame.height
        }else if(indexPath.row > 2)&&(indexPath.row < 6){
            let cell = UploadGoodsCell3()
            return cell.frame.height
        }else if(indexPath.row == 6){
            return self.textHeight
        }else{
            return 80 * Consts.ratio
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView!, updatedHeight height: CGFloat, atIndexPath indexPath: NSIndexPath!) {
        if(tableView == self.infoTable){
            self.textHeight = height
        }
    }
    
    func tableView(tableView: UITableView!, updatedText text: String!, atIndexPath indexPath: NSIndexPath!) {
        if(tableView == self.infoTable){
            self.tableData.setValue(text, forKey: "other")
        }
    }
    
    func pickerView(pickerView: AFPickerView!, didSelectRow row: Int) {
        if(pickerView == self.discountPicker){
            self.discountPickerCache = self.discountPickerData.objectAtIndex(row)as! String
//            self.tableData.setValue(self.discountPickerData.objectAtIndex(row)as! String, forKey: "discount")
        }else if(pickerView == self.categoryPicker){
            self.categoryPickerCache = self.categoryPickerData.objectAtIndex(row)as! String
//            self.tableData.setValue(self.categoryPickerData.objectAtIndex(row)as! String, forKey: "category")
        }else if(pickerView == self.tagPicker){
            self.tagPickerCache = self.tagPickerData.objectAtIndex(row)as! String
//            self.tableData.setValue(self.tagPickerData.objectAtIndex(row)as! String, forKey: "tag")
        }
    }

    func numberOfRowsInPickerView(pickerView: AFPickerView!) -> Int {
        if(pickerView == self.discountPicker){
            return self.discountPickerData.count
        }else if(pickerView == self.categoryPicker){
            return self.categoryPickerData.count
        }else if(pickerView == self.tagPicker){
            return self.tagPickerData.count
        }else{
            return 5
        }
    }

    func pickerView(pickerView: AFPickerView!, titleForRow row: Int) -> String! {
        if(pickerView == self.discountPicker){
            return self.discountPickerData.objectAtIndex(row)as! String
        }else if(pickerView == self.categoryPicker){
            return self.categoryPickerData.objectAtIndex(row)as! String
        }else if(pickerView == self.tagPicker){
            return self.tagPickerData.objectAtIndex(row)as! String
        }else{
            return ""
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
