//
//  OrderPayVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/27.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderPayVC: UIViewController,APIDelegate {

    @IBOutlet var label_orderName: UILabel!
    
    @IBOutlet var label_totalPrice: UILabel!
    
    @IBOutlet var label_toPay: UILabel!
    
    @IBOutlet var label_discount: UILabel!
    
    @IBOutlet var btn_aliPay: UIButton!//tag:0

    @IBOutlet var btn_wechat: UIButton!//tag:1
    
    @IBOutlet var btn_confirmPay: UIButton!//tag:2
    
    var selectPayWay = 0
    
    var api = YoYoAPI()
    
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
        Consts.setUpNavigationBarWithBackButton(self, title: "订单确认", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        self.view.backgroundColor = Consts.grayView
        
        self.label_orderName?.text = "恐龙园两日游"
        self.label_totalPrice?.text = "¥ 1200"
        self.label_toPay?.text = "¥ 1000"
        self.label_discount?.text = "¥ 200"
        
        self.btn_wechat.setBackgroundImage(UIImage.init(named: "dingdan_btn_select"), forState: .Normal)
        self.btn_aliPay.setBackgroundImage(UIImage.init(named: "dingdan_btn_get"), forState: .Normal)
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
    
    
    @IBAction func btnClicked(sender: UIButton) {
        switch(sender.tag){
        case 0:
            self.btn_aliPay.setBackgroundImage(UIImage.init(named: "dingdan_btn_get"), forState: .Normal)
            self.selectPayWay = 0
            self.btn_wechat.setBackgroundImage(UIImage.init(named: "dingdan_btn_select"), forState: .Normal)
            break
        case 1:
            self.btn_aliPay.setBackgroundImage(UIImage.init(named: "dingdan_btn_select"), forState: .Normal)
            self.btn_wechat.setBackgroundImage(UIImage.init(named: "dingdan_btn_get"), forState: .Normal)
            self.selectPayWay = 1
            break
        case 2:
            if(self.selectPayWay == 0){
                Tool.showSuccessHUD("支付宝!")
            }else{
                Tool.showSuccessHUD("微信!")
            }
        default:
            break
        }
    }
    
}
