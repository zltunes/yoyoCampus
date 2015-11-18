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


let  windowWidth = UIScreen .mainScreen().bounds.width
let  windowHeight = UIScreen .mainScreen().bounds.height
let httpHeader = ["access_token": "d2bfd4c2-8460-11e5-82bd-00163e021195"]


class RootVC: UIViewController,UIScrollViewDelegate{

//
//    var scrollRootView = UIScrollView()
//    var scrollBannerView = UIScrollView()
//    var bannerView = UIImageView()
//    
//    var btnSale = UIButton()
//    var btnCamp = UIButton()
//    var btnCar = UIButton()
//    var btnClothes = UIButton()
//    var btnStudy = UIButton()
//    var btnShop = UIButton()
      var idleCategory = NSMutableArray()
      var categoryRoot = NSMutableArray()

    var searchBtn = UIButton(frame: CGRectMake(windowWidth*0.9, 10, 20, 20))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBtn.setBackgroundImage(UIImage(named: "home_2"), forState: UIControlState.Normal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
        
        self.view.backgroundColor = UIColor .whiteColor()
        self.title = "东南大学九龙湖校区"
        
        //获取类目
        
        //总界面是一个scrollRootView
        let scrollRootView = UIScrollView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
        scrollRootView.backgroundColor = UIColor(red: 234/255, green: 236/255, blue: 234/255, alpha: 1)
        scrollRootView.delegate = self
        scrollRootView.directionalLockEnabled = true
        scrollRootView.showsVerticalScrollIndicator = true
        scrollRootView.showsHorizontalScrollIndicator = false
        scrollRootView.contentSize = CGSizeMake(windowWidth, windowHeight*1.8)
        scrollRootView.scrollEnabled = true
        self.view.addSubview(scrollRootView)
	    //banner的scrollView
        let scrollBannerView = UIScrollView(frame: CGRectMake(0, 0, windowWidth, windowHeight*0.25))
        scrollBannerView.delegate = self
        scrollBannerView.directionalLockEnabled = true
        scrollBannerView.showsHorizontalScrollIndicator = true
        scrollBannerView.showsVerticalScrollIndicator = false
        scrollBannerView.contentSize = CGSizeMake(windowWidth*2, windowHeight*0.25)
        scrollBannerView.backgroundColor = UIColor.whiteColor()
        //翻页效果加进去会比较好，控制左右拖动的随意性
        scrollBannerView.pagingEnabled = true
        scrollRootView.addSubview(scrollBannerView)
        
        let bannerView1 = UIImageView(frame: CGRectMake(windowWidth, 0, windowWidth, scrollBannerView.frame.size.height))
        bannerView1.image = UIImage(named: "banner1.png")
        scrollBannerView.addSubview(bannerView1)
        
        let bannerView2 = UIImageView(frame: CGRectMake(0, 0, windowWidth, scrollBannerView.frame.size.height))
        bannerView2.image = UIImage(named: "banner2.png")
        scrollBannerView.addSubview(bannerView2)
        
        //6个按键的布置
        let btnBackView = UIView(frame: CGRectMake(0, CGRectGetMaxY(scrollBannerView.frame)+10, windowWidth, windowHeight*0.32))
        btnBackView.backgroundColor = UIColor.whiteColor()
        scrollRootView.addSubview(btnBackView)
        
        let btnSale = UIButton(frame: CGRectMake(btnBackView.frame.size.width*0.05, 10, btnBackView.frame.size.width * 0.2, btnBackView.frame.size.width * 0.2))
        btnSale.setBackgroundImage(UIImage(named: "btn_1"), forState: UIControlState.Normal)
        btnSale.layer.cornerRadius = btnBackView.frame.size.width * 0.1
        btnSale.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnSale.tag = 5
        btnBackView.addSubview(btnSale)
        
        let texSale = UILabel(frame: CGRectMake(CGRectGetMinX(btnSale.frame), CGRectGetMaxY(btnSale.frame)+5, 70, 10))
        texSale.text = "闲置"
        texSale.font = UIFont.systemFontOfSize(16)
        texSale.textAlignment = NSTextAlignment.Center
        btnBackView.addSubview(texSale)
        
        let btnCamp = UIButton(frame: CGRectMake(CGRectGetMaxX(btnSale.frame)+50, CGRectGetMinY(btnSale.frame), btnBackView.frame.size.width * 0.2, btnBackView.frame.size.width * 0.2))
        btnCamp.setBackgroundImage(UIImage(named: "btn_2"), forState: UIControlState.Normal)
        btnCamp.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnCamp.tag = 0
        btnCamp.layer.cornerRadius = btnBackView.frame.size.width * 0.1
        btnBackView.addSubview(btnCamp)
        
        let texCamp = UILabel(frame: CGRectMake(CGRectGetMinX(btnCamp.frame), CGRectGetMaxY(btnSale.frame)+5, 70, 10))
        texCamp.font = UIFont.systemFontOfSize(16)
        texCamp.textAlignment = NSTextAlignment.Center
        btnBackView.addSubview(texCamp)
        
        
        let btnCar = UIButton(frame: CGRectMake(CGRectGetMaxX(btnCamp.frame)+50, CGRectGetMinY(btnCamp.frame), btnBackView.frame.size.width * 0.2, btnBackView.frame.size.width * 0.2))
        btnCar.setBackgroundImage(UIImage(named: "btn_3"), forState: UIControlState.Normal)
        btnCar.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnCar.tag = 1
        btnCar.layer.cornerRadius = btnBackView.frame.size.width * 0.1
        btnBackView.addSubview(btnCar)
        
        let texCar = UILabel(frame: CGRectMake(CGRectGetMinX(btnCar.frame),CGRectGetMaxY(btnSale.frame)+5, 70, 10))
        texCar.font = UIFont.systemFontOfSize(16)
        texCar.textAlignment = NSTextAlignment.Center
        btnBackView.addSubview(texCar)
        
        let btnClothes = UIButton(frame: CGRectMake(CGRectGetMinX(btnSale.frame), CGRectGetMaxY(btnSale.frame)+25, btnBackView.frame.size.width * 0.2, btnBackView.frame.size.width * 0.2))
        btnClothes.setBackgroundImage(UIImage(named: "btn_4"), forState: UIControlState.Normal)
        btnClothes.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnClothes.tag = 2
        btnClothes.layer.cornerRadius = btnBackView.frame.size.width * 0.1
        btnBackView.addSubview(btnClothes)
        
        let texClothes = UILabel(frame: CGRectMake(CGRectGetMinX(btnClothes.frame), CGRectGetMaxY(btnClothes.frame)+5, 70, 10))
        texClothes.font = UIFont.systemFontOfSize(16)
        texClothes.textAlignment = NSTextAlignment.Center
        btnBackView.addSubview(texClothes)
        
        let btnStudy = UIButton(frame: CGRectMake(CGRectGetMaxX(btnClothes.frame)+50, CGRectGetMinY(btnClothes.frame), btnBackView.frame.size.width * 0.2, btnBackView.frame.size.width * 0.2))
        btnStudy.setBackgroundImage(UIImage(named: "btn_5"), forState: UIControlState.Normal)
        btnStudy.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnStudy.tag = 3
        btnStudy.layer.cornerRadius = btnBackView.frame.size.width * 0.1
        btnBackView.addSubview(btnStudy)
        
        let texStudy = UILabel(frame: CGRectMake(CGRectGetMinX(btnStudy.frame), CGRectGetMaxY(btnStudy.frame)+5, 70, 10))
        texStudy.font = UIFont.systemFontOfSize(16)
        texStudy.textAlignment = NSTextAlignment.Center
        btnBackView.addSubview(texStudy)
        
        let btnShop = UIButton(frame: CGRectMake(CGRectGetMaxX(btnStudy.frame)+50, CGRectGetMinY(btnStudy.frame), btnBackView.frame.size.width * 0.2, btnBackView.frame.size.width * 0.2))
        btnShop.setBackgroundImage(UIImage(named: "btn_6"), forState: UIControlState.Normal)
        btnShop.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnShop.tag = 4
        btnShop.layer.cornerRadius = btnBackView.frame.size.width * 0.1
        btnBackView.addSubview(btnShop)
        
        let texShop = UILabel(frame: CGRectMake(CGRectGetMinX(btnShop.frame), CGRectGetMaxY(btnShop.frame)+5, 70, 10))
        texShop.font = UIFont.systemFontOfSize(16)
        texShop.textAlignment = NSTextAlignment.Center
        btnBackView.addSubview(texShop)
        
        //按键下面的主页label
        var study = studyView.init(frame: CGRectMake(0, CGRectGetMaxY(btnBackView.frame)+10, windowWidth, windowHeight*0.24))
        study.backgroundColor = UIColor.whiteColor()
        scrollRootView.addSubview(study)
        
        var car = carView.init(frame: CGRectMake(0, CGRectGetMaxY(study.frame)+10, windowWidth, windowHeight*0.2))
        car.backgroundColor = UIColor.whiteColor()
        scrollRootView.addSubview(car)
        
        var camp = campView.init(frame: CGRectMake(0, CGRectGetMaxY(car.frame)+10, windowWidth, windowHeight*0.24))
        camp.backgroundColor = UIColor.whiteColor()
        scrollRootView.addSubview(camp)
        
        var sale = saleView.init(frame: CGRectMake(0, CGRectGetMaxY(camp.frame)+10, windowWidth, windowHeight*0.2))
        sale.backgroundColor = UIColor.whiteColor()
        scrollRootView.addSubview(sale)
        
        var shop = shopView.init(frame: CGRectMake(0, CGRectGetMaxY(sale.frame)+10, windowWidth, windowHeight*0.2))
        shop.backgroundColor = UIColor.whiteColor()
        scrollRootView.addSubview(shop)
        
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
    
    func btnAction(sender : UIButton){
        if(sender.tag != 5){
            let classVc = ClassificationVC()
            classVc.isIdle = false
            classVc.categoryName = self.categoryRoot[sender.tag] as! NSString
            self.navigationController?.pushViewController(classVc, animated: true)
        }
        else{
            let classVc = ClassificationVC()
            classVc.idleCategory = self.idleCategory
            classVc.isIdle = true
            self.navigationController?.pushViewController(classVc, animated: true)
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
