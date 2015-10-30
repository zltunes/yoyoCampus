//
//  UserFeedbackViewController.swift
//  yoyoCampus
//
//  Created by DuZhiXia on 15/9/15.
//  Copyright © 2015年 DuZhiXia. All rights reserved.
//

import UIKit

class UserFeedbackViewController: UIViewController,UITextViewDelegate {

    var bkg1 = UIView()
    
    var staticLabel = UILabel()
    
    ///反馈内容
    var feedbackText = UITextView()
    
//    var placeholder = UILabel()
    
    ///提交
    var submitButton = UIButton()
    
    
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
        Consts.setUpNavigationBarWithBackButton(self, title: "意见反馈", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height
        
        self.view.backgroundColor = Consts.grayView
        
        self.bkg1.frame = CGRect(x: 0, y: 64, width: newWidth, height: 500 * Consts.ratio)
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
        
//        self.placeholder.bounds = CGRect(x: 0, y: 0, width: self.feedbackText.frame.width, height: 0)
//        self.placeholder.numberOfLines = 0
//        self.placeholder.lineBreakMode = .ByWordWrapping
//        self.placeholder.attributedText = Consts.getAttributedString("请输入您遇到的问题或对我们的意见或建议")
//        self.placeholder.font = Consts.ft12
//        self.placeholder.sizeToFit()
//        self.placeholder.textColor = Consts.lightGray
//        self.placeholder.textAlignment = .Center
//        self.placeholder.frame.origin = CGPoint(x: self.feedbackText.frame.minX + 20 * Consts.ratio, y: self.feedbackText.frame.minY + 20 * Consts.ratio)
//        self.bkg1.addSubview(self.placeholder)
        
        self.submitButton = Consts.setUpButton("提 交", frame: CGRect(x: self.staticLabel.frame.minX, y: self.bkg1.frame.maxY + 60 * Consts.ratio, width: self.feedbackText.frame.width, height: 90 * Consts.ratio),font: Consts.ft20, radius: 10 * Consts.ratio)
        self.view.addSubview(self.submitButton)
    }
    
    func setUpActions(){
        self.feedbackText.delegate = self
        self.submitButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
    }
    
    func setUpOnlineData(){
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func buttonClicked(sender:UIButton){
        if(sender.titleLabel?.text == "提 交"){
            Tool.showSuccessHUD("谢谢您的反馈!")
            self.goBack()
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
    /*
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (!(text == "")){
            self.placeholder.hidden = true
        }
        
        if ((text == "") && (range.location == 0) && (range.length == 1)){
            self.placeholder.hidden = false
        }
        
        return true
    }
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.feedbackText.resignFirstResponder()
    }
}
