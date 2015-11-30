//
//  MyIdleVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 浩然 on 15/11/17.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

class MyIdleVC: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    var resultOnArray = NSMutableArray()
    var resultOffArray = NSMutableArray()
    var btnOn = UIButton()
    var btnOff = UIButton()
    var rootView = UIScrollView()
    var pageView = UIPageControl()
    var scrollIndicator = UIScrollView()
    var tableViewOn = UITableView()
    var tableViewOff = UITableView()
    
    var view1 = UIView()
    var view2 = UIView()
    
    var pageOn = 1
    var pageOff = 1
    
    var didReceiveData = false
    
    override func viewWillAppear(animated: Bool) {
        self.scrollIndicator.contentOffset.x = -(CGFloat(self.pageView.currentPage) * windowWidth/2)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 235/255, green: 234/255, blue: 234/255, alpha: 1)
        Consts.setUpNavigationBarWithBackButton(self,title: "我的闲置", backTitle: "<")
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
        scrollRootVC.contentSize = CGSizeMake(windowWidth*2, windowHeight-100)
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
        
        
        
        let btnOn = UIButton(frame: CGRectMake(0, 0, windowWidth/2, 40))
        btnOn.tag = 0
        btnOn.setTitle("上架中", forState: UIControlState.Normal)
        btnOn.addTarget(self, action: Selector("pageTurn:"), forControlEvents: UIControlEvents.TouchUpInside)
        btnOn.backgroundColor = UIColor.whiteColor()
        btnOn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnOn.titleLabel?.font = UIFont(name: "Verdana", size: 13)
        self.view.addSubview(btnOn)
        self.btnOn = btnOn
        
        let btnOff = UIButton(frame: CGRectMake(windowWidth/2, 0, windowWidth/2, 40))
        btnOff.tag = 1
        btnOff.setTitle("已下架", forState: UIControlState.Normal)
        btnOff.addTarget(self, action: Selector("pageTurn:"), forControlEvents: UIControlEvents.TouchUpInside)
        btnOff.backgroundColor = UIColor.whiteColor()
        btnOff.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btnOff.titleLabel?.font = UIFont(name: "Verdana", size: 13)
        self.view.addSubview(btnOff)
        self.btnOff = btnOff
        
        let view1 = UIView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
        self.rootView.addSubview(view1)
        self.view1 = view1
        
        let view2 = UIView(frame: CGRectMake(windowWidth, 0, windowWidth, windowHeight))
        self.rootView.addSubview(view2)
        self.view2 = view2
        
        var tableViewOn = UITableView(frame: CGRectMake(0, 45, windowWidth, windowHeight))
        view1.addSubview(tableViewOn)
        self.setExtralCellLinesHidden(tableViewOn)
        tableViewOn.rowHeight = windowHeight/5
        tableViewOn.delegate = self
        tableViewOn.dataSource = self
        tableViewOn.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("headerRefreshing:"))
        tableViewOn.mj_header.tag = 0
        tableViewOn.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("footerRefreshing:"))
        tableViewOn.mj_footer.tag = 0
        self.tableViewOn = tableViewOn
        
        var tableViewOff = UITableView(frame: CGRectMake(0, 45, windowWidth, windowHeight))
        self.setExtralCellLinesHidden(tableViewOff)
        tableViewOff.rowHeight = windowHeight/5
        tableViewOff.dataSource = self
        tableViewOff.delegate = self
        tableViewOff.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("headerRefreshing:"))
        tableViewOff.mj_header.tag = 1
        tableViewOff.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("footerRefreshing:"))
        tableViewOff.mj_footer.tag = 1
        view2.addSubview(tableViewOff)
        self.tableViewOff = tableViewOff
        
        
    }
    func httpGetData(){
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/idle/list/",headers:httpHeader,parameters:["page":"1","is_active":"1"]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
            response in
            let json = JSON(response.result.value!)
            var responseJson = json["idle"]

            self.resultOnArray = NSMutableArray(array: responseJson.arrayObject!)
            self.GetOffData()
        }
    }
    
    func GetOffData(){
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/idle/list/",headers:httpHeader,parameters:["page":"1","is_active":"0"]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
            response in
            let json = JSON(response.result.value!)
            var responseJson = json["idle"]
            self.resultOffArray = NSMutableArray(array: responseJson.arrayObject!)
            self.didReceiveData = true
            self.setAllView()
            self.btnColorChange(0)
            self.tableViewOn.reloadData()
            self.tableViewOff.reloadData()
        }
    }
    
    func setExtralCellLinesHidden(tableView:UITableView){
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(self.didReceiveData == false){
            let defaultCell = UITableViewCell()
            return defaultCell
        }
        if(self.didReceiveData == true){
            if(tableView == self.tableViewOn){
                var cell = MyIdleCell()
                cell.isActive = true
                cell.setCellData(self.resultOnArray[indexPath.row])
                cell.belongedVC = self
                cell.cellIndex = indexPath.row
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
            if(tableView == self.tableViewOff){
                var cell = MyIdleCell()
                cell.isActive = false
                cell.setCellData(self.resultOffArray[indexPath.row])
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.belongedVC = self
                cell.cellIndex = indexPath.row
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
            if(tableView == self.tableViewOn){
                return self.resultOnArray.count
            }
            if(tableView == self.tableViewOff){
                return self.resultOffArray.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tempCell = tableView.cellForRowAtIndexPath(indexPath)as! MyIdleCell
        let vc = IdleGoodViewController()
        vc.idle_id = tempCell.idleID
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
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
        self.rootView.contentOffset = CGPoint(x: CGFloat(sender.tag) * windowWidth, y: 0)
        if(sender.tag == 0){
            self.tableViewOn.reloadData()
            self.btnColorChange(0)
        }
        if(sender.tag == 1){
            self.tableViewOff.reloadData()
            self.btnColorChange(1)
        }
    }
    func pageNumTurn(sender : Int){
        self.pageView.currentPage = sender
        self.rootView.contentOffset = CGPoint(x: CGFloat(sender) * windowWidth, y: 0)
        self.btnColorChange(sender)
    }
    func scrollPageTurn(sender : Int){
        if(sender == 0){
            self.tableViewOn.reloadData()
            self.btnColorChange(0)
        }
        if(sender == 1){
            self.tableViewOff.reloadData()
            self.btnColorChange(1)
        }
    }
    func btnColorChange(sender : Int){
        if(sender == 0){
            self.btnOn.setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
            self.btnOff.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }
        if(sender == 1){
            self.btnOff.setTitleColor(UIColor(red: 73/255, green: 185/255, blue: 162/255, alpha: 1), forState: UIControlState.Normal)
            self.btnOn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }
    }
    
    func headerRefreshing(sender : AnyObject){
        if(sender.tag == 0){
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/idle/list/",headers:httpHeader,parameters:["page":"1","is_active":"1"]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["idle"]
                self.resultOnArray = NSMutableArray(array: responseJson.arrayObject!)
                self.tableViewOn.reloadData()
                self.tableViewOn.mj_header!.endRefreshing()
            }
        }
        if(sender.tag == 1){
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/idle/list/",headers:httpHeader,parameters:["page":"1","is_active":"0"]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["idle"]
                self.resultOffArray = NSMutableArray(array: responseJson.arrayObject!)
                self.tableViewOff.reloadData()
                self.tableViewOff.mj_header.endRefreshing()
            }
        }
    }
    
    func footerRefreshing(sender : AnyObject){
        if(sender.tag == 0){
            self.pageOn++
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/idle/list/",headers:httpHeader,parameters:["page":self.pageOn,"is_active":"1"]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["idle"]
                if(responseJson.count == 0){
                    self.pageOn--
                    self.tableViewOn.mj_footer!.endRefreshing()
                }
                if(responseJson.count != 0 ){
                    for(var num = 0 ; num < responseJson.count ; num++){
                        self.resultOnArray.addObject(responseJson.arrayObject![num])
                    }
                    self.tableViewOn.reloadData()
                    self.tableViewOn.mj_footer!.endRefreshing()
                }
            }
        }
        if(sender.tag == 1){
            self.pageOff++
            Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/idle/list/",headers:httpHeader,parameters:["page":self.pageOff,"is_active":"0"]).responseJSON(options: NSJSONReadingOptions.MutableContainers){
                response in
                let json = JSON(response.result.value!)
                var responseJson = json["idle"]
                
                if(responseJson.count == 0){
                    self.pageOff--
                    self.tableViewOff.mj_footer!.endRefreshing()
                }
                if(responseJson.count != 0){
                    for(var num = 0 ; num < responseJson.count ; num++){
                        self.resultOffArray.addObject(responseJson.arrayObject![num])
                    }
                    self.tableViewOff.reloadData()
                    self.tableViewOff.mj_footer!.endRefreshing()
                }
        
            }
        }
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
