

//
//  remarkVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/25.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

class remarkVC: UIViewController,APIDelegate,UITextViewDelegate,RatingBarDelegate {

    @IBOutlet var remarkLabel: UILabel!
    
    @IBOutlet var remarkTextView: UITextView!
    
    @IBOutlet var submitBtn: UIButton!
    
    var ratingBar = RatingBar()
    
    var rating:Int = 0
    
    var ratingLabel = UILabel()
    
    var api = YoYoAPI()
    
    internal var order_id:String = ""
    
    internal var goods_id:String = ""
    
    var remarkURL:String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpNavigationBar()
        
        self.setUpInitialLooking()
        
        self.setUpActions()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "我的订单", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        self.view.backgroundColor = Consts.grayView
        
        
        self.ratingBar.frame = CGRect(x: self.view.frame.width/3, y: self.remarkLabel.frame.maxY + 50 * Consts.ratio, width: self.view.frame.width/3, height: 100 * Consts.ratio)

        self.ratingBar.center.x = self.view.center.x
        
        self.view.addSubview(self.ratingBar)


        //是否显示指示器
        self.ratingBar.isIndicator = false
        self.ratingBar.setImageDeselected("ratingbar_unselected", halfSelected: nil, fullSelected: "ratingbar_selected", andDelegate: self)
        
//        显示结果label
        self.ratingLabel.frame = CGRect(x: self.ratingBar.frame.maxX + 20 * Consts.ratio, y: self.remarkLabel.frame.maxY + 20 * Consts.ratio, width: 150 * Consts.ratio, height: 100 * Consts.ratio)
        self.ratingLabel.textColor = UIColor.orangeColor()
        self.ratingLabel.font = Consts.ft15
        self.view.addSubview(self.ratingLabel)
        
        self.remarkTextView.text = "亲，商品如何，服务是否周到"
        
        
    }
    
    func setUpActions(){
        self.api.delegate = self
        
    }
    
    func setUpOnlineData(tag:String){
        if(tag == "remark"){
            self.remarkURL = "\(Consts.mainUrl)/v1.0/goods/\(self.goods_id)/comment/"
            let param = ["order_id":order_id,"content":self.remarkTextView.text,"score":rating]
            api.httpRequest("POST", url: remarkURL, params: param as! [String : AnyObject], tag: "remark")
        }
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        if(tag == "remark"){
            let commentID = json["goods_comment_id"].string!
            print("goods_comment_id\(commentID)")
        }
    }
    
    //触摸背景关键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.remarkTextView.resignFirstResponder()
    }
    
    @IBAction func btnClicked(sender: UIButton) {
        if(self.remarkTextView.text.isEmpty || self.remarkTextView.text == "亲，商品如何，服务是否周到"){
            Tool.showErrorHUD("评价不可为空!")
        }else{
            setUpOnlineData("remark")
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if(self.remarkTextView.text == "亲，商品如何，服务是否周到"){
            self.remarkTextView.text = nil
        }
    }
    
    
    func ratingChanged(newRating: Int) {
        self.rating = newRating
        switch(newRating){
        case 1:
            self.ratingLabel.text = "很差"
            break
        case 2:
            self.ratingLabel.text = "一般"
            break
        case 3:
            self.ratingLabel.text = "好"
            break
        case 4:
            self.ratingLabel.text = "很好"
            break
        case 5:
            self.ratingLabel.text = "非常好"
            break
        default:
            break
        }
    }
    
    
}
