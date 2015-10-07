//
//  IdleGoodViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/9/28.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class IdleGoodViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {

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

    ///指示器视图
    var scrollIndicator = UIScrollView()
    
    ///指示器内的指示色块
    var inScrollIndicator = UIView()
    
    ///详情视图
    var detailView = UITextView()
    
    ///评论视图
    var remarkTableView = UITableView()

    //左侧底部
    @IBOutlet var bottomView: UIView!
    //右侧底部

    @IBOutlet var rightBottomView: UIView!
    
    @IBOutlet var remarkTextView: UITextView!
    
    @IBOutlet var repostRemarkBtn: UIButton!//tag:6
    
    //页控制器
    var pageCtl = UIPageControl()
    
    //为remarkTableView添加单击手势－－点击时关闭键盘
    var tapGesture = UITapGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpNavigaitonBar()
        self.setUpInitialLooking()
        self.setUpActions()
        self.setUpOnlineData()
        self.setUpGesture()
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

        let shareBtnItem = UIBarButtonItem(image: UIImage(named: "xiangqing_status bar_share"), style: UIBarButtonItemStyle.Plain, target: self, action: "Share")
        shareBtnItem.tintColor = Consts.white
        self.navigationItem.rightBarButtonItem = shareBtnItem
    }
    
    func setUpInitialLooking(){
        
        let newWidth = self.view.frame.width
        
        self.view.backgroundColor = Consts.grayView
        
        self.goodNameLabel.text = "考研全科班陪你进复试"
        
        self.roundBtn.layer.cornerRadius = self.roundBtn.frame.width/2
        
        self.presentPriceLabel.text = "¥ 4330"
        
        self.previewCountLabel.text = "65人感兴趣"
        
        self.praiseCountLabel.text = "15人赞"
        
        self.timeLabel.text = "2015-03-09"
        
        //右侧底部——评论框
        self.rightBottomView.frame = self.bottomView.frame

        self.remarkTextView.layer.borderColor = Consts.lightGray.CGColor
        /*****************设置指示器*****************/
        self.scrollIndicator.frame = CGRect(x: 0, y: self.detailBtn.frame.maxY+1, width:newWidth , height: 2.8)
        self.inScrollIndicator.frame = CGRect(x: self.detailBtn.frame.width/2.5, y: 0, width: self.detailBtn.frame.width/3, height: 2.8)
        self.inScrollIndicator.backgroundColor = Consts.tintGreen
        self.scrollIndicator.addSubview(self.inScrollIndicator)
        self.scrollIndicator.backgroundColor = Consts.grayView
        self.view.addSubview(self.scrollIndicator)
        
        //contentSize
        self.scrollIndicator.contentSize = CGSize(width: newWidth, height: 0)
        self.scrollIndicator.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollIndicator.pagingEnabled = true
        
        //设置要显示的两个view
        ///1⃣️detailView
        self.detailView.frame = CGRect(x:0,y:0, width:self.horizontalScroll.frame.width, height: self.horizontalScroll.frame.height)
        self.detailView.backgroundColor = Consts.grayView
        self.detailView.editable = false
        self.detailView.text = "正版、九五新、少量涂写，雅思1-9全套复习资料，大四毕业甩。"
        
        ///2⃣️remarkTableView
        self.remarkTableView.frame = CGRect(x:self.horizontalScroll.frame.width, y: 0, width: self.horizontalScroll.frame.width, height: self.horizontalScroll.frame.height)
        self.remarkTableView.backgroundColor = Consts.grayView
        
        //设置水平滑动.frame已在xib定义
        self.horizontalScroll.addSubview(self.detailView)
        self.horizontalScroll.addSubview(self.remarkTableView)
        
         /*****************设置ScrollView滑动范围*****************/
        //设置水平滑动范围
        self.horizontalScroll.contentSize = CGSize(width: self.horizontalScroll.frame.width * 2, height:0)//只允许水平滑动，禁止垂直滑动
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
        //保证控制器总在最前
//        self.view.bringSubviewToFront(self.pageCtl)
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
            self.detailBtn.titleLabel?.textColor = Consts.tintGreen
            self.remarkBtn.titleLabel?.textColor = Consts.darkGray
            UIView.commitAnimations()
            break
        case 1:
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.25)
            UIView.setAnimationCurve(.EaseIn)
            self.bottomView.hidden = true
            self.rightBottomView.hidden = false
            self.remarkBtn.titleLabel?.textColor = Consts.tintGreen
            self.detailBtn.titleLabel?.textColor = Consts.darkGray
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
            self.scrollIndicator.contentOffset = CGPoint(x: -offset.x / 2, y: offset.y)
            var tmpPage = Int(Float(offset.x))/Int(Float(self.horizontalScroll.frame.width))
            let remain = Int(Float(offset.x))%Int(Float(self.horizontalScroll.frame.width))
            //人为判断四舍五入,否则会出现左至右和右至左的切换时机不同
            if(remain > Int(Float(self.horizontalScroll.frame.width / 2))){
                tmpPage += 1
            }
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
        //为scrollView设置代理
        self.horizontalScroll.delegate = self
        self.pageCtl.addObserver(self, forKeyPath: "currentPage", options: .New, context: nil)
        
        //为remarkTableview设置代理等
        self.remarkTableView.delegate = self
        self.remarkTableView.dataSource = self
        let remarkCellNib = UINib.init(nibName: "remarkCell", bundle: nil)
        self.remarkTableView.registerNib(remarkCellNib, forCellReuseIdentifier: "remark")
        
        //为textview设置代理
        self.remarkTextView.delegate = self
    }
    
    func setUpOnlineData(){
        
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
        let newWidth = self.view.frame.width
        if sender.tag == 2{//详情
            self.horizontalScroll.contentOffset = CGPoint(x: 0, y: 0)
            self.tabChangeTo(self.pageCtl.currentPage)
        }else if sender.tag == 3{//评论
            self.horizontalScroll.contentOffset = CGPoint(x:self.horizontalScroll.frame.width, y: 0)
            self.tabChangeTo(self.pageCtl.currentPage)
        }else if sender.tag == 6{//发表
            self.remarkTextView.resignFirstResponder()
        }else if sender.tag == 0{//图片点赞
            self.praiseBtn.setBackgroundImage(UIImage(named: "xiangqing_btn_dianzan_p"), forState: .Normal)
            self.praiseBtn.tag = 10
        }else if sender.tag == 10{//图片取消点赞
            self.praiseBtn.setBackgroundImage(UIImage(named: "xiangqing_btn_dianzan"), forState: .Normal)
            self.praiseBtn.tag = 0
        }
    }

    //remarkTableView代理方法
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.remarkTableView.dequeueReusableCellWithIdentifier("remark", forIndexPath: indexPath) as! remarkCell
        cell.backgroundColor = Consts.grayView
        cell.nameLabel.text = "宇宙无敌小可爱"
        cell.timeLabel.text = "2016-01-19"
        cell.likeCountLabel.text = "15"
        //保证remarkLabel可以多行显示
        cell.remarkLabel.lineBreakMode = .ByWordWrapping
        cell.remarkLabel.numberOfLines = 0
        cell.remarkLabel.sizeToFit()
        cell.remarkLabel.text = "很不错的地方，班级游大家一起去的。玩得很开心，商家提供班车，很方便!"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.remarkTableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.remarkTableView.frame.height*0.75
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

}
