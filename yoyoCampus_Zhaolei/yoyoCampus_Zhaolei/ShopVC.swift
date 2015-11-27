//
//  ShopVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 浩然 on 15/11/15.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

class ShopVC: UIViewController,UIScrollViewDelegate ,UITableViewDelegate,UITableViewDataSource{
    
    var rootView = UIScrollView()
    var pageView = UIPageControl()
    var shopCategory = NSMutableArray()
    var viewArray = NSMutableArray()
    var tableViewArray = NSMutableArray()
    var resultArray = NSMutableArray()
    var btnArray = NSMutableArray()
    var pageArray = [Int]()
    var viewCount = Int()
    var dataNum = 0
    var flag = false
    
    var navBtnView = UIView(frame: CGRectMake(windowWidth*0.9, 20, windowWidth*0.2, 64))

    
    var scrollBtnView = UIScrollView()
    var scrollIndicator = UIScrollView()
    
    override func viewWillAppear(animated: Bool) {
        self.scrollIndicator.contentOffset.x = -CGFloat(self.pageView.currentPage) * windowWidth / CGFloat(self.viewCount)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = Consts.grayView
        Consts.setUpNavigationBarWithBackButton(self,title: "商家", backTitle: "<")
        super.viewDidLoad()
        self.getShopCategory()

    }
    
    override func viewWillDisappear(animated: Bool) {
        self.hidesBottomBarWhenPushed = false
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getShopCategory(){
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/category/shop/",headers:httpHeader).responseJSON(options: NSJSONReadingOptions.MutableContainers){
            response in
            var json = JSON(response.result.value!)
            var responseJson = json["category"]
            //注意这里多了一层
            for(var num = 0 ; num < responseJson.count ; num++){
                self.shopCategory.addObject(responseJson.arrayObject![num])
            }
            self.viewCount = responseJson.count
            self.getShopData(0)
        }
    }
    
    func getShopData(nextLabel:Int){
                Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/shop/search/",headers:httpHeader,parameters:["location":"东南大学九龙湖校区","page":"1","category":self.shopCategory[nextLabel].objectForKey("name")!]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                var json = JSON(response.result.value!)
                var responseJson = json["result"]
                self.didReceiveShopData(responseJson.arrayObject!)
        }
    }
    
    func didReceiveShopData(data:AnyObject){
        self.resultArray.addObject(data)
        self.pageArray.append(1)
        self.dataNum++
        if(self.dataNum == Int(self.viewCount)){
            self.flag = true
            //接收完数据开始绘制界面
            self.setAllView()
            self.scrollPageTurn(0)
        }
        else{
            self.getShopData(self.dataNum)
        }
        
    }
    
    func setExtraCellLineHidden(tableView:UITableView){
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = view
    }
    
    func setAllView(){
        
        //根scrollview
        let scrollRootVC = UIScrollView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
        scrollRootVC.backgroundColor = Consts.grayView
        scrollRootVC.delegate = self
        scrollRootVC.directionalLockEnabled = true
        scrollRootVC.showsHorizontalScrollIndicator = true
        scrollRootVC.showsVerticalScrollIndicator = false
        scrollRootVC.contentSize = CGSizeMake(windowWidth*CGFloat(self.viewCount), windowHeight-100)
        scrollRootVC.pagingEnabled = true
        self.rootView = scrollRootVC
        self.view.addSubview(scrollRootVC)
        
        //pageControl
        let pageCtl = UIPageControl(frame: CGRectMake(100, windowHeight-50, 50, 20))
        pageCtl.numberOfPages = Int(self.viewCount)
        pageCtl.currentPage = 0
        self.pageView = pageCtl
        self.view .addSubview(pageCtl)
        
        //btnView
        let scrollBtnView = UIScrollView(frame: CGRectMake(0,0,windowWidth,40))
        scrollBtnView.backgroundColor = UIColor.whiteColor()
        scrollBtnView.delegate = self
        scrollBtnView.directionalLockEnabled = true
        scrollBtnView.showsHorizontalScrollIndicator = false
        self.scrollBtnView = scrollBtnView
        scrollBtnView.contentSize = CGSizeMake(windowWidth, 40)
        self.view.addSubview(scrollBtnView)
        
        //小绿条
        let scrollIndicator = UIScrollView()
        let indicatorView = UIView()
        scrollIndicator.frame = CGRectMake(0, 37, windowWidth, 3)
        scrollIndicator.contentSize = CGSize(width: windowWidth, height: 3)
        indicatorView.frame = CGRect(x: 0, y: 0, width: windowWidth/CGFloat(self.viewCount), height: 3)
        self.scrollBtnView.addSubview(scrollIndicator)
        self.scrollIndicator = scrollIndicator
        indicatorView.backgroundColor = UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1)
        scrollIndicator.addSubview(indicatorView)
        
        //btn
        var btnX:CGFloat = 0
        let btnWidth : CGFloat = windowWidth/CGFloat(self.viewCount)
        
        for(var num = 0 ; num < self.viewCount ; num++){
            let btn = UIButton(frame: CGRectMake(btnX,0, btnWidth, 37))
            btn.setTitleColor(UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1), forState: UIControlState.Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(16)
            self.scrollBtnView.addSubview(btn)
            btn.setTitle((self.shopCategory[num].objectForKey("name")!) as! String, forState: UIControlState.Normal)
            btn.tag = num
            btn.addTarget(self, action: Selector("pageTurn:"), forControlEvents: UIControlEvents.TouchUpInside)
            btnX += btnWidth
            self.btnArray.addObject(btn)
            
        }
        
        //放table的view
        var viewX : CGFloat = 0
        for(var num = 0 ; num < self.viewCount ; num++){
            let view = UIView(frame: CGRectMake(viewX, 0, windowWidth, windowHeight))
            view.backgroundColor = Consts.grayView
            self.rootView.addSubview(view)
            self.viewArray.addObject(view)
            viewX += windowWidth
        }
        
        //tableView
        for(var num = 0 ; num < self.viewCount ; num++){
            var tableView = UITableView(frame: CGRectMake(0, 43, windowWidth, windowHeight-50))
            self.viewArray[num].addSubview(tableView)
            self.tableViewArray.addObject(tableView)
            tableView.tag = num
            tableView.backgroundColor = UIColor.whiteColor()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = (windowHeight+100)/6
            tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefreshing:")
            tableView.footer.tag = num

            setExtraCellLineHidden(tableView)

            tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefreshing:")
            tableView.header.tag = num

        }
        
        //搜索按钮
