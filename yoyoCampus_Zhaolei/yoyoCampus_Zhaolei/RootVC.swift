//
//  RootVC.swift
//  YouYouSchool-iOS
//
//  Created by 浩然 on 15/9/22.
//  Copyright © 2015年 浩然. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage



let  windowWidth = UIScreen .mainScreen().bounds.width
let  windowHeight = UIScreen .mainScreen().bounds.height
let httpHeader = ["access_token": AppDelegate.access_token]


class RootVC: UIViewController,UIScrollViewDelegate{

      var idleCategory = NSMutableArray()
      var categoryRoot = NSMutableArray()
      var advArray = NSMutableArray()
    
     var scrollBannerView = UIScrollView()
    
    internal var locationTitle:String = ""
     var advURL = NSMutableArray()

    var searchBtn = UIButton(frame: CGRectMake(windowWidth*0.9, 10, 20, 20))
    override func viewDidLoad() {
        super.viewDidLoad()


        Consts.setUpNavigationBarWithBackButton(self, title: AppDelegate.location, backTitle: "")
        
        let leftItem = UIBarButtonItem(image: UIImage.init(named: "shouye_dingwei_xxhdpi.png"), style: .Plain, target: self, action: "selectLocation")
        leftItem.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = leftItem
        

        self.automaticallyAdjustsScrollViewInsets = false

        let rightItem = UIBarButtonItem(image: UIImage.init(named: "home_2"), style: .Plain, target: self, action: "search")
        rightItem.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightItem
        
        Consts.setUpNavigationBarWithBackButton(self, title: "东南大学九龙湖校区", backTitle: "<")
        
        self.view.backgroundColor = UIColor .whiteColor()

        
        //获取类目
        
        //总界面是一个scrollRootView
        let scrollRootView = UIScrollView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
        scrollRootView.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 234/255, alpha: 1)
        scrollRootView.delegate = self
        scrollRootView.directionalLockEnabled = true
        scrollRootView.showsVerticalScrollIndicator = true
        scrollRootView.showsHorizontalScrollIndicator = false
        scrollRootView.contentSize = CGSizeMake(windowWidth, 2530*Consts.ratio)
        scrollRootView.scrollEnabled = true
        scrollRootView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollRootView)
	    //banner的scrollView
        let scrollBannerView = UIScrollView(frame: CGRectMake(0, 0, windowWidth, 300*Consts.ratio))
        scrollBannerView.delegate = self
        scrollBannerView.directionalLockEnabled = true
        scrollBannerView.showsHorizontalScrollIndicator = true
        scrollBannerView.showsVerticalScrollIndicator = false
        scrollBannerView.backgroundColor = UIColor.whiteColor()
        //翻页效果加进去会比较好，控制左右拖动的随意性
        scrollBannerView.pagingEnabled = true
        scrollRootView.addSubview(scrollBannerView)
        self.scrollBannerView = scrollBannerView
        
        self.getAdv()

        
        //6个按键的布置
        let btnBackView = UIView(frame: CGRectMake(0, CGRectGetMaxY(scrollBannerView.frame), windowWidth, 374*Consts.ratio))
        btnBackView.backgroundColor = UIColor.whiteColor()
        scrollRootView.addSubview(btnBackView)
        
        let btnSale = UIButton(frame: CGRectMake(70 * Consts.ratio, 10, 66, 66))
        btnSale.setBackgroundImage(UIImage(named: "btn_1"), forState: UIControlState.Normal)
        btnSale.layer.cornerRadius = 33
        btnSale.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnSale.tag = 5
        btnBackView.addSubview(btnSale)
        
        let texSale = UILabel(frame: CGRectMake(CGRectGetMinX(btnSale.frame), CGRectGetMaxY(btnSale.frame)+5, 70, 10))
        texSale.text = "闲置"
        texSale.font = UIFont(name: "Verdana", size: 14)
        texSale.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        texSale.textAlignment = NSTextAlignment.Center
        btnBackView.addSubview(texSale)
        
        let btnCamp = UIButton(frame: CGRectMake(CGRectGetMaxX(btnSale.frame)+96*Consts.ratio, CGRectGetMinY(btnSale.frame), 66, 66))
        btnCamp.setBackgroundImage(UIImage(named: "btn_2"), forState: UIControlState.Normal)
        btnCamp.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnCamp.tag = 0
        btnCamp.layer.cornerRadius = 33
        btnBackView.addSubview(btnCamp)
        
        let texCamp = UILabel(frame: CGRectMake(CGRectGetMinX(btnCamp.frame), CGRectGetMaxY(btnSale.frame)+5, 70, 10))
        texCamp.font = UIFont(name: "Verdana", size: 14)
        texCamp.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        texCamp.textAlignment = NSTextAlignment.Center
        btnBackView.addSubview(texCamp)
        
        
        let btnCar = UIButton(frame: CGRectMake(CGRectGetMaxX(btnCamp.frame)+96*Consts.ratio, CGRectGetMinY(btnCamp.frame), 66, 66))
        btnCar.setBackgroundImage(UIImage(named: "btn_3"), forState: UIControlState.Normal)
        btnCar.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnCar.tag = 1
        btnCar.layer.cornerRadius = 33
        btnBackView.addSubview(btnCar)
        
        let texCar = UILabel(frame: CGRectMake(CGRectGetMinX(btnCar.frame),CGRectGetMaxY(btnSale.frame)+5, 70, 10))
        texCar.font = UIFont(name: "Verdana", size: 14)
        texCar.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        texCar.textAlignment = NSTextAlignment.Center
        btnBackView.addSubview(texCar)
        
        let btnClothes = UIButton(frame: CGRectMake(CGRectGetMinX(btnSale.frame), CGRectGetMaxY(btnSale.frame)+55*Consts.ratio, 66, 66))
        btnClothes.setBackgroundImage(UIImage(named: "btn_4"), forState: UIControlState.Normal)
        btnClothes.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnClothes.tag = 2
        btnClothes.layer.cornerRadius = 33
        btnBackView.addSubview(btnClothes)
        
        let texClothes = UILabel(frame: CGRectMake(CGRectGetMinX(btnClothes.frame), CGRectGetMaxY(btnClothes.frame)+5, 70, 10))
        texClothes.font = UIFont(name: "Verdana", size: 14)
        texClothes.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        texClothes.textAlignment = NSTextAlignment.Center
        btnBackView.addSubview(texClothes)
        
        let btnStudy = UIButton(frame: CGRectMake(CGRectGetMaxX(btnClothes.frame)+96*Consts.ratio, CGRectGetMinY(btnClothes.frame), 66, 66))
        btnStudy.setBackgroundImage(UIImage(named: "btn_5"), forState: UIControlState.Normal)
        btnStudy.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnStudy.tag = 3
        btnStudy.layer.cornerRadius = 33
        btnBackView.addSubview(btnStudy)
        
        let texStudy = UILabel(frame: CGRectMake(CGRectGetMinX(btnStudy.frame), CGRectGetMaxY(btnStudy.frame)+5, 70, 10))
        texStudy.font = UIFont(name: "Verdana", size: 14)
        texStudy.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        texStudy.textAlignment = NSTextAlignment.Center
        btnBackView.addSubview(texStudy)
        
        let btnShop = UIButton(frame: CGRectMake(CGRectGetMaxX(btnStudy.frame)+96*Consts.ratio, CGRectGetMinY(btnStudy.frame), 66,66))
        btnShop.setBackgroundImage(UIImage(named: "btn_6"), forState: UIControlState.Normal)
        btnShop.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnShop.tag = 4
        btnShop.layer.cornerRadius = 33
        btnBackView.addSubview(btnShop)
        
        let texShop = UILabel(frame: CGRectMake(CGRectGetMinX(btnShop.frame), CGRectGetMaxY(btnShop.frame)+5, 70, 10))
        texShop.font = UIFont(name: "Verdana", size: 14)
        texShop.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        texShop.textAlignment = NSTextAlignment.Center
        btnBackView.addSubview(texShop)
        
        //按键下面的主页label
        
        let touchSaleLabel = UITapGestureRecognizer.init(target: self, action: "nameLabelTouched:")
        let touchShopLabel = UITapGestureRecognizer.init(target: self, action: "nameLabelTouched:")
        let touchCampLabel = UITapGestureRecognizer.init(target: self, action: "nameLabelTouched:")
        let touchCarLabel = UITapGestureRecognizer.init(target: self, action: "nameLabelTouched:")
        let touchStudyLabel = UITapGestureRecognizer.init(target: self, action: "nameLabelTouched:")
        
        var sale = saleView.init(frame: CGRectMake(0, CGRectGetMaxY(btnBackView.frame)+20*Consts.ratio, windowWidth, 300*Consts.ratio))
        sale.backgroundColor = UIColor.whiteColor()
        scrollRootView.addSubview(sale)
        sale.nameLabel.addGestureRecognizer(touchSaleLabel)
        
        var shop = shopView.init(frame: CGRectMake(0, CGRectGetMaxY(sale.frame)+20*Consts.ratio, windowWidth, 300*Consts.ratio))
        shop.backgroundColor = UIColor.whiteColor()
        scrollRootView.addSubview(shop)
        shop.nameLabel.addGestureRecognizer(touchShopLabel)
        
        var camp = campView.init(frame: CGRectMake(0, CGRectGetMaxY(shop.frame)+20*Consts.ratio, windowWidth, 300*Consts.ratio))
        camp.backgroundColor = UIColor.whiteColor()
        scrollRootView.addSubview(camp)
        camp.nameLabel.addGestureRecognizer(touchCampLabel)
        
        var car = carView.init(frame: CGRectMake(0, CGRectGetMaxY(camp.frame)+20*Consts.ratio, windowWidth, 300*Consts.ratio))
        car.backgroundColor = UIColor.whiteColor()
        scrollRootView.addSubview(car)
        car.nameLabel.addGestureRecognizer(touchCarLabel)
        
        var study = studyView.init(frame: CGRectMake(0, CGRectGetMaxY(car.frame)+20*Consts.ratio, windowWidth, 340*Consts.ratio))
        study.backgroundColor = UIColor.whiteColor()
        scrollRootView.addSubview(study)
        study.nameLabel.addGestureRecognizer(touchStudyLabel)
        
    
        func setBtnText(){
            
            texCamp.text = (categoryRoot[0] as! String)
            texCar.text = (categoryRoot[1] as! String)
            texClothes.text = (categoryRoot[2] as! String)
            texStudy.text = (categoryRoot[3] as! String)
            texShop.text = (categoryRoot[4] as! String)
        }
        
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/category/shop/",headers:httpHeader).responseJSON{
            response in
            let json = JSON(response.result.value!)
            for(var count = 0;count < json["category"].count ; count++){
                var categoryName = json["category",count,"name"].stringValue
                self.categoryRoot.addObject(categoryName)
            }
            setBtnText()
        }
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/category/idle/",headers:httpHeader).responseJSON{
            response in
            let json = JSON(response.result.value!)
            for(var count = 0 ; count < json["category"].count ; count++){
                var categoryName = json["category",count,"name"].stringValue
                self.idleCategory.addObject(categoryName)
            }
        }
        // Do any additional setup after loading the view.
    }

    
    func selectLocation(){
        let vc = SelectLocationVC()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.hidesBottomBarWhenPushed = false
        super.viewWillDisappear(animated)
    }
    
    func search(){
        let vc = SearchVC()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
    
    func btnAction(sender : UIButton){
        if(sender.tag != 5){
            let classVc = ClassificationVC()
            classVc.isIdle = false
            classVc.categoryName = self.categoryRoot[sender.tag] as! NSString
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(classVc, animated: true)
        }
        else{
            let classVc = ClassificationVC()
            classVc.idleCategory = self.idleCategory
            classVc.isIdle = true
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(classVc, animated: true)
        }

    }
    func getAdv(){
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/advertisement/",headers:httpHeader).responseJSON(options: NSJSONReadingOptions.MutableContainers){
            response in
            let json = JSON(response.result.value!)
            var responseJson = json["advertisement"]
            for(var num = 0 ; num < responseJson.count ; num++){
                self.advArray.addObject(responseJson.arrayObject![num])
            }
            self.setAdv()
        }
    }
    func setAdv(){
        self.scrollBannerView.contentSize = CGSizeMake(windowWidth * CGFloat(self.advArray.count) ,0)
        for(var num = 0 ; num < self.advArray.count ; num++){
            let bannerView = UIImageView(frame: CGRectMake(windowWidth * CGFloat(num), 0, windowWidth, self.scrollBannerView.frame.size.height))
            bannerView.sd_setImageWithURL(NSURL(string: self.advArray[num].objectForKey("image")!as!String))
            bannerView.userInteractionEnabled = true
            bannerView.tag = num
            let action = UITapGestureRecognizer.init(target: self, action: "advTouched:")
            bannerView.addGestureRecognizer(action)
            self.scrollBannerView.addSubview(bannerView)
        }
        
    }
    func advTouched(sender : AnyObject){
        UIApplication.sharedApplication().openURL(NSURL(string: self.advArray[sender.view!!.tag].objectForKey("link")!as!String)!)
    }
    
    func nameLabelTouched(sender : AnyObject){
        if(sender.view!!.tag != 5){
            let classVc = ClassificationVC()
            classVc.isIdle = false
            classVc.categoryName = self.categoryRoot[sender.view!!.tag] as! NSString
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(classVc, animated: true)
        }
        else{
            let classVc = ClassificationVC()
            classVc.idleCategory = self.idleCategory
            classVc.isIdle = true
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(classVc, animated: true)
        }
    }
}
