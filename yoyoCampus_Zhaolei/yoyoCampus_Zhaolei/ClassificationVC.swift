//
//  ClassificationVC.swift
//  YouYouSchool-iOS
//
//  Created by 浩然 on 15/9/27.
//  Copyright © 2015年 浩然. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh


class ClassificationVC: UIViewController,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate {
    var categoryName = NSString()
    var labelName = NSMutableArray()
    var btnArray = NSMutableArray()
    var viewArray = NSMutableArray()
    var tableViewArray = NSMutableArray()
    var scrollBtnView = UIScrollView()
    var oldPage = 0
    var moveTemp :CGFloat = 0
    var btnScrollOldOffset :CGPoint = CGPoint(x: 0,y: 0)
    var flag = false
    var viewCount = CGFloat()
    
    var idleCategory = NSMutableArray()
    var pageArray = NSMutableArray()
    
    var dataNum = 0
    
    var isIdle:Bool = Bool()
    
    var moreX = CGFloat()
    var lessX : CGFloat = 0
    var btnLeftX : CGFloat = 0

    var oldBtnTag:Int = 0
    var newBtnTag:Int = 0
    
    var btnWidth = CGFloat()
    
    var idleAddBtn = UIButton()
    
    //盛放结果的数组
    var resultArray = NSMutableArray()
    
    var rootView = UIScrollView()
    var scrollIndicator = UIScrollView()
    var pageView = UIPageControl()
    var btn1 = UIButton()
    var btn2 = UIButton()
    var btn3 = UIButton()
    var btn4 = UIButton()
    var btn5 = UIButton()
    //导航栏右侧按钮的view
    var navBtnView = UIView(frame: CGRectMake(windowWidth*0.9, 20, windowWidth*0.2, 64))
    //排序的半透明背景
    let orderBack = UIView(frame:UIScreen.mainScreen().bounds)
    //排序按钮现实的label
    var orderLabel = UIView(frame: CGRectMake(0, -windowHeight*0.1, windowWidth, windowHeight*0.1))
    var orderBtn1 = UIButton()
    var orderBtn2 = UIButton()
    var orderBtn3 = UIButton()
    var orderBtn4 = UIButton()
    
    var orderImage1 = UIImageView()
    var orderImage2 = UIImageView()
    var orderImage3 = UIImageView()
    var orderImage4 = UIImageView()
    
    var orderCount = 0
    var orderText : [String] = ["view_number","score","last_update","price"]
    
