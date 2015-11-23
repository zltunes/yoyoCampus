//
//  ShopGoodViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/7.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class ShopGoodViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,APIDelegate{

    @IBOutlet var photoImgView: UIImageView!
    
    @IBOutlet var goodNameLabel: UILabel!
    
    @IBOutlet var roundBtn: UIButton!//tag:0

    @IBOutlet var shopNameBtn: UIButton!//tag:0
    
    @IBOutlet var originPriceLabel: UILabel!
    
    @IBOutlet var presentPriceLabel: UILabel!
    
    @IBOutlet var interestCountLabel: UILabel!
    
    @IBOutlet var soldCountLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var detailBtn: UIButton!//tag:1
    
    @IBOutlet var remarkBtn: UIButton!//tag:2
    
    @IBOutlet var horizontalScroll: UIScrollView!
    
    @IBOutlet var pageCtl: UIPageControl!
    
    @IBOutlet var tabbar: UITabBar!
    
    @IBOutlet var toBuyBtn: UIButton!//tag = 6为字体加粗
    
    @IBOutlet var collectBtn: UIButton!//tag = 4,收藏心形
    
    @IBOutlet var collectBtn_text: UIButton!//tag=4,收藏文字
    
    var commentPage:Int = 1
    
    //两种咨询方式
    var popMenu = PopMenu()
    
    ///指示器视图

    @IBOutlet var scrollIndicator: UIScrollView!
    
    ///指示器内的指示色块

    @IBOutlet var inScrollIndicator: UIView!
    
    ///详情视图

    @IBOutlet var detailView: UITableView!
    
    ///评论视图
    @IBOutlet var remarkTableView: UITableView!

    
    var app = UIApplication.sharedApplication()
    
    var api = YoYoAPI()
    
    internal var goods_ID = ""
    
    var shop_ID = ""
    
//  商品详情界面需要显示的数据
    
    var view_number = 0
    
    var sales_numeber = 0
    
    var original_price:Float = 0.00
    
    var present_price:Float = 0.00
    
    var discount:Float = 0.00//优惠卡
    
    var detailInfoJSON:JSON = []
    
    var commentsJSON:[JSON] = []
    
    var time = ""
    
    var shop_image = NSURL()
    
    var image = NSURL()
    
    var phone_num = ""//商家电话
    
    var is_collected = 0
    
