//
//  CouponViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/21.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

class CouponViewController: UIViewController,APIDelegate {

    @IBOutlet var ownLabel: UILabel!
    
    @IBOutlet var timeLimitLabel: UILabel!
    
    @IBOutlet var titleLabel1: UILabel!
    
    @IBOutlet var titleLabel2: UILabel!
    
    @IBOutlet var instructionLabel: UITextView!
    
    @IBOutlet var leftPointView: UIView!
    
    @IBOutlet var rightPointView: UIView!
    
    @IBOutlet var shareBtn: UIButton!
    
    
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
        Consts.setUpNavigationBarWithBackButton(self, title: "万能优惠卡", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        self.view.backgroundColor = Consts.grayView
        leftPointView.layer.cornerRadius = leftPointView.frame.width/2
        rightPointView.layer.cornerRadius = rightPointView.frame.width/2
    }
    
    func setUpActions(){
        
    }
    
    func setUpOnlineData(){
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func btnClicked(sender: UIButton) {
//        share:
        let shareAlert = DXAlertView(title: "分享到", leftButtonImage: UIImage.init(named: "fenxiang_icon_pengyouquan"), leftButtonTitle: "朋友圈", midButtonImage: UIImage.init(named: "fenxiang_icon_weixin"), midButtonTitle: "微信好友", rightButtonImage: UIImage.init(named: "fenxiang_icon_kongjian"), rightButtonTitle: "QQ空间")
        shareAlert.show()
        shareAlert.leftBlock = {
            print("朋友圈")
            
//        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatTimeline]
//            ,content:"分享至朋友圈",image:nil,location:nil,urlResource:nil, presentedController:self,completion:nil)
            UMSocialDataService.defaultDataService().
            
        }
        shareAlert.midBlock = {
            print("微信好友")
        }
        shareAlert.rightBlock = {
            print("qq空间")
        }
    }

    func didReceiveJsonResults(json: JSON, tag: String) {
        
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
