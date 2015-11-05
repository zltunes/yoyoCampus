

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

    
    @IBOutlet var remarkTextView: UITextView!
    
    @IBOutlet var submitBtn: UIButton!
    
    var ratingBar = RatingBar()
    
    var rating:Int = 0
    
    var ratingLabel = UILabel()
    
    var api = YoYoAPI()
    
    internal var order_id:String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpNavigationBar()
        
        self.setUpInitialLooking()
        
        self.setUpActions()
        
        self.setUpOnlineData()
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
        
        self.ratingBar.frame = CGRect(x: self.view.frame.width/3.3, y: 120, width: 164, height: 18)
        self.view.addSubview(self.ratingBar)
        
        //是否显示指示器
        self.ratingBar.isIndicator = false
        self.ratingBar.setImageDeselected("ratingbar_unselected", halfSelected: nil, fullSelected: "ratingbar_selected", andDelegate: self)
        
//        显示结果label
        self.ratingLabel.frame = CGRect(x: 260, y: 120, width: 150, height: 20)
        self.ratingLabel.textColor = UIColor.orangeColor()
        self.ratingLabel.font = Consts.ft13
        self.view.addSubview(self.ratingLabel)
        
        self.remarkTextView.text = "亲，商品如何，服务是否周到"
        
        
    }
    
    func setUpActions(){
        self.api.delegate = self
        
    }
    
    func setUpOnlineData(){
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        
    }
    
    //触摸背景关键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.remarkTextView.resignFirstResponder()
    }
    
    @IBAction func btnClicked(sender: UIButton) {
//        提交评价
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
