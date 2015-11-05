//
//  UserFeedbackViewController.swift
//  yoyoCampus
//
//  Created by DuZhiXia on 15/9/15.
//  Copyright © 2015年 DuZhiXia. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserFeedbackViewController: UIViewController,UITextViewDelegate,APIDelegate{

    var bkg1 = UIView()
    
    var staticLabel = UILabel()
    
    ///反馈内容
    var feedbackText = UITextView()
    
    ///提交
    var submitButton = UIButton()
    
    var api = YoYoAPI()
    
    var feedBackURL:String = ""
    
    var param = ["":""]
    
    
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
        Consts.setUpNavigationBarWithBackButton(self, title: "意见反馈", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height
        
        self.view.backgroundColor = Consts.grayView
        
        self.bkg1.frame = CGRect(x: 0, y: 0, width: newWidth, height: 500 * Consts.ratio)
        self.bkg1.backgroundColor = Consts.white
        self.bkg1.layer.shadowColor = Consts.black.CGColor
        self.bkg1.layer.shadowOffset = CGSize(width: 0, height: 0.5 * Consts.ratio)
        self.bkg1.layer.shadowOpacity = 0.1
        self.view.addSubview(self.bkg1)
        
        self.staticLabel = Consts.setUpLabel("意见反馈", color: Consts.lightGray, font: Consts.ft17, x: 70 * Consts.ratio, y: 30 * Consts.ratio,centerX: nil)
        self.bkg1.addSubview(self.staticLabel)
        
        self.feedbackText.frame = CGRect(x: self.staticLabel.frame.minX, y: self.staticLabel.frame.maxY + 10 * Consts.ratio, width: newWidth - self.staticLabel.frame.minX * 2, height: 300 * Consts.ratio)
        self.feedbackText.layer.borderWidth = 0.5
        self.feedbackText.font = Consts.ft14
        self.feedbackText.text = "请输入您遇到的问题或对我们的意见或建议"
        self.feedbackText.textColor = Consts.darkGray
        self.bkg1.addSubview(self.feedbackText)
        
        self.submitButton = Consts.setUpButton("提 交", frame: CGRect(x: self.staticLabel.frame.minX, y: self.bkg1.frame.maxY + 60 * Consts.ratio, width: self.feedbackText.frame.width, height: 90 * Consts.ratio),font: Consts.ft20, radius: 10 * Consts.ratio)
        self.view.addSubview(self.submitButton)
    }
    
    func setUpActions(){
        api.delegate = self
        self.feedbackText.delegate = self
        self.submitButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
    }
    
    func setUpOnlineData(tag:String){
        switch(tag){
            case "feedBack":
                self.feedBackURL = "\(Consts.mainUrl)/v1.0/suggestion/"
                api.httpRequest("POST", url: self.feedBackURL, params: nil, tag: "feedBack")
            break
            
        default:
            break
        }
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func buttonClicked(sender:UIButton){
        if(sender.titleLabel?.text == "提 交"){
            if((self.feedbackText.text == "请输入您遇到的问题或对我们的意见或建议")||(self.feedbackText.text.isEmpty)){
                Tool.showErrorHUD("请输入您的反馈!")
            }else{
                self.param = ["content":self.feedbackText.text]
                setUpOnlineData("feedBack")
                Tool.showSuccessHUD("谢谢您的反馈!")
                self.goBack()
            }
        }
    }
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if(self.feedbackText.text == "请输入您遇到的问题或对我们的意见或建议"){
            self.feedbackText.text = ""
        }
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if(self.feedbackText.text.isEmpty){
            self.feedbackText.text = "请输入您遇到的问题或对我们的意见或建议"
        }
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.feedbackText.resignFirstResponder()
    }
}
