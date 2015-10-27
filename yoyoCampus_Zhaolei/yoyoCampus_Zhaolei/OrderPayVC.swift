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
