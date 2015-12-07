//
//  IdleGoodViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/9/28.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class IdleGoodViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,APIDelegate{

    @IBOutlet var bigImgView: UIImageView!
    
    @IBOutlet var praiseBtn: UIButton!//tag:0   图片点赞按钮

    @IBOutlet var goodNameLabel: UILabel!
    
    @IBOutlet var roundBtn: UIButton!//tag:1

    @IBOutlet var shopNameBtn: UIButton!//tag:1
    
    @IBOutlet var presentPriceLabel: UILabel!
    
    @IBOutlet var previewCountLabel: UILabel!
    
    @IBOutlet var praiseCountLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var detailBtn: UIButton!//tag:2
    
    @IBOutlet var remarkBtn: UIButton!//tag:3
    
    ///水平滑动
    @IBOutlet var horizontalScroll: UIScrollView!
    
    @IBOutlet var collectBtn_img: UIButton!//tag:4

    @IBOutlet var collectBtn_text: UIButton!//tag:4

    @IBOutlet var consultBtn_img: UIButton!//tag:5
    
    @IBOutlet var consultBtn_text: UIButton!//tag:5
    
    //打电话发短信
    var app = UIApplication.sharedApplication()
    
    //咨询电话
    var consultPhoneNum:String = ""
    
    //两种咨询方式
    var popMenu = PopMenu()

    ///指示器视图
