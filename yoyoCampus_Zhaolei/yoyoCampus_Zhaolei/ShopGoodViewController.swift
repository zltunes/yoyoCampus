//
//  ShopGoodViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/7.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

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
    
    
    //两种咨询方式
    var popMenu = PopMenu()
    
    ///指示器视图
    var scrollIndicator = UIScrollView()
    
    ///指示器内的指示色块
    var inScrollIndicator = UIView()
    
    ///详情视图
    var detailView = UITableView()
    
    ///评论视图
    var remarkTableView = UITableView()
    
    var app = UIApplication.sharedApplication()
    
    var api = YoYoAPI()
    
    internal var goods_ID = "5634643890c49054c483f8eb"
    
    var shop_ID = ""
    
//  商品详情界面需要显示的数据
    
    var view_number = 0
    
    var sales_numeber = 0
    
    var original_price = 0
    
    var price = 0
    
    var detailInfoJSON:JSON = []
    
    var commentsJSON:JSON = []
    
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
        self.setUpNavigaitonBar()
        self.setUpActions()
        self.setUpInitialLooking()
        
        // Do any additional setup after loading the view.
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
        
        setUpOnlineData("goodsView")
        
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
        self.scrollIndicator.frame = CGRect(x: 0, y: self.detailBtn.frame.maxY+1, width: newWidth, height: 2.8)
        self.scrollIndicator.backgroundColor = Consts.grayView
        self.scrollIndicator.contentSize = CGSize(width: newWidth, height: 0)//height=0表明禁止垂直滑动
        self.scrollIndicator.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollIndicator.pagingEnabled = true
        
        self.inScrollIndicator.frame = CGRect(x: self.detailBtn.frame.width/2.5, y: 0, width: self.detailBtn.frame.width/3, height: 2.8)
        self.inScrollIndicator.backgroundColor = Consts.tintGreen
        
        self.scrollIndicator.addSubview(self.inScrollIndicator)
        self.view.addSubview(self.scrollIndicator)
        
        //设置要显示的两个view
        //1------detailView
        self.detailView.frame = CGRect(x:0,y:0, width:self.horizontalScroll.frame.width, height: self.horizontalScroll.frame.height)
        self.detailView.backgroundColor = Consts.grayView
        self.detailView.showsVerticalScrollIndicator = false
        
        //2------remarkView
        self.remarkTableView.frame = CGRect(x:self.horizontalScroll.frame.width, y: 0, width: self.horizontalScroll.frame.width, height: self.horizontalScroll.frame.height)
        self.remarkTableView.backgroundColor = Consts.grayView
        self.remarkTableView.showsVerticalScrollIndicator = false
        
        self.horizontalScroll.addSubview(self.detailView)
        self.horizontalScroll.addSubview(self.remarkTableView)
        
        //设置horizontalScrollView
        self.horizontalScroll.contentSize = CGSize(width: self.horizontalScroll.frame.width * 2, height: 0)//禁止垂直滑动
        self.horizontalScroll.contentOffset = CGPoint(x: 0, y: 0)
        self.horizontalScroll.showsHorizontalScrollIndicator = false
        self.horizontalScroll.pagingEnabled = true
        
        //设置pageCtl
        self.pageCtl.pageIndicatorTintColor = UIColor.clearColor()
        self.pageCtl.currentPageIndicatorTintColor = UIColor.clearColor()
        self.pageCtl.enabled = false
        
        
    }
    
    func setUpActions(){
        self.api.delegate = self
        self.scrollIndicator.delegate = self
        self.horizontalScroll.delegate = self
        
        self.detailView.delegate = self
        self.detailView.dataSource = self
        self.detailView.registerNib(UINib.init(nibName: "shopDetailCell", bundle: nil), forCellReuseIdentifier: "shopDetailCell")
        self.remarkTableView.delegate = self
        self.remarkTableView.dataSource = self
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
            cell.tagLabel.text = "报名须知"
            //detailLabel允许多行显示
            cell.detailLabel.lineBreakMode = .ByCharWrapping
            cell.detailLabel.numberOfLines = 0
            cell.detailLabel.sizeToFit()
            cell.detailLabel.text = "报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知报名须知。"
            return cell
        }else{
            let cell = self.remarkTableView.dequeueReusableCellWithIdentifier("shopRemarkCell") as! shopRemarkCell
            cell.nameLabel.text = "宇宙无敌小可爱"
            cell.timeLabel.text = "2016-01-19"
            cell.remarkLabel.lineBreakMode = .ByCharWrapping
            cell.remarkLabel.numberOfLines = 0
            cell.remarkLabel.sizeToFit()
            cell.remarkLabel.text = "很不错的地方很不错的地方很不错的地方很不错的地方很不错的地方很不错的地方很不错的地方。"
            cell.likeCountLabel.text = "(15)"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.detailView){
            return 2
        }else{
            return 3
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
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        return cell.frame.height
    }
    
    @IBAction func btnClicked(sender: UIButton) {
        switch(sender.tag){
        case 0://新东方
            break
        case 1://详情
            self.horizontalScroll.contentOffset = CGPoint(x: 0, y: 0)
            break
        case 2://评论
            self.horizontalScroll.contentOffset = CGPoint(x: self.horizontalScroll.frame.width, y: 0)
            break
        case 3://店铺
            break
        case 4://收藏
            self.collectBtn.setImage(UIImage(named: "xiangqing_tab bar_collect_p"), forState: .Normal)
            self.collectBtn.tag = 10//变为“已收藏”状态
            self.collectBtn_text.tag = 10
            break
        case 5://咨询
            self.showMenu()
            break
        case 6://去下单
            let vc = ConfirmOrderVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 10://取消收藏
            self.collectBtn.setImage(UIImage(named: "xiangqing_tab bar_collect_n"), forState: .Normal)
            self.collectBtn.tag = 4//变为“未收藏”状态
            self.collectBtn_text.tag = 4
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
            }else{
                self.self.webViewCallPhone()
            }
        };
        
        popMenu.showMenuAtView(self.view)
    }
    
    func webViewCallPhone(){
        let webview = UIWebView()
        webview.loadRequest(NSURLRequest(URL: NSURL(string: "tel:\(self.phone_num)")!))
        self.view.addSubview(webview)
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        switch(tag){
            case "goodsView":
                self.image = json["image"].URL!
                self.shop_image = json["shop_image"].URL!
                self.photoImgView.sd_setImageWithURL(self.image, placeholderImage: UIImage.init(named: "Commodity editor_btn_picture"))
                self.roundBtn.sd_setImageWithURL(self.shop_image, forState: .Normal)
                
                self.goodNameLabel.text = json["name"].string!
                self.shopNameBtn.setTitle(json["shop_name"].string!, forState: .Normal)
                self.original_price = json["original_price"].int!
                
                let attributedText = NSAttributedString(string: "¥ \(self.original_price)", attributes: [NSStrikethroughStyleAttributeName: 1])//0表示不显示删除线，1表示显示删除线
                self.originPriceLabel.attributedText = attributedText
            
                self.price = json["price"].int!
                self.presentPriceLabel.text = "¥ \(self.price)"
                
                self.view_number = json["view_number"].injit!
                self.interestCountLabel.text = "\(self.view_number) 人感兴趣"
                self.sales_numeber = json["sales_number"].int!
                self.soldCountLabel.text = "\(self.sales_numeber) 人已购买"
                
                self.timeLabel.text = json["last_update"].string!
                
            break
            
        default:
                break
        }
    }

}
