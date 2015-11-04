//
//  CouponViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/21.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation


class CouponViewController: UIViewController,APIDelegate{

    @IBOutlet var ownLabel: UILabel!
    
    @IBOutlet var timeLimitLabel: UILabel!
    
    @IBOutlet var titleLabel1: UILabel!
    
    @IBOutlet var titleLabel2: UILabel!
    
    @IBOutlet var instructionLabel: UITextView!
    
    @IBOutlet var leftPointView: UIView!
    
    @IBOutlet var rightPointView: UIView!
    
    @IBOutlet var shareBtn: UIButton!
    
    var getDiscountCardURL:String = ""
    
    var api = YoYoAPI()
    
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
        Consts.setUpNavigationBarWithBackButton(self, title: "万能优惠卡", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        self.view.backgroundColor = Consts.grayView
        leftPointView.layer.cornerRadius = leftPointView.frame.width/2
        rightPointView.layer.cornerRadius = rightPointView.frame.width/2
    }
    
    func setUpActions(){
        api.delegate = self
    }
    
    func setUpOnlineData(tag:String){
        if(tag == "discount"){
            self.getDiscountCardURL = "\(Consts.mainUrl)/v1.0/card/share/"
            api.httpRequest("POST", url: getDiscountCardURL, params: nil, tag: "discount")
        }
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func btnClicked(sender: UIButton) {
//        share:
        let shareAlert = DXAlertView(title: "分享到", leftButtonImage: UIImage.init(named: "fenxiang_icon_pengyouquan"), leftButtonTitle: "朋友圈", midButtonImage: UIImage.init(named: "fenxiang_icon_weixin"), midButtonTitle: "微信好友", rightButtonImage: UIImage.init(named: "fenxiang_icon_kongjian"), rightButtonTitle: "QQ空间")
        shareAlert.show()
        shareAlert.leftBlock = {
            //            设置点击分享内容跳转链接
            //            注意设置的链接必须为http链接
            UMSocialData.defaultData().extConfig.wechatTimelineData.url = "http://www.baidu.com"
            
            //            设置title
            //            设置微信朋友圈title
            UMSocialData.defaultData().extConfig.wechatTimelineData.title = "一张优惠卡在手，校园生活服务尽享优惠!"
            UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatTimeline], content: "一张优惠卡在手，校园生活服务尽享优惠", image: UIImage.init(named: "register_icon_just a sign"), location: nil, urlResource: nil, presentedController: self, completion: { (response) -> Void in
                if(response.responseCode == UMSResponseCodeSuccess){
                    self.setUpOnlineData("discount")
                }
            })

        }
        
        shareAlert.midBlock = {
            print("mid")
            //            设置点击分享内容跳转链接
            //            注意设置的链接必须为http链接
            UMSocialData.defaultData().extConfig.wechatSessionData.url = "http://www.baidu.com"
            UMSocialData.defaultData().extConfig.wechatSessionData.title = "悠悠校园，万能优惠卡来啦～"
            UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatSession], content: "一张优惠卡在手，校园生活服务尽享优惠", image: UIImage.init(named: "register_icon_just a sign"), location: nil, urlResource: nil, presentedController: self, completion: { (response) -> Void in
                if(response.responseCode == UMSResponseCodeSuccess){
                    self.setUpOnlineData("discount")
                }
            })

        }
        shareAlert.rightBlock = {
            //            设置点击分享内容跳转链接
            //            注意设置的链接必须为http链接
            UMSocialData.defaultData().extConfig.qzoneData.url = "http://www.baidu.com"
            UMSocialData.defaultData().extConfig.qzoneData.title = "悠悠校园，万能优惠卡来啦～"
                UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToQzone], content: "一张优惠卡在手，校园生活服务尽享优惠", image: UIImage.init(named: "register_icon_just a sign"), location: nil, urlResource: nil, presentedController: self, completion: { (response) -> Void in
                    if(response.responseCode == UMSResponseCodeSuccess){
                        self.setUpOnlineData("discount")
                    }
                })

        }
    }

    func didReceiveJsonResults(json: JSON, tag: String) {
    }
    
}
