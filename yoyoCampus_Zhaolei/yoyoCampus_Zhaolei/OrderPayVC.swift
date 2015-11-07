//
//  OrderPayVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/27.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class OrderPayVC: UIViewController,APIDelegate {
    
    internal var order_ID:String = ""
    
    @IBOutlet var label_orderName: UILabel!
    
    @IBOutlet var label_totalPrice: UILabel!
    
    @IBOutlet var label_toPay: UILabel!
    
    @IBOutlet var label_discount: UILabel!
    
    @IBOutlet var btn_aliPay: UIButton!//tag:0

    @IBOutlet var btn_wechat: UIButton!//tag:1
    
    @IBOutlet var btn_confirmPay: UIButton!//tag:2
    
    var selectPayWay = 0
    
    var api = YoYoAPI()
    
    var orderPayURL:String = ""
    
    var detailURL:String = ""
    
    var chargeData:NSData = NSData()
    
    var chargeString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpNavigationBar()
         self.setUpActions()
        self.setUpInitialLooking()
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
        
        setUpOnlineData("detail")
        
        self.btn_wechat.setBackgroundImage(UIImage.init(named: "dingdan_btn_select"), forState: .Normal)
        self.btn_aliPay.setBackgroundImage(UIImage.init(named: "dingdan_btn_get"), forState: .Normal)
    }
    
    func setUpActions(){
        self.api.delegate = self
        
    }
    
    func setUpOnlineData(tag:String){
        switch(tag){
            case "detail":
                detailURL = "\(Consts.mainUrl)/v1.0/user/order/\(order_ID)/"
                api.httpRequest("GET", url: detailURL, params: nil, tag: "detail")
            break
            
            case "pay":
                orderPayURL = "\(Consts.mainUrl)/v1.0/user/order/pay/\(order_ID)/"
                var param = ["":""]
                if(selectPayWay == 0){
                    param = ["channel":"alipay"]
                }else{
                    param = ["channel":"wx"]
                }
                
                Alamofire.request(.POST,orderPayURL,parameters:param,headers:["access_token":AppDelegate.access_token],encoding: .JSON)
                    .responseJSON{  response in
                        if response.result.error == nil{
                            self.chargeData = try! NSJSONSerialization.dataWithJSONObject(response.result.value!, options: NSJSONWritingOptions())
                            self.chargeString = NSString(data: self.chargeData, encoding: NSUTF8StringEncoding)! as String
                            Pingpp.createPayment(self.chargeString, appURLScheme: "wxcd544705acc90854"){ (result, error) -> Void in
                                print("result:\(result)")
                                let vc = OrderDetailVC()
                                vc.order_ID = self.order_ID
                                self.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(vc, animated: true)
                                if error != nil {
                                    print("error:\(error.code.rawValue)")
                                    print("error:\(error.getMsg())")
                                }
                            }
                        }else{
                            //                        输出失败信息
                            print("post请求失败!\(response.result.error)")
                        }
                }

            break
            
        default:
            break
        }
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        switch(tag){
        case "detail":
            label_orderName.text = json["good","name"].string!
            let totalPrice = Float(json["total_price"].int!)/100.00
            let price = Float(json["good","price"].int!)/100.00
            let quantity = json["quantity"].int!
            label_totalPrice.text = "¥ \(price * Float(quantity))"
            label_toPay.text = "¥ \(totalPrice)"
            label_discount.text = "¥ \(price * Float(quantity) - totalPrice)"
            break
            
        default:
            break
        }
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
            setUpOnlineData("pay")
        default:
            break
        }
    }
    
}