//        let btnSearch = UIButton(frame: CGRectMake(windowWidth*0.09+20, 23, 20, 20))
//        btnSearch.setBackgroundImage(UIImage(named: "home_2"), forState: UIControlState.Normal)
//        btnSearch.addTarget(self, action: "search", forControlEvents: .TouchUpInside)
//        self.navBtnView.addSubview(btnSearch)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navBtnView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "home_2.png"), style: .Plain, target: self, action: "search")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

    }
    
    func search(){
        let vc = SearchVC()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.flag == false){
            return 0
        }
        if(self.flag == true){
            for(var n = 0 ; n < self.viewCount ; n++){
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
        if(self.flag == true){
            for(var n = 0 ; n < self.viewCount ; n++){
                if(tableView == tableViewArray[n] as! NSObject){
                    let viewCell = ShopCell()
                    viewCell.selectionStyle = UITableViewCellSelectionStyle.None
                    viewCell.setData(self.resultArray[n].objectAtIndex(indexPath.row))
                    return viewCell
                }
            }
        }
        let defaultCell = UITableViewCell()
        return defaultCell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        for(var num = 0 ; num < self.viewCount ; num++){
            if(tableView == self.tableViewArray[num] as! NSObject){
               let shopGoodsVC = ShopGoodsVC()

               shopGoodsVC.shopID = String(self.resultArray[num].objectAtIndex(indexPath.row).objectForKey("shop_id")!)
                shopGoodsVC.shopTitleName = String(self.resultArray[num].objectAtIndex(indexPath.row).objectForKey("name")as! String)
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(shopGoodsVC, animated: true)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(scrollView == self.rootView){
            self.pageView.currentPage = Int(Float(rootView.contentOffset.x) / Float(windowWidth))
            scrollPageTurn(self.pageView.currentPage)
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView == self.rootView){
            let offset : CGPoint = scrollView.contentOffset
            self.scrollIndicator.contentOffset = CGPoint(x: -offset.x / CGFloat(self.viewCount), y: offset.y)
        }
    }
    func pageTurn(sender : UIButton){
        self.rootView.contentOffset = CGPoint(x: CGFloat(sender.tag) * windowWidth, y: 0)
        pageView.currentPage = sender.tag
        btnColorChange(sender.tag)
        self.tableViewArray[sender.tag].reloadData()
    }
    func scrollPageTurn(sender : Int){
        self.rootView.contentOffset = CGPoint(x: CGFloat(sender) * windowWidth, y: 0)
        pageView.currentPage = sender
        btnColorChange(sender)
        self.tableViewArray[sender].reloadData()
        
    }
    func btnColorChange(which : Int ){
        for(var num = 0 ; num < self.viewCount ; num++){
            if(num != which){
                self.btnArray[num].setTitleColor(UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1), forState: UIControlState.Normal)
            }
            else{
                self.btnArray[num].setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
            }
        }
    }
    //下拉刷新
    func footerRefreshing(sender : AnyObject){
        self.pageArray[sender.tag]++
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/shop/search/",headers:httpHeader,parameters:["location":"东南大学九龙湖校区","page":self.pageArray[sender.tag],"category":self.shopCategory[sender.tag].objectForKey("name")!]).responseJSON(options:NSJSONReadingOptions.MutableContainers){
            response in
            var json = JSON(response.result.value!)
            var responseJson = json["result"]
            if(responseJson.count == 0){
                self.pageArray[sender.tag]--
                (self.tableViewArray[sender.tag]as! UITableView).footer!.endRefreshing()
            }
            if(responseJson.count != 0){
                for(var num = 0 ; num < responseJson.count ; num++){
                    self.resultArray[sender.tag].addObject(responseJson.arrayObject![num])
                }
                self.tableViewArray[sender.tag].reloadData()
            }
        }
    }
    
    func headerRefreshing(sender : AnyObject){
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/shop/search/",headers:httpHeader,parameters:["location":"东南大学九龙湖校区","page":"1","category":self.shopCategory[sender.tag].objectForKey("name")!]).responseJSON(options:NSJSONReadingOptions.MutableContainers){
            response in
            var json = JSON(response.result.value!)
            var responseJson = json["result"]
            
            self.resultArray[sender.tag] = responseJson.arrayObject!
            self.tableViewArray[sender.tag].reloadData()
            (self.tableViewArray[sender.tag]as! UITableView).header!.endRefreshing()
            self.pageArray[sender.tag] = 1
        }
    }
    
}
