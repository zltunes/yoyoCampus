//
//  MyFavoriteVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 浩然 on 15/11/17.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

class MyFavoriteVC: UIViewController,UIScrollViewDelegate ,UITableViewDataSource,UITableViewDelegate{
    
    var resultGoodsArray = NSMutableArray()
    var resultShopArray = NSMutableArray()
    var btnGoods = UIButton()
    var btnShop = UIButton()
    var rootView = UIScrollView()
    var pageView = UIPageControl()
    var scrollIndicator = UIScrollView()
    var tableViewGoods = UITableView()
    var tableViewShop = UITableView()
    
    var view1 = UIView()
    var view2 = UIView()
    
    var pageGoods = 1
    var pageShop = 1
    
    var didReceiveData = false

    override func viewWillAppear(animated: Bool) {
        if(self.pageView.currentPage == 0){
            self.pageTurn(self.btnGoods)
        }
        if(self.pageView.currentPage == 1){
            self.pageTurn(self.btnShop)
        }
        self.scrollIndicator.contentOffset.x = -(CGFloat(self.pageView.currentPage) * windowWidth/2)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 235/255, green: 234/255, blue: 234/255, alpha: 1)
        Consts.setUpNavigationBarWithBackButton(self,title: "我的收藏", backTitle: "<")
        self.httpGetData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func setAllView(){
        
        let scrollRootVC = UIScrollView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
        scrollRootVC.delegate = self
        scrollRootVC.directionalLockEnabled = true
        scrollRootVC.showsHorizontalScrollIndicator = false
        scrollRootVC.showsVerticalScrollIndicator = false
        scrollRootVC.contentSize = CGSizeMake(windowWidth, windowHeight-100)
        scrollRootVC.pagingEnabled = true
        self.rootView = scrollRootVC
        self.view.addSubview(scrollRootVC)
        
        let pageCtl = UIPageControl(frame: CGRectMake(100, windowHeight-50, 50, 20))
        pageCtl.numberOfPages = 2
        pageCtl.currentPage = 0
        self.pageView = pageCtl
        self.view .addSubview(pageCtl)
        
        
        let scrollIndicator = UIScrollView()
        let indicatorView = UIView()
        scrollIndicator.frame = CGRectMake(60, 40, windowWidth-100, 3)
        scrollIndicator.contentSize = CGSize(width: windowWidth-160, height: 3)
        indicatorView.frame = CGRect(x: 0, y: 0, width: 80, height: 3)
        indicatorView.backgroundColor = UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1)
        scrollIndicator.addSubview(indicatorView)
        self.view.addSubview(scrollIndicator)
        self.scrollIndicator = scrollIndicator
        
        
        
        let btnGoods = UIButton(frame: CGRectMake(0, 0, windowWidth/2, 40))
        btnGoods.tag = 0
        btnGoods.setTitle("商品", forState: UIControlState.Normal)
        btnGoods.addTarget(self, action: Selector("pageTurn:"), forControlEvents: UIControlEvents.TouchUpInside)
        btnGoods.backgroundColor = UIColor.whiteColor()
        btnGoods.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnGoods.titleLabel?.font = UIFont(name: "Verdana", size: 13)
        self.view.addSubview(btnGoods)
        self.btnGoods = btnGoods
        
        let btnShop = UIButton(frame: CGRectMake(windowWidth/2, 0, windowWidth/2, 40))
        btnShop.tag = 1
        btnShop.setTitle("商家", forState: UIControlState.Normal)
        btnShop.addTarget(self, action: Selector("pageTurn:"), forControlEvents: UIControlEvents.TouchUpInside)
        btnShop.backgroundColor = UIColor.whiteColor()
        btnShop.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnShop.titleLabel?.font = UIFont(name: "Verdana", size: 13)
        self.view.addSubview(btnShop)
        self.btnShop = btnShop
        
        let view1 = UIView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
        self.rootView.addSubview(view1)
        self.view1 = view1
        
        let view2 = UIView(frame: CGRectMake(windowWidth, 0, windowWidth, windowHeight))
        self.rootView.addSubview(view2)
        self.view2 = view2
        