//  需要访问的URL
    var goodsViewURL:String = ""//商品查看
    
    var commentsViewURL:String = ""//评论查看
    
    var commentsCreateURL:String = ""//添加评论
    
    var commentLikeURL:String = ""//商品评论赞
    
    var commentUnlikeURL:String = ""//评论取赞
    
    var collectURL:String = ""//收藏
    
    var collectCancelURL:String = ""//取消收藏

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setUpNavigaitonBar()
        self.setUpActions()
        self.setUpInitialLooking()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if(self.pageCtl.tag == 1){
        self.pageCtl.removeObserver(self, forKeyPath: "currentPage", context: nil)
        self.pageCtl.tag = 0
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigaitonBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "详情", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        Tool.showProgressHUD("")
        
        let newWidth = self.view.frame.width
        
        self.view.backgroundColor = Consts.grayView
        
        self.toBuyBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(20.0)
        
        self.roundBtn.layer.cornerRadius = self.roundBtn.frame.width/2
    
        
        //设置指示器 scrollIndicator && inScrollIndicator
        /*
        *************************************************************
        1⃣️1⃣️1⃣️1⃣️1⃣️：frame.width==contentSize.width不是相当于不能滑动吗?
        *************************************************************
        */

        self.scrollIndicator.backgroundColor = Consts.grayView
        self.scrollIndicator.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollIndicator.pagingEnabled = true
        
        //设置要显示的两个view
        //1------detailView
        self.detailView.backgroundColor = Consts.grayView
        self.detailView.showsVerticalScrollIndicator = false
        
        //2------remarkView
        self.remarkTableView.backgroundColor = Consts.grayView
        self.remarkTableView.showsVerticalScrollIndicator = false
        
        self.remarkTableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefreshing")
        self.remarkTableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefreshing")
        
        
        //设置horizontalScrollView
        self.horizontalScroll.contentSize = CGSize(width: self.horizontalScroll.frame.width * 2, height: 0)//禁止垂直滑动
        self.horizontalScroll.contentOffset = CGPoint(x: 0, y: 0)
        self.horizontalScroll.showsHorizontalScrollIndicator = false
        self.horizontalScroll.pagingEnabled = true
        
        //设置pageCtl
        self.pageCtl.pageIndicatorTintColor = UIColor.clearColor()
        self.pageCtl.currentPageIndicatorTintColor = UIColor.clearColor()
        self.pageCtl.enabled = false
        
        self.setExtraCellLineHidden(self.detailView)
        self.setExtraCellLineHidden(self.remarkTableView)
        
        setUpOnlineData("goodsView")
        setUpOnlineData("commentsView")
    }
    
    func setExtraCellLineHidden(tableView:UITableView){
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = view
    }
    
    func headerRefreshing(){
        self.commentPage = 1
        setUpOnlineData("commentsView")
    }
    
    func footerRefreshing(){
        self.commentPage++
        setUpOnlineData("commentsView")
    }
    
    func setUpActions(){
        self.api.delegate = self
        self.scrollIndicator.delegate = self
        self.horizontalScroll.delegate = self
        
        self.detailView.registerNib(UINib.init(nibName: "shopDetailCell", bundle: nil), forCellReuseIdentifier: "shopDetailCell")
        self.remarkTableView.registerNib(UINib.init(nibName: "shopRemarkCell", bundle: nil), forCellReuseIdentifier: "shopRemarkCell")
        
        //注意离开本页面的时候要removeObserver,此处使用KVO编程，为pageCtl(数据模型－－被监听对象)添加监听器（self--视图组件）,监听器要重写observerKeyForKeyPath方法
        self.pageCtl.addObserver(self, forKeyPath: "currentPage", options: .New, context: nil)
        self.pageCtl.tag = 1
    }
    
    func setUpOnlineData(tag:String){
        switch(tag){
            case "goodsView":
                self.goodsViewURL = "\(Consts.mainUrl)/v1.0/goods/\(self.goods_ID)"
                api.httpRequest("GET", url: self.goodsViewURL, params: nil, tag: "goodsView")
            break
            
            case "commentsView":
                self.commentsViewURL = "\(Consts.mainUrl)/v1.0/goods/\(self.goods_ID)/comment/\(self.commentPage)"
                api.httpRequest("GET", url: self.commentsViewURL, params: nil, tag: "commentsView")
            break
            
            case "commentLike":
                api.httpRequest("POST", url: self.commentLikeURL, params: nil, tag: "commentLike")
            break
            
            case "commentUnlike":
                api.httpRequest("DELETE", url: self.commentUnlikeURL, params: nil, tag: "commentUnlike")
            break
            
            case "collect":
                self.collectURL = "\(Consts.mainUrl)/v1.0/goods/collection/\(self.goods_ID)"
                api.httpRequest("POST", url: self.collectURL, params: nil, tag: "collect")
            break
            
            case "collectCancel":
                self.collectCancelURL = "\(Consts.mainUrl)/v1.0/goods/collection/\(self.goods_ID)"
                api.httpRequest("DELETE", url: self.collectCancelURL, params: nil, tag: "collectCancel")
            break
            
        default:
            break
            
        }
    }
    
    //滑动后按钮颜色变化
    func tabChangeTo(state:Int){
        switch (state){
        case 0://详情
            //设置动画
            UIView.beginAnimations(nil, context: nil)//开始动画
            UIView.setAnimationDuration(0.25)//持续时间
            UIView.setAnimationCurve(.EaseIn)
            self.detailBtn.setTitleColor(Consts.tintGreen, forState: .Normal)
            self.remarkBtn.setTitleColor(Consts.darkGray, forState: .Normal)
            UIView.commitAnimations()
            break
        case 1://评价
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.25)
            UIView.setAnimationCurve(.EaseIn)
            self.remarkBtn.setTitleColor(Consts.tintGreen, forState: .Normal)
            self.detailBtn.setTitleColor(Consts.darkGray, forState: .Normal)
            UIView.commitAnimations()
            break
        default:
            break
        }
    }
    
    //页面滑动后更改控制器当前页数
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView == self.horizontalScroll){
            let newWidth = self.view.frame.width
            let offset:CGPoint = scrollView.contentOffset
            /*
            *************************************************************
            2⃣️2⃣️2⃣️2⃣️2⃣️2⃣️2⃣️2⃣️：此处x是怎么算出来的？
            *************************************************************
            */
            self.scrollIndicator.contentOffset = CGPoint(x: -offset.x/2, y: offset.y)
            let temPage = Int(floor((offset.x - newWidth/2)/newWidth)+1)
            self.pageCtl.currentPage = temPage
        }
    }
    
    //为监听器self监听pageCtl.currentPage变化,并更新界面
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "currentPage"){
            self.tabChangeTo(self.pageCtl.currentPage)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(tableView == self.detailView){
            let cell = self.detailView.dequeueReusableCellWithIdentifier("shopDetailCell") as!
                shopDetailCell
            self.setUpDetailCell(cell, atIndexPath: indexPath)
            return cell
        }else{
            let cell = self.remarkTableView.dequeueReusableCellWithIdentifier("shopRemarkCell") as! shopRemarkCell
            self.setUpRemarkCell(cell, atIndexPath: indexPath)
            return cell
        }
    }
    
    func setUpDetailCell(cell:shopDetailCell,atIndexPath indexPath:NSIndexPath){
        cell.tagLabel.text = detailInfoJSON[indexPath.row,"title"].string!
        cell.tagLabel.font = UIFont.boldSystemFontOfSize(15)
        cell.tagLabel.textColor = Consts.white
        cell.tagLabel.layer.masksToBounds = true
        //detailLabel允许多行显示
        cell.detailLabel.lineBreakMode = .ByCharWrapping
        cell.detailLabel.numberOfLines = 0
        cell.detailLabel.sizeToFit()
        cell.detailLabel.text = detailInfoJSON[indexPath.row,"content"].string!
    }
    
    func setUpRemarkCell(cell:shopRemarkCell,atIndexPath indexPath:NSIndexPath){
        cell.commentID = commentsJSON[indexPath.row]["id"].string!
        cell.nameLabel.text = commentsJSON[indexPath.row]["name"].string!
        cell.timeLabel.text = commentsJSON[indexPath.row]["date"].string!
        cell.starsCount = commentsJSON[indexPath.row]["score"].int!
        cell.setStars(cell.starsCount)
        cell.remarkLabel.lineBreakMode = .ByCharWrapping
        cell.remarkLabel.numberOfLines = 0
        cell.remarkLabel.sizeToFit()
        cell.remarkLabel.text = commentsJSON[indexPath.row]["content"].string!
        cell.likeCount = commentsJSON[indexPath.row]["useful_number"].int!
        cell.likeCountLabel.text = "(\(cell.likeCount))"
        cell.photo.sd_setImageWithURL(commentsJSON[indexPath.row]["image"].URL!, placeholderImage: UIImage.init(named: "bear_icon_register"))
        cell.hasLike = commentsJSON[indexPath.row]["useful_clicked"].int!
        if(cell.hasLike == 1){
            cell.likeBtn.setBackgroundImage(UIImage.init(named: "xianzhi_icon_like"), forState: .Normal)
            cell.likeBtn.removeTarget(self, action: "remark_likeBtnClicked:", forControlEvents: .TouchUpInside)
            cell.likeBtn.addTarget(self, action: "remark_unlikeBtnClicked:", forControlEvents: .TouchUpInside)
            
        }else{
            cell.likeBtn.setBackgroundImage(UIImage.init(named: "unlike"), forState: .Normal)
            cell.likeBtn.removeTarget(self, action: "remark_unlikeBtnClicked:", forControlEvents: .TouchUpInside)
            cell.likeBtn.addTarget(self, action: "remark_likeBtnClicked:", forControlEvents: .TouchUpInside)
        }
        cell.likeBtn.tag = indexPath.row
    }
    
    
    
    //    评论点赞
    func remark_likeBtnClicked(sender:UIButton){
        if(AppDelegate.isLogin == true){
        let indexpath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = self.remarkTableView.cellForRowAtIndexPath(indexpath) as! shopRemarkCell
        self.commentLikeURL = "\(Consts.mainUrl)/v1.0/goods/\(self.goods_ID)/comment/\(cell.commentID)/useful/"
        commentsJSON[sender.tag]["useful_clicked"] = 1
        commentsJSON[sender.tag]["useful_number"].int!++
        setUpOnlineData("commentLike")
        }else{
            Tool.showErrorHUD("请先登录!")
        }
    }
    
    //     评论取消点赞
    func remark_unlikeBtnClicked(sender:UIButton){
        if(AppDelegate.isLogin == true){
        let indexpath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = self.remarkTableView.cellForRowAtIndexPath(indexpath) as! shopRemarkCell
        self.commentUnlikeURL = "\(Consts.mainUrl)/v1.0/goods/\(self.goods_ID)/comment/\(cell.commentID)/useful/"
        commentsJSON[sender.tag]["useful_clicked"] = 0
        commentsJSON[sender.tag]["useful_number"].int!--
        setUpOnlineData("commentUnlike")
        }else{
            Tool.showErrorHUD("请先登录!")
        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.detailView){
            return detailInfoJSON.count
        }else{
            return commentsJSON.count
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == self.detailView){
            self.detailView.deselectRowAtIndexPath(indexPath, animated: true)
        }else if(tableView == self.remarkTableView){
            self.remarkTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView == self.detailView){
            return tableView.fd_heightForCellWithIdentifier("shopDetailCell", cacheByIndexPath: indexPath, configuration: { (cell) -> Void in
                self.setUpDetailCell(cell as! shopDetailCell, atIndexPath: indexPath)
            })
        }else{
            return tableView.fd_heightForCellWithIdentifier("shopRemarkCell", cacheByIndexPath: indexPath, configuration: { (cell) -> Void in
                self.setUpRemarkCell(cell as! shopRemarkCell, atIndexPath: indexPath)
            })
        }
    }
    
    @IBAction func btnClicked(sender: UIButton) {
        switch(sender.tag){
        case 0://进入店铺
            let vc = ShopGoodsVC()
            vc.shopID = self.shop_ID
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1://详情
            self.horizontalScroll.contentOffset = CGPoint(x: 0, y: 0)
            break
        case 2://评论
            self.horizontalScroll.contentOffset = CGPoint(x: self.horizontalScroll.frame.width, y: 0)
            break
        case 3://店铺
            let vc = ShopGoodsVC()
            vc.shopID = self.shop_ID
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4://收藏
            if(AppDelegate.isLogin == true){
            setUpOnlineData("collect")
            }else{
                Tool.showErrorHUD("请先登录!")
            }
            break
        case 5://咨询
            self.showMenu()
            break
        case 6://去下单
            if(AppDelegate.isLogin == false){
                Tool.showErrorHUD("请先登录!")
            }else{
                let vc = ConfirmOrderVC()
                vc.goodName = self.goodNameLabel.text!
                vc.oldPrice = self.present_price
                vc.quantity = 1
                vc.discount = self.discount
                vc.goodID = self.goods_ID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case 10://取消收藏
            setUpOnlineData("collectCancel")
            break
        default:
            break
        }
    }

    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func Share(){
            
    }
    
    //咨询跳出两个选择
    func showMenu(){
        //注意空数组的定义.MenuItem为元素类型
        var items = [MenuItem]()
        var menuItem = MenuItem(title: "sms", iconName: "xiangqing_btn_message")//短信
        items.append(menuItem)
        menuItem = MenuItem(title: "tel", iconName: "xiangqing_btn_call")//电话
        items.append(menuItem)
        
        popMenu = PopMenu(frame: self.view.bounds, items: items)
        popMenu.menuAnimationType = PopMenuAnimationType.NetEase
        
        if(popMenu.isShowed == true){
            return
        }
        
        popMenu.didSelectedItemCompletion = { (selectedItem) in
            //点击事件
            if(selectedItem.title == "sms"){
                self.app.openURL(NSURL(string: "sms:\(self.phone_num)")!)
            }else if(selectedItem.title == "tel"){
                self.self.webViewCallPhone()
            }
        };
        
        popMenu.showMenuAtView(self.view)
    }
    
    func webViewCallPhone(){
        let callWebview = UIWebView()
        let teleURL = NSURL(string: "tel:\(self.phone_num)")
        callWebview.loadRequest(NSURLRequest(URL: teleURL!))
        //        将uiwebview添加到view
        self.view.addSubview(callWebview)
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        switch(tag){
            case "goodsView":
                self.shop_ID = json["shop_id"].string!
                self.image = json["image"].URL!
                self.shop_image = json["shop_image"].URL!
                self.is_collected = json["is_collected"].int!
                if(self.is_collected == 1){
                    self.collectBtn.setBackgroundImage(UIImage(named: "xiangqing_tab bar_collect_p"), forState: .Normal)
                    self.collectBtn.tag = 10
                    self.collectBtn_text.tag = 10
                }else{
                    self.collectBtn.setBackgroundImage(UIImage(named: "xiangqing_tab bar_collect_n"), forState: .Normal)
                    self.collectBtn.tag = 4
                    self.collectBtn_text.tag = 4
                }
                self.photoImgView.sd_setImageWithURL(self.image, placeholderImage: UIImage.init(named: "Commodity editor_btn_picture"))
                self.roundBtn.setBackgroundImage(UIImage(data: NSData(contentsOfURL: self.image)!), forState: .Normal)
                
                self.goodNameLabel.text = json["name"].string!
                self.shopNameBtn.setTitle(json["shop_name"].string!, forState: .Normal)
                let original_price_cent = json["original_price"].int!
                self.original_price = Float(original_price_cent)/100.00
                
                let attributedText = NSAttributedString(string: "¥ \(self.original_price)", attributes: [NSStrikethroughStyleAttributeName: 1])//0表示不显示删除线，1表示显示删除线
                self.originPriceLabel.attributedText = attributedText
            
                let price_cent = json["price"].int!
                self.present_price = Float(price_cent)/100.00
                self.presentPriceLabel.text = "¥ \(self.present_price)"
                
                let discount_cent = json["discount"].int!
                self.discount = Float(discount_cent)/100.00
                
                self.view_number = json["view_number"].int!
                self.interestCountLabel.text = "\(self.view_number) 人感兴趣"
                self.sales_numeber = json["sales_number"].int!
                self.soldCountLabel.text = "\(self.sales_numeber) 人已购买"
                
                self.timeLabel.text = json["last_update"].string!
                
                self.detailInfoJSON = json["description"]
                
                self.phone_num = json["phone_num"].string!

                self.detailView.reloadData()
                
            break
            
            case "commentsView":
                if(json["goods_comment"].count == 0 && self.commentPage > 1){
                    self.remarkTableView.footer.endRefreshingWithNoMoreData()
                    self.commentPage--
                }else if(json["goods_comment"].count > 0 && self.commentPage > 1){
                    self.commentsJSON += json["goods_comment"].array!
                }else if(self.commentPage == 1){
                    self.commentsJSON = json["goods_comment"].array!
                }
                self.remarkTableView.header.endRefreshing()
                self.remarkTableView.footer.endRefreshing()
                self.remarkTableView.reloadData()
                Tool.dismissHUD()
            break
            
            case "commentLike":
                self.remarkTableView.reloadData()
            break
            
            case "commentUnlike":
                self.remarkTableView.reloadData()
            break
            
            case "collect":
                self.collectBtn.setBackgroundImage(UIImage(named: "xiangqing_tab bar_collect_p"), forState: .Normal)
                self.collectBtn.tag = 10
                self.collectBtn_text.tag = 10
            break
            
            case "collectCancel":
                self.collectBtn.setBackgroundImage(UIImage(named: "xiangqing_tab bar_collect_n"), forState: .Normal)
                self.collectBtn.tag = 4
                self.collectBtn_text.tag = 4
            break
            
        default:
                break
        }
    }

}