    override func viewWillAppear(animated: Bool) {
        self.scrollBtnView.contentOffset.x = self.lessX
        self.scrollIndicator.contentOffset.x = -self.btnLeftX-self.lessX
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = Consts.grayView
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        Consts.setUpNavigationBarWithBackButton(self, title: self.categoryName as String, backTitle: "<")

        
        if(self.isIdle == false){
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/label/",parameters: ["category":categoryName],headers:httpHeader).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                //后台获取label的名字
                
                for(var count = 0 ; count < json["label"].count ; count++){
                    let name = json["label",count].stringValue
                    self.labelName.addObject(name)
                }
                let totalCount:CGFloat = CGFloat(json["label"].count)
                self.viewCount = totalCount
                
                if(json["label"].count != 0){
                    self.httpRequestShopData(self.dataNum)
                    //创建滑动窗口
                    let scrollRootVC = UIScrollView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
                    scrollRootVC.backgroundColor = Consts.grayView
                    scrollRootVC.delegate = self
                    scrollRootVC.directionalLockEnabled = true
                    scrollRootVC.showsHorizontalScrollIndicator = true
                    scrollRootVC.showsVerticalScrollIndicator = false
                    scrollRootVC.contentSize = CGSizeMake(windowWidth*totalCount, windowHeight)
                    scrollRootVC.pagingEnabled = true
                    self.rootView = scrollRootVC
                    self.view.addSubview(scrollRootVC)
                    //创建页面控制器
                    let pageCtl = UIPageControl(frame: CGRectMake(100, windowHeight-50, 50, 20))
                    pageCtl.numberOfPages = Int(self.viewCount)
                    pageCtl.currentPage = 0
                    self.pageView = pageCtl
                    self.view .addSubview(pageCtl)
                    
                    //创建按钮滑动view（按钮加在这上面）
                    let scrollBtnView = UIScrollView(frame: CGRectMake(0,0,windowWidth,40))
                    scrollBtnView.backgroundColor = UIColor.whiteColor()
                    scrollBtnView.delegate = self
                    scrollBtnView.directionalLockEnabled = true
                    scrollBtnView.showsHorizontalScrollIndicator = false
                    self.scrollBtnView = scrollBtnView
                    if(self.viewCount > 4){
                        scrollBtnView.contentSize = CGSizeMake(windowWidth, 30)
                        self.moreX = 80 * self.viewCount - windowWidth
                    }
                    else{
                        scrollBtnView.contentSize = CGSizeMake(windowWidth, 30)
                        self.moreX = 0
                    }
                    self.view.addSubview(scrollBtnView)
                    
                    
                    //小绿条105
                    let scrollIndicator = UIScrollView()
                    scrollIndicator.autoresizesSubviews = false
                    let indicatorView = UIView()
                    if(self.viewCount > 4){
                        scrollIndicator.frame = CGRectMake(0, 37, 80 * self.viewCount, 3)
                        scrollIndicator.contentSize = CGSizeMake(80 * self.viewCount, 3)
                        indicatorView.frame = CGRect(x: 0, y: 0, width: 80, height: 3)
                    }
                    else{
                        if(self.viewCount == 0){print("0")}
                        if(self.viewCount == 1){
                            scrollIndicator.frame = CGRectMake(windowWidth/2-100*Consts.ratio, 37, 200*Consts.ratio, 3)
                            scrollIndicator.contentSize = CGSize(width: 200*Consts.ratio, height: 3)
                            indicatorView.frame = CGRect(x: 0, y: 0, width: 200*Consts.ratio, height: 3)
                        }
                        if(self.viewCount == 2){
                            scrollIndicator.frame = CGRectMake(100*Consts.ratio, 37, windowWidth-200*Consts.ratio, 3)
                            scrollIndicator.contentSize = CGSize(width: windowWidth-200*Consts.ratio, height: 3)
                            indicatorView.frame = CGRect(x: 0, y: 0, width: 170*Consts.ratio, height: 3)
                        }
                        if(self.viewCount == 3){
                            scrollIndicator.frame = CGRectMake(60*Consts.ratio, 37, windowWidth-120*Consts.ratio, 3)
                            scrollIndicator.contentSize = CGSize(width: windowWidth-120*Consts.ratio, height: 3)
                            indicatorView.frame = CGRect(x: 0, y: 0, width: 120*Consts.ratio, height: 3)
                        }
                        if(self.viewCount == 4){
                            scrollIndicator.frame = CGRectMake(40*Consts.ratio, 37, windowWidth-80*Consts.ratio, 3)
                            scrollIndicator.contentSize = CGSize(width: windowWidth-80*Consts.ratio, height: 3)
                            indicatorView.frame = CGRect(x: 0, y: 0, width: 100*Consts.ratio, height: 3)
                        }
//                        scrollIndicator.frame = CGRectMake(0, 37, windowWidth, 3)
//                        scrollIndicator.contentSize = CGSize(width: windowWidth, height: 3)
//                        indicatorView.frame = CGRect(x: 0, y: 0, width: windowWidth/self.viewCount, height: 3)
                    }
                    self.scrollBtnView.addSubview(scrollIndicator)
                    self.scrollIndicator = scrollIndicator
                    
                    indicatorView.backgroundColor = UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1)
                    scrollIndicator.addSubview(indicatorView)
                    
                    
                    //创建按钮
                    var btnX:CGFloat = 0
                    var btnWidth = CGFloat()
                    if(self.viewCount > 4){
                        btnWidth = 80
                        self.btnWidth = btnWidth
                    }
                    else{
                        btnWidth = windowWidth/self.viewCount
                        self.btnWidth = btnWidth
                    }
                    for(var num = 0 ; num < json["label"].count ; num++){
                        let btn = UIButton(frame: CGRectMake(btnX,0, btnWidth, 37))
                        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                        btn.titleLabel?.font = UIFont(name: "Verdana", size: 15)
                        self.scrollBtnView.addSubview(btn)
                        btn.setTitle((self.labelName[num] as! String), forState: UIControlState.Normal)
                        btn.tag = num
                        btn.addTarget(self, action: Selector("pageTurn:"), forControlEvents: UIControlEvents.TouchUpInside)
                        btnX += btnWidth
                        self.btnArray.addObject(btn)
                    }
                    //创建页面
                    var viewX : CGFloat = 0
                    for(var num = 0 ; num < json["label"].count ; num++){
                        let view = UIView(frame: CGRectMake(viewX, 0, windowWidth, windowHeight))
                        view.backgroundColor = Consts.grayView
                        self.rootView.addSubview(view)
                        self.viewArray.addObject(view)
                        viewX += windowWidth
                    }
                    //创建tableview
                    for(var num = 0 ; num < Int(self.viewCount) ; num++){
                        var tableView = UITableView(frame: CGRectMake(0, 43, windowWidth, windowHeight-48))
                        self.setExtraCellLineHidden(tableView)
                        self.viewArray[num].addSubview(tableView)
                        self.tableViewArray.addObject(tableView)
                        tableView.tag = num
                        tableView.backgroundColor = UIColor.whiteColor()
                        tableView.dataSource = self
                        tableView.delegate = self
                        tableView.rowHeight = 230 * Consts.ratio
                        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefreshing:")
                        tableView.mj_footer.tag = num
                        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefreshing:")
                    }
                    
                    
                    /********************************/
                    //排序按钮和label的设置           //
                    
                    self.setBtnOrder()
                }
                if(json["label"].count == 0){
                    self.isEmptyView()
                }
            }
        }
        
        if(self.isIdle == true){
            self.viewCount = CGFloat(self.idleCategory.count)
            
            let scrollRootVC = UIScrollView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
            scrollRootVC.backgroundColor = Consts.grayView
            scrollRootVC.delegate = self
            scrollRootVC.directionalLockEnabled = true
            scrollRootVC.showsHorizontalScrollIndicator = false
            scrollRootVC.showsVerticalScrollIndicator = false
            scrollRootVC.contentSize = CGSizeMake(windowWidth*self.viewCount, windowHeight-100)
            scrollRootVC.pagingEnabled = true
            self.rootView = scrollRootVC
            self.view.addSubview(scrollRootVC)
            //创建页面控制器
            let pageCtl = UIPageControl(frame: CGRectMake(100, windowHeight-50, 50, 20))
            pageCtl.numberOfPages = Int(self.viewCount)
            pageCtl.currentPage = 0
            self.pageView = pageCtl
            self.view.addSubview(pageCtl)
            
            //创建按钮滑动view（按钮加在这上面）
            let scrollBtnView = UIScrollView(frame: CGRectMake(0,0,windowWidth,40))
            scrollBtnView.backgroundColor = UIColor.whiteColor()
            scrollBtnView.delegate = self
            scrollBtnView.directionalLockEnabled = true
            scrollBtnView.showsHorizontalScrollIndicator = false
            self.scrollBtnView = scrollBtnView
            if(self.viewCount > 4){
                scrollBtnView.contentSize = CGSizeMake(windowHeight, 30)
                self.moreX = 80 * self.viewCount - windowWidth

            }
            if(self.viewCount <= 4){
                scrollBtnView.contentSize = CGSizeMake(windowWidth, 30)
                self.moreX = 0
            }
            self.view.addSubview(scrollBtnView)
            
            
            //小绿条105
            let scrollIndicator = UIScrollView()
            scrollIndicator.autoresizesSubviews = false
            let indicatorView = UIView()
            if(self.viewCount > 4){
                scrollIndicator.frame = CGRectMake(0, 37, 80 * self.viewCount, 3)
                scrollIndicator.contentSize = CGSizeMake(80 * self.viewCount, 3)
                indicatorView.frame = CGRect(x: 0, y: 0, width: 80, height: 3)
            }
            else{
                if(self.viewCount == 0){}
                if(self.viewCount == 1){
                    scrollIndicator.frame = CGRectMake(windowWidth/2-100*Consts.ratio, 37, 200*Consts.ratio, 3)
                    scrollIndicator.contentSize = CGSize(width: 200*Consts.ratio, height: 3)
                    indicatorView.frame = CGRect(x: 0, y: 0, width: 200*Consts.ratio, height: 3)
                }
                if(self.viewCount == 2){
                    scrollIndicator.frame = CGRectMake(100*Consts.ratio, 37, windowWidth-200*Consts.ratio, 3)
                    scrollIndicator.contentSize = CGSize(width: windowWidth-200*Consts.ratio, height: 3)
                    indicatorView.frame = CGRect(x: 0, y: 0, width: 170*Consts.ratio, height: 3)
                }
                if(self.viewCount == 3){
                    scrollIndicator.frame = CGRectMake(60*Consts.ratio, 37, windowWidth-120*Consts.ratio, 3)
                    scrollIndicator.contentSize = CGSize(width: windowWidth-120*Consts.ratio, height: 3)
                    indicatorView.frame = CGRect(x: 0, y: 0, width: 120*Consts.ratio, height: 3)
                }
                if(self.viewCount == 4){
                    scrollIndicator.frame = CGRectMake(40*Consts.ratio, 37, windowWidth-80*Consts.ratio, 3)
                    scrollIndicator.contentSize = CGSize(width: windowWidth-80*Consts.ratio, height: 3)
                    indicatorView.frame = CGRect(x: 0, y: 0, width: 100*Consts.ratio, height: 3)
                }
            }
            self.scrollBtnView.addSubview(scrollIndicator)
            self.scrollIndicator = scrollIndicator
            
            indicatorView.backgroundColor = UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1)
            scrollIndicator.addSubview(indicatorView)
            
            
            //创建按钮
            var btnX:CGFloat = 0
            var btnWidth = CGFloat()
            if(self.viewCount > 4){
                btnWidth = 80
            }
            else{
                btnWidth = windowWidth/self.viewCount
            }
            for(var num = 0 ; num < Int(self.viewCount) ; num++){
                let btn = UIButton(frame: CGRectMake(btnX,0, btnWidth, 37))
                btn.setTitleColor(UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1), forState: UIControlState.Normal)
                btn.titleLabel?.font = UIFont(name: "Verdana", size: 15)
                self.scrollBtnView.addSubview(btn)
                btn.setTitle((self.idleCategory[num] as! String), forState: UIControlState.Normal)
                btn.tag = num
                btn.addTarget(self, action: Selector("pageTurn:"), forControlEvents: UIControlEvents.TouchUpInside)
                btnX += btnWidth
                self.btnArray.addObject(btn)
            }
            //创建页面
            var viewX : CGFloat = 0
            for(var num = 0 ; num < Int(self.viewCount) ; num++){
                let view = UIView(frame: CGRectMake(viewX, 0, windowWidth, windowHeight))
                view.backgroundColor = Consts.grayView
                self.rootView.addSubview(view)
                self.viewArray.addObject(view)
                viewX += windowWidth
            }
            //创建tableview
            for(var num = 0 ; num < Int(self.viewCount) ; num++){
                let tableView = UITableView(frame: CGRectMake(0, 43, windowWidth, windowHeight-60))
                self.setExtraCellLineHidden(tableView)
                self.viewArray[num].addSubview(tableView)
                self.tableViewArray.addObject(tableView)
                tableView.tag = num
                tableView.backgroundColor = UIColor.whiteColor()
                tableView.dataSource = self
                tableView.delegate = self
                tableView.rowHeight = 170 * Consts.ratio
                tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerIdleRefreshing:")
                tableView.mj_footer.tag = num
                tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction:"headerIdleRefreshing:")
            }
             self.httpRequestIdleData(self.dataNum)
            
            var idleAddBtn = UIButton(frame: CGRectMake(windowWidth*0.8, windowHeight-130, 110*Consts.ratio,110*Consts.ratio))
            idleAddBtn.setBackgroundImage(UIImage(named: "idle_Add"), forState: UIControlState.Normal)
            idleAddBtn.addTarget(self, action: "addIdle", forControlEvents: .TouchUpInside)
            self.view.addSubview(idleAddBtn)
            self.idleAddBtn = idleAddBtn
            
           self.setBtnOrder()
        }
        
        //搜索和排序按键
        let btnOrder = UIButton(frame: CGRectMake(windowWidth*0.09-20*Consts.ratio, 23, 40*Consts.ratio, 40*Consts.ratio))
        btnOrder.setBackgroundImage(UIImage(named: "home_3"), forState: UIControlState.Normal)
        btnOrder.addTarget(self, action: Selector("orderClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navBtnView.addSubview(btnOrder)
        
        
        let btnSearch = UIButton(frame: CGRectMake(CGRectGetMaxX(btnOrder.frame)+20*Consts.ratio, 23, 40*Consts.ratio, 40*Consts.ratio))
        btnSearch.setBackgroundImage(UIImage(named: "home_2"), forState: UIControlState.Normal)
        btnSearch.addTarget(self, action: "search", forControlEvents: .TouchUpInside)
        self.navBtnView.addSubview(btnSearch)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navBtnView)
        
       

        // Do any additional setup after loading the view.
        
}
    func search(){
        let vc = SearchVC()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setExtraCellLineHidden(tableView:UITableView){
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = view
    }
    
    func addIdle(){
        let vc = MyUploadGoodsViewController()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(scrollView == self.rootView){
            pageView.currentPage = Int(Float(rootView.contentOffset.x) / Float(windowWidth))
            scrollPageTurn(self.pageView.currentPage)
            if(pageView.currentPage > oldPage){
                self.btnLeftX += self.btnWidth
                if(self.btnLeftX > windowWidth/2 && self.moreX != 0){
                    var moveTemp = self.btnLeftX - windowWidth/2 + 40
                    if(self.moreX - moveTemp <= 0){
                        self.scrollBtnView.setContentOffset(CGPoint(x: self.scrollBtnView.contentOffset.x + self.moreX,y: self.scrollBtnView.contentOffset.y), animated: true)
                        self.lessX += self.moreX
                        self.btnLeftX -= self.moreX
                        self.moreX = 0
                    }
                    if(self.moreX - moveTemp > 0){
                         self.scrollBtnView.setContentOffset(CGPoint(x: self.scrollBtnView.contentOffset.x + moveTemp,y: self.scrollBtnView.contentOffset.y), animated: true)
                        self.lessX += moveTemp
                        self.btnLeftX -= moveTemp
                        self.moreX -= moveTemp
                    }
                    oldPage = pageView.currentPage
                }
                oldPage = pageView.currentPage
            }
            if(pageView.currentPage < oldPage){
                self.btnLeftX -= self.btnWidth
                if(self.btnLeftX < windowWidth/2-80 && self.lessX != 0){
                    var moveTemp = windowWidth/2 - 40 - self.btnLeftX
                    if(self.lessX - moveTemp <= 0){
                        self.scrollBtnView.setContentOffset(CGPoint(x: self.scrollBtnView.contentOffset.x - self.lessX,y: self.scrollBtnView.contentOffset.y), animated: true)
                        self.moreX += self.lessX
                        self.btnLeftX += self.lessX
                        self.lessX = 0
                    }
                    if(self.lessX - moveTemp > 0){
                        self.scrollBtnView.setContentOffset(CGPoint(x: self.scrollBtnView.contentOffset.x - moveTemp,y: self.scrollBtnView.contentOffset.y), animated: true)
                        self.lessX -= moveTemp
                        self.moreX += moveTemp
                        self.btnLeftX += moveTemp
                    }
                    oldPage = pageView.currentPage
                }
                oldPage = pageView.currentPage
            }
        }
        self.idleAddBtn.hidden = false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView == self.rootView){
            let offset : CGPoint = scrollView.contentOffset
            if(self.viewCount > 4){
                self.scrollIndicator.contentOffset = CGPoint(x:( -offset.x * 80)/windowWidth , y: offset.y)
            }
            else{
                self.scrollIndicator.contentOffset = CGPoint(x: -offset.x / self.viewCount, y: offset.y)
            }
        }
        if(self.isIdle == true){
            for(var num = 0 ; num < self.tableViewArray.count ; num++){
                if(scrollView == self.tableViewArray[num] as! NSObject){
                    self.idleAddBtn.hidden = true
                }
            }
        }

    }
    
    //按钮控制翻页
    
    func pageTurn(sender : UIButton){
        self.rootView.setContentOffset(CGPoint(x: CGFloat(sender.tag) * windowWidth, y: 0), animated: true)
        pageView.currentPage = sender.tag
        self.scrollBtnView(sender.tag)
        btnColorChange(sender.tag)
        self.tableViewArray[sender.tag].reloadData()
    }
    func scrollPageTurn(sender : Int){
        self.rootView.contentOffset = CGPoint(x: CGFloat(sender) * windowWidth, y: 0)
        pageView.currentPage = sender
        btnColorChange(sender)
        self.tableViewArray[sender].reloadData()

    }
    func scrollBtnView(newTag : Int){
        let jumpNum = newTag - self.oldPage
        if(pageView.currentPage > self.oldPage){
            self.btnLeftX += CGFloat(jumpNum)*self.btnWidth
            if(self.btnLeftX > windowWidth/2 && self.moreX != 0){
                let moveTemp = self.btnLeftX - windowWidth/2 + 40
                if(self.moreX - moveTemp <= 0){
                    self.scrollBtnView.setContentOffset(CGPoint(x: self.scrollBtnView.contentOffset.x + self.moreX,y: self.scrollBtnView.contentOffset.y), animated: true)
                    self.lessX += self.moreX
                    self.btnLeftX -= self.moreX
                    self.moreX = 0
                }
                if(self.moreX - moveTemp > 0){
                    self.scrollBtnView.setContentOffset(CGPoint(x: self.scrollBtnView.contentOffset.x + moveTemp,y: self.scrollBtnView.contentOffset.y), animated: true)
                    self.lessX += moveTemp
                    self.btnLeftX -= moveTemp
                    self.moreX -= moveTemp
                }
                oldPage = pageView.currentPage
            }
            oldPage = pageView.currentPage
        }
        if(pageView.currentPage < self.oldPage){
            self.btnLeftX = self.btnLeftX + CGFloat(jumpNum)*self.btnWidth
            if(self.btnLeftX < windowWidth/2-80 && self.lessX != 0){
                let moveTemp = windowWidth/2 - 40 - self.btnLeftX
                if(self.lessX - moveTemp <= 0){
                    self.scrollBtnView.setContentOffset(CGPoint(x: self.scrollBtnView.contentOffset.x - self.lessX,y: self.scrollBtnView.contentOffset.y), animated: true)
                    self.moreX += self.lessX
                    self.btnLeftX += self.lessX
                    self.lessX = 0
                }
                if(self.lessX - moveTemp > 0){
                    self.scrollBtnView.setContentOffset(CGPoint(x: self.scrollBtnView.contentOffset.x - moveTemp,y: self.scrollBtnView.contentOffset.y), animated: true)
                    self.lessX -= moveTemp
                    self.moreX += moveTemp
                    self.btnLeftX += moveTemp
                }
                oldPage = pageView.currentPage
            }
            oldPage = pageView.currentPage
        }
        oldPage = pageView.currentPage
    }
    //排序按钮
    func setBtnOrder(){
        let dissmissOrder = UITapGestureRecognizer.init(target: self, action: Selector("hideOrder"))
        
        self.orderBack.backgroundColor = UIColor.blackColor()
        self.orderBack.alpha = 0.4
        self.orderBack.hidden = true
        self.orderBack.addGestureRecognizer(dissmissOrder)
        self.view.addSubview(self.orderBack)
        
        self.orderLabel.backgroundColor = UIColor.whiteColor()
        self.orderLabel.hidden = true
        self.view.addSubview(self.orderLabel)
        
        let orderBtn1 = UIButton(frame: CGRectMake(80*Consts.ratio, 0, (windowWidth-320*Consts.ratio)/3, windowHeight*0.1))
        orderBtn1.setTitle("人气最高", forState: UIControlState.Normal)
        orderBtn1.titleLabel?.font = UIFont(name: "Verdana", size: 14)
        orderBtn1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        orderBtn1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -40, 0)
        orderBtn1.addTarget(self, action: Selector("orderBtn1Select:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.orderLabel.addSubview(orderBtn1)
        let orderImage1 = UIImageView(frame: CGRectMake((orderBtn1.titleLabel?.center.x)!-20*Consts.ratio, 10, 25, 25))
        orderImage1.image = UIImage(named: "order_12")
        orderBtn1.addSubview(orderImage1)
        self.orderBtn1 = orderBtn1
        self.orderImage1 = orderImage1
        
        
        let orderBtn3 = UIButton(frame: CGRectMake(CGRectGetMaxX(orderBtn1.frame)+80*Consts.ratio, 0, orderBtn1.frame.width, orderBtn1.frame.height))
        orderBtn3.setTitle("最新发布", forState: UIControlState.Normal)
        orderBtn3.titleLabel?.font = UIFont(name: "Verdana", size: 14)
        orderBtn3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        orderBtn3.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -40, 0)
        orderBtn3.addTarget(self, action: Selector("orderBtn3Select:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.orderLabel.addSubview(orderBtn3)
        let orderImage3 = UIImageView(frame: CGRectMake((orderBtn3.titleLabel?.center.x)!-20*Consts.ratio, 10, 25, 25))
        orderImage3.image = UIImage(named: "order_31")
        orderBtn3.addSubview(orderImage3)
        self.orderBtn3 = orderBtn3
        self.orderImage3 = orderImage3
        
        let orderBtn4 = UIButton(frame: CGRectMake(CGRectGetMaxX(orderBtn3.frame)+80*Consts.ratio, 0, orderBtn1.frame.width, orderBtn1.frame.height))
        orderBtn4.setTitle("价格最低", forState: UIControlState.Normal)
        orderBtn4.titleLabel?.font = UIFont(name: "Verdana", size: 14)
        orderBtn4.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        orderBtn4.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -40, 0)
        orderBtn4.addTarget(self, action: Selector("orderBtn4Select:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.orderLabel.addSubview(orderBtn4)
        let orderImage4 = UIImageView(frame: CGRectMake((orderBtn4.titleLabel?.center.x)!-20*Consts.ratio, 10, 25, 25))
        orderImage4.image = UIImage(named: "order_41")
        orderBtn4.addSubview(orderImage4)
        self.orderBtn4 = orderBtn4
        self.orderImage4 = orderImage4
    }
    

    //按钮颜色变化
    func btnColorChange(which : Int ){
        for(var num = 0 ; num < Int(self.viewCount) ; num++){
            if(num != which){
                self.btnArray[num].setTitleColor(UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1), forState: UIControlState.Normal)
            }
            else{
                self.btnArray[num].setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
            }
        }
    }
    func orderColorChange(which : Int){
        switch(which){
        case 0:
            self.orderBtn1.setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage1.image = UIImage(named: "order_12")
            self.orderBtn2.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage2.image = UIImage(named: "order_21")
            self.orderBtn3.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage3.image = UIImage(named: "order_31")
            self.orderBtn4.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage4.image = UIImage(named: "order_41")
        case 1:
            self.orderBtn1.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage1.image = UIImage(named: "order_11")
            self.orderBtn2.setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage2.image = UIImage(named: "order_22")
            self.orderBtn3.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage3.image = UIImage(named: "order_31")
            self.orderBtn4.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage4.image = UIImage(named: "order_41")
        case 2:
            self.orderBtn1.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage1.image = UIImage(named: "order_11")
            self.orderBtn2.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage2.image = UIImage(named: "order_21")
            self.orderBtn3.setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage3.image = UIImage(named: "order_32")
            self.orderBtn4.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage4.image = UIImage(named: "order_41")
        case 3:
            self.orderBtn1.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage1.image = UIImage(named: "order_11")
            self.orderBtn2.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage2.image = UIImage(named: "order_21")
            self.orderBtn3.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage3.image = UIImage(named: "order_31")
            self.orderBtn4.setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
            self.orderImage4.image = UIImage(named: "order_42")
        default :
            break
        }
    }
    func orderBtn1Select(sender : UIButton){
        self.orderColorChange(0)
        if(self.isIdle == false){
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/goods/search/",headers:httpHeader,parameters: ["location":"东南大学九龙湖校区","page":"1","category":self.categoryName,"label":self.labelName[self.pageView.currentPage],"order":"view_number"]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["result"]
                self.resultArray[self.pageView.currentPage] = responseJson.arrayObject!
                self.orderCount = 0
                self.pageArray[self.pageView.currentPage] = 1
                self.tableViewArray[self.pageView.currentPage].reloadData()
            }
        }
        if(self.isIdle == true){
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/idle/search/",headers:httpHeader,parameters: ["location":"东南大学九龙湖校区","page":"1","category":self.idleCategory[self.pageView.currentPage],"order":"view_number"]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["result"]
                self.resultArray[self.pageView.currentPage] = responseJson.arrayObject!
                self.orderCount = 0
                self.pageArray[self.pageView.currentPage] = 1
                self.tableViewArray[self.pageView.currentPage].reloadData()
            }
        }
        self.hideOrder()
    }
    
    func orderBtn3Select(sender : UIButton){
        self.orderColorChange(2)
        if(self.isIdle == false){
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/goods/search/",headers:httpHeader,parameters: ["location":"东南大学九龙湖校区","page":"1","category":self.categoryName,"label":self.labelName[self.pageView.currentPage],"order":"last_update"]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["result"]
                self.resultArray[self.pageView.currentPage] = responseJson.arrayObject!
                self.orderCount = 2
                self.pageArray[self.pageView.currentPage] = 1
                self.tableViewArray[self.pageView.currentPage].reloadData()
                
                
            }
        }
        if(self.isIdle == true){
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/idle/search/",headers:httpHeader,parameters: ["location":"东南大学九龙湖校区","page":"1","category":self.idleCategory[self.pageView.currentPage],"order":"last_update"]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["result"]
                self.resultArray[self.pageView.currentPage] = responseJson.arrayObject!
                self.orderCount = 2
                self.pageArray[self.pageView.currentPage] = 1
                self.tableViewArray[self.pageView.currentPage].reloadData()
            }
        }
        self.hideOrder()

    }
    func orderBtn4Select(sender : UIButton){
        self.orderColorChange(3)
        if(self.isIdle == false){
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/goods/search/",headers:httpHeader,parameters: ["location":"东南大学九龙湖校区","page":"1","category":self.categoryName,"label":self.labelName[self.pageView.currentPage],"order":"price"]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["result"]
                self.resultArray[self.pageView.currentPage] = responseJson.arrayObject!
                self.orderCount = 3
                self.pageArray[self.pageView.currentPage] = 1
                self.tableViewArray[self.pageView.currentPage].reloadData()
            }
        }
        if(self.isIdle == true){
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/idle/search/",headers:httpHeader,parameters: ["location":"东南大学九龙湖校区","page":"1","category":self.idleCategory[self.pageView.currentPage],"order":"price"]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["result"]
                self.resultArray[self.pageView.currentPage] = responseJson.arrayObject!
                self.orderCount = 3
                self.pageArray[self.pageView.currentPage] = 1
                self.tableViewArray[self.pageView.currentPage].reloadData()
            }
        }
        self.hideOrder()

    }
    
    //tableview 相关函数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.flag == false){
            return 0
        }
       else {
            for(var n = 0 ; n < Int(self.viewCount) ; n++){
                if(tableView == self.tableViewArray[n] as! NSObject){
                    return self.resultArray[n].count!
                }
            }
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(self.flag == false){
            let defaultCell = UITableViewCell()
            return defaultCell
        }
        else if(self.isIdle == false){
            for(var n = 0 ; n < Int(self.viewCount) ; n++){
                if(tableView == tableViewArray[n] as! NSObject){
                    let viewCell = ViewCell()
                    viewCell.isIdleCell = false
                    viewCell.selectionStyle = UITableViewCellSelectionStyle.None
                    viewCell.setData(self.resultArray[n] .objectAtIndex(indexPath.row))
                    return viewCell
                }
            }
        }
        else{
            for(var n = 0 ; n < Int(self.viewCount) ; n++){
                if(tableView == tableViewArray[n] as! NSObject){
                    let viewCell = ViewCell()
                    viewCell.isIdleCell = true
                    viewCell.selectionStyle = UITableViewCellSelectionStyle.None
                    viewCell.setData(self.resultArray[n] .objectAtIndex(indexPath.row))
                    return viewCell
                }

        }
    }
        let defaultCell = UITableViewCell()
        return defaultCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(self.isIdle == true){
            let tempCell = tableView.cellForRowAtIndexPath(indexPath) as! ViewCell
            let vc = IdleGoodViewController()
            vc.idle_id = tempCell.dataCell.objectForKey("idle_id") as! String
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            let tempCell = tableView.cellForRowAtIndexPath(indexPath) as! ViewCell
            let vc = ShopGoodViewController()
            vc.goods_ID = tempCell.dataCell.objectForKey("goods_id")as! String
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //点击排序的图标事件
    func orderClick(sender : AnyObject){
        
        self.orderBack.hidden = false
        self.orderLabel.hidden = false
        var rect :CGRect = orderLabel.frame
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        if(rect.origin.y < 0){
            rect.origin.y += windowHeight*0.1
        }
        orderLabel.frame = rect
        UIView.commitAnimations()
        self.orderColorChange(self.orderCount)
    }
    
    //隐藏注册事件
    func hideOrder(){
        self.orderLabel.frame = CGRect(x: 0, y: -windowHeight*0.1, width: windowHeight, height: windowHeight*0.1)
        self.orderLabel.hidden = true
        self.orderBack.hidden = true
    }
    
    //获取数据
    func httpRequestShopData(nexLabel:Int){
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/goods/search/", parameters: ["location":"东南大学九龙湖校区","page":"1","category":self.categoryName,"label":self.labelName[nexLabel]], headers: httpHeader).responseJSON(options:NSJSONReadingOptions.MutableContainers ){
            response in
            let temp = JSON(response.result.value!)
            let responseJson = temp["result"]
            self.didReceiveData(responseJson.arrayObject!)
            
        }
        
    }
    func didReceiveData(data : AnyObject){
        self.resultArray.addObject(data)
        self.pageArray.addObject(1)
        self.dataNum++
        if(self.dataNum == Int(self.viewCount)){
            self.flag = true
            self.scrollPageTurn(0)
        }
        else{
            httpRequestShopData(self.dataNum)
        }
    }
    
    func httpRequestIdleData(nexLabel:Int){
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/idle/search/",parameters:["location":"东南大学九龙湖校区","page":"1","category":self.idleCategory[nexLabel]],headers:httpHeader).responseJSON(options:NSJSONReadingOptions.MutableContainers){
            response in
            let temp = JSON(response.result.value!)
            let responseJson = temp["result"]
            self.didReceiveIdleData(responseJson.arrayObject!)
        }
    }
    func didReceiveIdleData(data : AnyObject){
        self.resultArray.addObject(data)
        self.pageArray.addObject(1)
        self.dataNum++
        if(self.dataNum == Int(self.viewCount)){
            self.flag = true
            self.scrollPageTurn(0)
            //self.orderBtn1Select(self.orderBtn1)

        }
        else{
            httpRequestIdleData(self.dataNum)
        }
    }
    
    //上拉加载
    func footerRefreshing(sender : AnyObject){
        var page :Int = (self.pageArray[sender.tag]as! Int)
        page++
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/goods/search/", parameters: ["location":"东南大学九龙湖校区","page":page,"category":self.categoryName,"label":self.labelName[sender.tag],"order":self.orderText[self.orderCount]], headers: httpHeader).responseJSON(options:NSJSONReadingOptions.MutableContainers){
            response in
            let temp = JSON(response.result.value!)
            let responseJson = temp["result"]
            if(responseJson.count != 0){
                var tempArray =  self.resultArray[sender.tag].mutableCopy()
                for(var num = 0 ; num < responseJson.count ; num++){
                    tempArray.addObject(responseJson.arrayObject![num])
                }
                self.resultArray.replaceObjectAtIndex(sender.tag, withObject: tempArray)
                self.tableViewArray[sender.tag].reloadData()
                self.pageArray[sender.tag] = page
                var temp :UITableView = self.tableViewArray[sender.tag] as! UITableView
                temp.mj_footer!.endRefreshing()
            }
            else{
                page--
                self.pageArray[sender.tag] = page
                var temp :UITableView = self.tableViewArray[sender.tag] as! UITableView
                temp.mj_footer!.endRefreshing()
            }
           
            
        }
    }
    func footerIdleRefreshing(sender : AnyObject){
        var page : Int = (self.pageArray[sender.tag]as! Int)
        page++
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/idle/search/", parameters: ["location":"东南大学九龙湖校区","page":page,"category":self.idleCategory[sender.tag],"order":self.orderText[self.orderCount]], headers: httpHeader).responseJSON(options:NSJSONReadingOptions.MutableContainers){
            response in
            let temp = JSON(response.result.value!)
            let responseJson = temp["result"]
            if(responseJson.count != 0){
                let tempArray =  self.resultArray[sender.tag].mutableCopy()
                for(var num = 0 ; num < responseJson.count ; num++){
                    tempArray.addObject(responseJson.arrayObject![num])
                }
                self.resultArray.replaceObjectAtIndex(sender.tag, withObject: tempArray)
                self.tableViewArray[sender.tag].reloadData()
                self.pageArray[sender.tag] = page
                let temp :UITableView = self.tableViewArray[sender.tag] as! UITableView
                temp.mj_footer!.endRefreshing()
            }
            else{
                page--
                self.pageArray[sender.tag] = page
                let temp :UITableView = self.tableViewArray[sender.tag] as! UITableView
                temp.mj_footer!.endRefreshing()
            }
        }
    }
    
    func headerRefreshing(sender : AnyObject){
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/goods/search/",headers:httpHeader,parameters: ["location":"东南大学九龙湖校区","page":"1","category":self.categoryName,"order":self.orderText[self.orderCount],"label":self.labelName[self.pageView.currentPage]]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
            response in
            let json = JSON(response.result.value!)
            var responseJson = json["result"]
            self.resultArray[self.pageView.currentPage] = responseJson.arrayObject!
            self.pageArray[self.pageView.currentPage] = 1
            self.tableViewArray[self.pageView.currentPage].reloadData()
            (self.tableViewArray[self.pageView.currentPage] as! UITableView).mj_header!.endRefreshing()
            
        }
    }
    func headerIdleRefreshing(sender : AnyObject){
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/idle/search/", parameters: ["location":"东南大学九龙湖校区","page":"1","category":self.idleCategory[self.pageView.currentPage],"order":self.orderText[self.orderCount]], headers: httpHeader).responseJSON(options:NSJSONReadingOptions.MutableContainers){
            response in
            let json = JSON(response.result.value!)
            var responseJson = json["result"]
            
            self.resultArray[self.pageView.currentPage] = responseJson.arrayObject!
            self.pageArray[self.pageView.currentPage] = 1
            self.tableViewArray[self.pageView.currentPage].reloadData()
            (self.tableViewArray[self.pageView.currentPage] as! UITableView).mj_header!.endRefreshing()
            print(self.orderCount)
        }
    }
    
    func goBack(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    func isEmptyView(){
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
}