        var tableViewGoods = UITableView(frame: CGRectMake(0, 45, windowWidth, windowHeight))
        view1.addSubview(tableViewGoods)
        tableViewGoods.rowHeight = windowHeight/5
        tableViewGoods.delegate = self
        tableViewGoods.dataSource = self
        tableViewGoods.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("headerRefreshing:"))
        tableViewGoods.header.tag = 0
        tableViewGoods.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("footerRefreshing:"))
        tableViewGoods.footer.tag = 0
        self.tableViewGoods = tableViewGoods
        
        var tableViewShop = UITableView(frame: CGRectMake(0, 45, windowWidth, windowHeight))
        tableViewShop.rowHeight = windowHeight/5
        tableViewShop.dataSource = self
        tableViewShop.delegate = self
        tableViewShop.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("headerRefreshing:"))
        tableViewShop.header.tag = 1
        tableViewShop.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("footerRefreshing:"))
        tableViewShop.footer.tag = 1
        view2.addSubview(tableViewShop)
        self.tableViewShop = tableViewShop
    }
    
    func httpGetData(){
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/goods/collection/1",headers:httpHeader).responseJSON(options: NSJSONReadingOptions.MutableContainers){
            response in
            let json = JSON(response.result.value!)
            var responseJson = json["collection"]
            self.resultGoodsArray = NSMutableArray(array: responseJson.arrayObject!)
            self.GetOffData()
        }
    }
    
    func GetOffData(){
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/shop/collection/1",headers:httpHeader).responseJSON(options: NSJSONReadingOptions.MutableContainers){
            response in
            let json = JSON(response.result.value!)
            var responseJson = json["collection"]
            self.resultShopArray = NSMutableArray(array: responseJson.arrayObject!)
            self.didReceiveData = true
            self.setAllView()
            self.btnColorChange(0)
            self.tableViewGoods.reloadData()
            self.tableViewShop.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(self.didReceiveData == false){
            let defaultCell = UITableViewCell()
            return defaultCell
        }
        if(self.didReceiveData == true){
            if(tableView == self.tableViewGoods){
                var cell = ViewCell()
                cell.isIdleCell = false
                cell.setData(self.resultGoodsArray[indexPath.row])
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
            if(tableView == self.tableViewShop){
                var cell = ShopCell()
                cell.setData(self.resultShopArray[indexPath.row])
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
        }
        let defaultCell = UITableViewCell()
        return defaultCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.didReceiveData == false){
            return 0
        }
        if(self.didReceiveData == true){
            if(tableView == self.tableViewGoods){
                return self.resultGoodsArray.count
            }
            if(tableView == self.tableViewShop){
                return self.resultShopArray.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        print("1")
        if(tableView == self.tableViewGoods){
            let tempCell = tableView.cellForRowAtIndexPath(indexPath)as! ViewCell
            let goodsId : String = tempCell.dataCell.objectForKey("goods_id")as! String
            Alamofire.request(.DELETE, "http://api2.hloli.me:9001/v1.0/goods/collection/" + goodsId,headers:httpHeader).responseJSON(){
                response in
                self.resultGoodsArray.removeObjectAtIndex(indexPath.row)
                self.tableViewGoods.reloadData()
            }
        }
        if(tableView == self.tableViewShop){
            let tempCell = tableView.cellForRowAtIndexPath(indexPath)as! ShopCell
            let shopId : String = tempCell.shopId
            Alamofire.request(.DELETE, "http://api2.hloli.me:9001/v1.0/shop/collection/" + shopId,headers:httpHeader).responseJSON(){
                response in
                self.resultShopArray.removeObjectAtIndex(indexPath.row)
                self.tableViewShop.reloadData()
            }
        }
        
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.tableViewGoods){
            let tempCell = tableView.cellForRowAtIndexPath(indexPath)as! ViewCell
            let vc = ShopGoodViewController()
            vc.goods_ID = tempCell.dataCell.objectForKey("goods_id")as!String
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if(tableView == self.tableViewShop){
            let tempCell = tableView.cellForRowAtIndexPath(indexPath)as! ShopCell
            let vc = ShopGoodsVC()
            vc.shopID = tempCell.shopId
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView == self.rootView){
            let offset : CGPoint = scrollView.contentOffset
            self.scrollIndicator.contentOffset = CGPoint(x: -offset.x / 2, y: offset.y)
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(scrollView == self.rootView){
            self.pageView.currentPage = Int(scrollView.contentOffset.x / windowWidth)
            self.scrollPageTurn(self.pageView.currentPage)
        }
    }
    
    func pageTurn(sender : UIButton){
        self.pageView.currentPage = sender.tag
        self.rootView.setContentOffset(CGPoint(x: CGFloat(sender.tag) * windowWidth, y: 0), animated: true)
        if(sender.tag == 0){
            self.tableViewGoods.reloadData()
            self.btnColorChange(0)
        }
        if(sender.tag == 1){
            self.tableViewShop.reloadData()
            self.btnColorChange(1)
        }
    }
    func scrollPageTurn(sender : Int){
        if(sender == 0){
            self.tableViewGoods.reloadData()
            self.btnColorChange(0)
        }
        if(sender == 1){
            self.tableViewShop.reloadData()
            self.btnColorChange(1)
        }
    }
    func btnColorChange(sender : Int){
        if(sender == 0){
            self.btnGoods.setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
            self.btnShop.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }
        if(sender == 1){
            self.btnShop.setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
            self.btnGoods.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }
    }
    
    func headerRefreshing(sender : AnyObject){
        if(sender.tag == 0){
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/goods/collection/1",headers:httpHeader).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["collection"]
                self.resultGoodsArray = NSMutableArray(array: responseJson.arrayObject!)
                self.tableViewGoods.reloadData()
                self.tableViewGoods.header!.endRefreshing()
            }
        }
        if(sender.tag == 1){
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/shop/collection/1",headers:httpHeader).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["collection"]
                self.resultShopArray = NSMutableArray(array: responseJson.arrayObject!)
                self.tableViewShop.reloadData()
                self.tableViewShop.header!.endRefreshing()
            }
        }
    }
    
    func footerRefreshing(sender : AnyObject){
        if(sender.tag == 0){
            self.pageGoods++
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/goods/collection/" + String(self.pageGoods),headers:httpHeader).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["collection"]
                if(responseJson.count == 0){
                    self.pageGoods--
                    self.tableViewGoods.footer!.endRefreshing()
                }
                if(responseJson.count != 0 ){
                    for(var num = 0 ; num < responseJson.count ; num++){
                        self.resultGoodsArray.addObject(responseJson.arrayObject![num])
                    }
                    self.tableViewGoods.reloadData()
                    self.tableViewGoods.footer!.endRefreshing()
                }
            }
        }
        if(sender.tag == 1){
            self.pageShop++
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/shop/collection/" + String(self.pageShop),headers:httpHeader).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["collection"]
                if(responseJson.count == 0){
                    self.pageShop--
                    self.tableViewShop.footer!.endRefreshing()
                }
                if(responseJson.count != 0){
                    for(var num = 0 ; num < responseJson.count ; num++){
                        self.resultShopArray.addObject(responseJson.arrayObject![num])
                    }
                    self.tableViewShop.reloadData()
                    self.tableViewShop.footer!.endRefreshing()
                }
            }
        }
    }
    
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }

}