//    var scrollIndicator = UIScrollView()
    
    @IBOutlet var scrollIndicator: UIScrollView!
    
    ///指示器内的指示色块

    @IBOutlet var inScrollIndicator: UIView!

    @IBOutlet var remarkTableView: UITableView!
    
    ///详情视图

    @IBOutlet var detailView: UITextView!
    
    @IBOutlet var remarkTextView: UITextView!

    
    //左侧底部
    @IBOutlet var bottomView: UIView!
    //右侧底部

    @IBOutlet var rightBottomView: UIView!

    @IBOutlet var repostRemarkBtn: UIButton!//tag:6
    
    //页控制器
    var pageCtl = UIPageControl()
    
    //为remarkTableView添加单击手势－－点击时关闭键盘
    var tapGesture = UITapGestureRecognizer()
    
    var api = YoYoAPI()
    
    ///闲置查看URL
    var idleViewURL:String = ""
    
    ///评论查看URL
    var commentsViewURL:String = ""
    
    ///创建评论URL
    var commentCreateURL:String = ""
    
    ///创建评论所需参数
    var param_commentCreate = ["":""]
    
    ///闲置点赞
    var idleLikeURL:String = ""
    
    ///闲置取赞
    var idleUnlikeURL:String = ""
    
    ///评论点赞
    var commentLikeURL:String = ""
    
    ///评论取赞
    var commentUnlikeURL:String = ""
    
    ///收藏
    var collectURL:String = ""
    
    ///取消收藏
    var collectCancelURL:String = ""
    
    var is_collected:Int = 0
    
    ///要查看的闲置id
    internal var idle_id = ""
    
    ///存放评论
    var commentsJSON:[JSON] = []
    
    ///下拉刷新所需page
    var commentPage:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpNavigaitonBar()
        self.setUpActions()
        self.setUpInitialLooking()
        self.setUpGesture()
        // Do any additional setup after loading the view.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.pageCtl.removeObserver(self, forKeyPath: "currentPage")
    }
    
    func setUpNavigaitonBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "闲置", backTitle: "<")
    }
    
    func setExtraCellLineHidden(tableView:UITableView){
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = view
    }
    
    func setUpInitialLooking(){
        
        let newWidth = self.view.frame.width
        
        self.view.backgroundColor = Consts.grayView
        
        //右侧底部——评论框
        self.rightBottomView.frame = self.bottomView.frame

        self.remarkTextView.layer.borderColor = Consts.lightGray.CGColor
        
        /*****************设置指示器*****************/
//        self.inScrollIndicator.frame = CGRect(x:self.detailBtn.frame.minX, y: 0, width: self.detailBtn.frame.width, height: self.scrollIndicator.frame.height)
//        self.inScrollIndicator.backgroundColor = Consts.tintGreen
//        self.scrollIndicator.addSubview(self.inScrollIndicator)
        self.scrollIndicator.backgroundColor = Consts.grayView
        
        //contentSize
//        self.scrollIndicator.contentSize = CGSize(width:self.inScrollIndicator.frame.width , height: 0)
        self.scrollIndicator.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollIndicator.pagingEnabled = true
        
        //设置要显示的两个view
        ///1⃣️detailView
//        self.detailView.frame = CGRect(x:0,y:0, width:self.horizontalScroll.frame.width, height: self.horizontalScroll.frame.height)
        self.detailView.backgroundColor = Consts.grayView
        self.detailView.editable = false
        
        ///2⃣️remarkTableView
//        self.remarkTableView.frame = CGRect(x:self.horizontalScroll.frame.width, y: 0, width: self.horizontalScroll.frame.width, height: self.horizontalScroll.frame.height)
        self.remarkTableView.showsVerticalScrollIndicator = false
        self.remarkTableView.backgroundColor = Consts.grayView
//        self.remarkTableView.fd_debugLogEnabled = true
        
        ///下拉刷新：添加头部控件方法  
        self.remarkTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefreshing")
        
        ///上拉加载
        self.remarkTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefreshing")
        
        //设置水平滑动.frame已在xib定义
//        self.horizontalScroll.addSubview(self.detailView)
//        self.horizontalScroll.addSubview(self.remarkTableView)
        
         /*****************设置ScrollView滑动范围*****************/
        //设置水平滑动范围
//        self.horizontalScroll.contentSize = CGSize(width: self.horizontalScroll.frame.width * 2, height:0)//只允许水平滑动，禁止垂直滑动
        //设置初始偏移量
        self.horizontalScroll.contentOffset = CGPoint(x: 0, y: 0)
        //关闭自带指示器
        self.horizontalScroll.showsHorizontalScrollIndicator = false
        //打开翻页模式
        self.horizontalScroll.pagingEnabled = true
        
        /*****************设置页控制器*****************/
        //有关page数目、currentPage已在xib中设定
        //颜色透明，不显示
        self.pageCtl.numberOfPages = 2
//        self.pageCtl.frame = CGRect(x: 133, y: 70, width: 39, height: 37)
        self.pageCtl.currentPage = 0
        self.pageCtl.pageIndicatorTintColor = UIColor.clearColor()
        self.pageCtl.currentPageIndicatorTintColor = UIColor.clearColor()
        //关闭控制器按钮的点击响应
        self.pageCtl.enabled = false
        self.horizontalScroll.addSubview(self.pageCtl)
        
        self.setExtraCellLineHidden(self.remarkTableView)
        
        Tool.showProgressHUD("")
        
        setUpOnlineData("idleView")
        setUpOnlineData("commentView")
    }
    
    //下拉刷新回调
    func headerRefreshing(){
        self.commentPage = 1
        setUpOnlineData("commentView")
    }
    
    func footerRefreshing(){
        self.commentPage++
        setUpOnlineData("commentView")
    }
    /*********************************************/
    //监听和处理翻页后的变化
    /*********************************************/
    
    ///处理滑动后按钮的颜色变化
    func tabChangeTo(state : Int){
        switch (state){
        case 0:
            self.bottomView.hidden = false
            self.rightBottomView.hidden = true
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.25)
            UIView.setAnimationCurve(.EaseIn)
            self.detailBtn.setTitleColor(Consts.tintGreen, forState: .Normal)
            self.remarkBtn.setTitleColor(Consts.darkGray, forState: .Normal)
            UIView.commitAnimations()
            break
        case 1:
            self.bottomView.hidden = true
            self.rightBottomView.hidden = false
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
    
    ///页面滑动后更改页控制器的当前页数
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView == self.horizontalScroll){
            let offset : CGPoint = scrollView.contentOffset
            self.scrollIndicator.contentOffset = CGPoint(x: -offset.x / 2 , y: offset.y)
            //计算当前在第几页
            //用UIScrollView水平滚动的距离－页面宽度/2,除以页面宽度的结果＋1，即可得到当前为第几页
            let tmpPage = Int(floor((offset.x - self.view.frame.width/2)/self.view.frame.width)+1)
            self.pageCtl.currentPage = tmpPage
        }
    }
    
    ///监听pageCtl.currentPage的变化,以改变按钮属性
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "currentPage"){
            self.tabChangeTo(self.pageCtl.currentPage)
        }
    }

    func setUpActions(){
        api.delegate = self
        //为scrollView设置代理
//        self.horizontalScroll.delegate = self
        self.pageCtl.addObserver(self, forKeyPath: "currentPage", options: .New, context: nil)
        
        //为remarkTableview设置代理等
//        self.remarkTableView.delegate = self
//        self.remarkTableView.dataSource = self
        let remarkCellNib = UINib.init(nibName: "remarkCell", bundle: nil)
        self.remarkTableView.registerNib(remarkCellNib, forCellReuseIdentifier: "remark")
        
        //为textview设置代理
//        self.remarkTextView.delegate = self
    }
    
    func setUpOnlineData(tag:String){
        switch(tag){
            case "idleView":
            self.idleViewURL = "\(Consts.mainUrl)/v1.0/idle/\(self.idle_id)"
            api.httpRequest("GET", url: self.idleViewURL, params: nil, tag: "idleView")
        break
            
            case "commentView":
            self.commentsViewURL = "\(Consts.mainUrl)/v1.0/idle/\(idle_id)/comment/\(self.commentPage)"
            api.httpRequest("GET", url: self.commentsViewURL, params: nil, tag: "commentView")
        break
        
            case "commentCreate":
            self.commentCreateURL = "\(Consts.mainUrl)/v1.0/idle/\(self.idle_id)/comment/"
            api.httpRequest("POST", url: self.commentCreateURL, params: self.param_commentCreate, tag: "commentCreate")
        break
            
            case "idleLike":
            self.idleLikeURL = "\(Consts.mainUrl)/v1.0/idle/\(self.idle_id)/like/"
            api.httpRequest("POST", url: self.idleLikeURL, params: nil, tag: "idleLike")
        break
            
            case "idleUnlike":
            self.idleUnlikeURL = "\(Consts.mainUrl)/v1.0/idle/\(self.idle_id)/like/"
            api.httpRequest("DELETE", url: self.idleUnlikeURL, params: nil, tag: "idleUnlike")
        break
            
            case "commentLike":
            api.httpRequest("POST", url: self.commentLikeURL, params: nil, tag: "commentLike")
        break
            
            case "commentUnlike":
            api.httpRequest("DELETE", url: self.commentUnlikeURL, params: nil, tag: "commentUnlike")
        break
            
            case "collect":
            self.collectURL = "\(Consts.mainUrl)/v1.0/idle/collection/\(self.idle_id)"
            api.httpRequest("POST", url: self.collectURL, params: nil, tag: "collect")
        break
            
            case "collectCancel":
            self.collectCancelURL = "\(Consts.mainUrl)/v1.0/idle/collection/\(self.idle_id)"
            api.httpRequest("DELETE", url: self.collectCancelURL, params: nil, tag: "collectCancel")
    default:
        break
        }
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setUpGesture(){
        self.tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.tapGesture.cancelsTouchesInView = false
        self.remarkTableView.addGestureRecognizer(self.tapGesture)
    }
    
    //btn已全部绑定该函数,根据tag区分
    @IBAction func BtnClicked(sender: UIButton) {
        switch(sender.tag){
        case 0://点赞
            if(AppDelegate.isLogin == true){
                setUpOnlineData("idleLike")
                self.praiseBtn.tag = 10
            }else{
                Tool.showErrorHUD("请先登录!")
            }
            break
        case 10://取消点赞
            if(AppDelegate.isLogin == true){
                setUpOnlineData("idleUnlike")
                self.praiseBtn.tag = 0
            }else{
                Tool.showErrorHUD("请先登录!")
            }
            break
        case 1://新东方
            break
        case 2://详情
            self.horizontalScroll.contentOffset = CGPoint(x: 0, y: 0)
            break
        case 3://评论
            self.horizontalScroll.contentOffset = CGPoint(x:self.horizontalScroll.frame.width, y: 0)
            break
        case 4://收藏
            if(AppDelegate.isLogin == true){
            setUpOnlineData("collect")
            }else{
                Tool.showErrorHUD("请先登录!")
            }
        case 11://取消收藏
            if(AppDelegate.isLogin == true){
            setUpOnlineData("collectCancel")
            }else{
                Tool.showErrorHUD("请先登录!")
            }
            break
        case 5://咨询
            self.showMenu()
            break
        case 6://发表
            if(AppDelegate.isLogin == true){
                self.remarkTextView.resignFirstResponder()
            if(self.remarkTextView.text.isEmpty || self.remarkTextView.text == "请评论......"){
                
            }else{
                self.param_commentCreate = ["content":self.remarkTextView.text]
                setUpOnlineData("commentCreate")
            }
                self.remarkTextView.text = "请评论......"
            }else{
                Tool.showErrorHUD("请先登录!")
            }
            break
            
        default:
            break
        }
    }
//    评论点赞
    func remark_likeBtnClicked(sender:UIButton){
        if(AppDelegate.isLogin == true){
        let indexpath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = self.remarkTableView.cellForRowAtIndexPath(indexpath) as! remarkCell
        self.commentLikeURL = "\(Consts.mainUrl)/v1.0/idle/\(self.idle_id)/comment/\(cell.commentID)/useful/"
        commentsJSON[sender.tag]["useful_clicked"] = true
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
        let cell = self.remarkTableView.cellForRowAtIndexPath(indexpath) as! remarkCell
        self.commentUnlikeURL = "\(Consts.mainUrl)/v1.0/idle/\(self.idle_id)/comment/\(cell.commentID)/useful/"
        commentsJSON[sender.tag]["useful_clicked"] = false
        commentsJSON[sender.tag]["useful_number"].int!--
        setUpOnlineData("commentUnlike")
        }else{
            Tool.showErrorHUD("请先登录!")
        }
    }

    //remarkTableView代理方法
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.remarkTableView.dequeueReusableCellWithIdentifier("remark", forIndexPath: indexPath) as! remarkCell
        setupCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsJSON.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.remarkTableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func setupCell(cell:remarkCell, atIndexPath indexPath:NSIndexPath){
        
        cell.backgroundColor = Consts.grayView
        cell.photo.sd_setImageWithURL(commentsJSON[indexPath.row]["image"].URL!, placeholderImage: UIImage.init(named: "bear_icon_register"))
        cell.layer.cornerRadius = cell.photo.frame.width/2
        cell.nameLabel.text = commentsJSON[indexPath.row]["name"].string!
        cell.timeLabel.text = commentsJSON[indexPath.row]["date"].string!
        cell.commentID = commentsJSON[indexPath.row]["id"].string!
        cell.hasLike = commentsJSON[indexPath.row]["useful_clicked"].bool!
        cell.like_count = commentsJSON[indexPath.row]["useful_number"].int!
        if(cell.hasLike == false){
            cell.likeBtn.setBackgroundImage(UIImage.init(named: "unlike"), forState: .Normal)
            cell.likeBtn.removeTarget(self, action: "remark_unlikeBtnClicked", forControlEvents: .TouchUpInside)
            cell.likeBtn.addTarget(self, action: "remark_likeBtnClicked:", forControlEvents: .TouchUpInside)
        }else{
            cell.likeBtn.setBackgroundImage(UIImage.init(named: "xianzhi_icon_like"), forState: .Normal)
            cell.likeBtn.removeTarget(self, action: "remark_likeBtnClicked:", forControlEvents: .TouchUpInside)
            cell.likeBtn.addTarget(self, action: "remark_unlikeBtnClicked:", forControlEvents: .TouchUpInside)
        }
        cell.likeCountLabel.text = "\(cell.like_count)"
        cell.likeBtn.tag = indexPath.row
        //保证remarkLabel可以多行显示
        cell.remarkLabel.lineBreakMode = .ByWordWrapping
        cell.remarkLabel.numberOfLines = 0
        cell.remarkLabel.sizeToFit()
        cell.remarkLabel.text = commentsJSON[indexPath.row]["content"].string!

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return self.remarkTableView.frame.height*0.5
        return tableView.fd_heightForCellWithIdentifier("remark", configuration: { (cell) -> Void in
            self.setupCell(cell as! remarkCell, atIndexPath: indexPath)
        })
    }
    
    ///实现点击UIView内部关闭键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //将要编辑textview时激发方法
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.remarkTextView.text = ""
        return true
    }
    //结束编辑时激发方法
    func textViewDidEndEditing(textView: UITextView) {
        if self.remarkTextView.text.isEmpty{
            self.remarkTextView.text = "请评论......"
        }
    }
    //分享 
    func Share(){
            
    }

    ///实现点击UITableView内部关闭键盘
    func dismissKeyboard(){
        let indexs : NSArray? = self.remarkTableView.indexPathsForVisibleRows
        if(indexs != nil){
            for i in indexs!{
                self.remarkTextView.resignFirstResponder()
                }
            }
        }
    
    
    ///实现拖动时关闭键盘
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if(scrollView == self.remarkTableView){
            self.remarkTextView.resignFirstResponder()
        }
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
                self.app.openURL(NSURL(string: "sms:\(self.consultPhoneNum)")!)
            }else if(selectedItem.title == "tel"){
                self.self.webViewCallPhone()
            }
        };
    
        popMenu.showMenuAtView(self.view)
    }
    
    func  webViewCallPhone(){
//        此种方法打完电话可以回到本应用
        let callWebview = UIWebView()
        let teleURL = NSURL(string: "tel:\(self.consultPhoneNum)")
        callWebview.loadRequest(NSURLRequest(URL: teleURL!))
//        将uiwebview添加到view
        self.view.addSubview(callWebview)
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        switch(tag){
        case "idleView":
            self.bigImgView.sd_setImageWithURL(NSURL(string: json["image"].string!), placeholderImage: UIImage.init(named: "Commodity editor_btn_picture"))
                self.goodNameLabel.text = json["name"].string!
            self.roundBtn.setBackgroundImage(UIImage(data: NSData(contentsOfURL: json["user_image"].URL!)!), forState: .Normal)
            self.roundBtn.layer.cornerRadius = self.roundBtn.frame.width/2
            self.roundBtn.layer.masksToBounds = true
            self.shopNameBtn.setTitle(json["user_name"].string!, forState: .Normal)
            let price = Float(json["price"].int!)/100.00
            self.presentPriceLabel.text = "¥ \(price)"
            let viewnumber = json["view_number"].int!
            self.previewCountLabel.text = "\(viewnumber) 人感兴趣"
            let likenum = json["like_number"].int!
            self.praiseCountLabel.text = "\(likenum) 人赞"
            self.timeLabel.text = json["last_update"].string!
            self.detailView.text = json["description"].string!
            if(json["like_clicked"] == 1){
                self.praiseBtn.setBackgroundImage(UIImage.init(named: "xiangqing_btn_dianzan_p"), forState: .Normal)
                self.praiseBtn.tag = 10//已点赞
            }else{
                self.praiseBtn.setBackgroundImage(UIImage.init(named: "xiangqing_btn_dianzan"), forState: .Normal)
                self.praiseBtn.tag = 0//未点赞
            }
            self.is_collected = json["is_collected"].int!
            if(self.is_collected == 1){
                self.collectBtn_img.setBackgroundImage(UIImage(named: "xiangqing_tab bar_collect_p"), forState: .Normal)
                self.collectBtn_img.tag = 11
                self.collectBtn_text.tag = 11
            }else{
                self.collectBtn_img.setBackgroundImage(UIImage(named: "xiangqing_tab bar_collect_n"), forState: .Normal)
                self.collectBtn_img.tag = 4
                self.collectBtn_text.tag = 4
            }
            self.consultPhoneNum = json["phone_num"].string!
            break
            
        case "commentView":
            if(json["idle_comment"].count == 0 && self.commentPage > 1){
                self.remarkTableView.mj_footer.endRefreshingWithNoMoreData()
                self.commentPage--
            }else if(json["idle_comment"].count > 0 && self.commentPage > 1){
                self.commentsJSON = self.commentsJSON + json["idle_comment"].array!
            }else if(self.commentPage == 1){
                self.commentsJSON = json["idle_comment"].array!
            }
            self.remarkTableView.reloadData()
            Tool.dismissHUD()
            self.remarkTableView.mj_header.endRefreshing()
            self.remarkTableView.mj_footer.endRefreshing()
            
            break
            
        case "commentCreate":
            self.setUpOnlineData("commentView")
            break
            
        case "idleLike":
            self.setUpOnlineData("idleView")
            break
        
        case "idleUnlike":
            self.setUpOnlineData("idleView")
            break
            
        case "commentLike":
            self.remarkTableView.reloadData()
            break
            
        case "commentUnlike":
            self.remarkTableView.reloadData()
            break
            
        case "collect":
            self.collectBtn_img.setBackgroundImage(UIImage(named: "xiangqing_tab bar_collect_p"), forState: .Normal)
            self.collectBtn_img.tag = 11
            self.collectBtn_text.tag = 11
            break
            
        case "collectCancel":
            self.collectBtn_img.setBackgroundImage(UIImage(named: "xiangqing_tab bar_collect_n"), forState: .Normal)
            self.collectBtn_img.tag = 4
            self.collectBtn_text.tag = 4
            break

        default:
            break
        }
    }
    

}
