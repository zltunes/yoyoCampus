//
//  OrdersVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/22.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

public enum STATUS: String{
    case unPaid,unUsed,unRemarked,remarked,unRefund,refund
}

class OrdersVC: UIViewController,UITableViewDelegate,UITableViewDataSource,APIDelegate{

    @IBOutlet var table: UITableView!
    
    var api = YoYoAPI()
    
    ///存放订单
    var ordersArray:NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUpNavigationBar()
        self.setUpActions()
        self.setUpInitialLooking()
        self.setUpOnlineData()
    }

    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "我的订单", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        self.view.backgroundColor = Consts.grayView
        
//        模拟orders
        let filepath = NSBundle.mainBundle().pathForResource("data", ofType: "plist")
        let plistDic = NSMutableDictionary(contentsOfFile: filepath!)
        self.ordersArray = plistDic?.objectForKey("orders") as! NSMutableArray
        
        print("initialLooing:\(ordersArray.count)")
    }
    
    func setUpActions(){
        self.api.delegate = self
        
        let nib_orderCell = UINib(nibName: "OrderCell", bundle: nil)
        let nib_orderCellWithBtn = UINib(nibName: "OrderCellWithBtn", bundle: nil)
        self.table.registerNib(nib_orderCell, forCellReuseIdentifier: "OrderCell")
        self.table.registerNib(nib_orderCellWithBtn, forCellReuseIdentifier: "OrderCellWithBtn")
    }
    
    func setUpOnlineData(){
        
    }

    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat   {
        if(section == 5){
            return 0
        }else{
            return 20 * Consts.ratio
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let dict = ordersArray[indexPath.section] as! NSMutableDictionary
        let status = dict["status"] as! String
        if(status == "unPaid" || status == "unUsed" || status == "unRemarked"){
            return 310 * Consts.ratio
        }else {
            return 250 * Consts.ratio
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dic = ordersArray[indexPath.section] as! NSMutableDictionary
        let status = dic["status"] as! String
            if(status == "unPaid" || status == "unUsed" || status == "unRemarked"){
                let cell = self.table.dequeueReusableCellWithIdentifier("OrderCellWithBtn", forIndexPath: indexPath) as! OrderCellWithBtn
                cell.label_shopName?.text = "东大旅游吧"
                cell.label_productName?.text = "常州一日游"
                cell.label_totalPrice?.text = "1200"
                cell.label_totalCount?.text = "2"
                cell.orderImg.image = UIImage.init(named: "Commodity editor_btn_picture")
                
                switch(status){
                    case "unPaid":
                        cell.label_orderstatus?.text = "未付款"
                        cell.statusBtn.setTitle("付款", forState: .Normal)
                    break
                    
                    case "unUsed":
                        cell.label_orderstatus?.text = "未消费"
                        cell.statusBtn.setTitle("退款", forState: .Normal)
                    break
                    
                    case "unRemarked":
                        cell.label_orderstatus?.text = "未评价"
                        cell.statusBtn.setTitle("评价", forState: .Normal)
                    break
                    
                default:
                    break
                }
                return cell
            }else{
                let cell = self.table.dequeueReusableCellWithIdentifier("OrderCell", forIndexPath: indexPath) as! OrderCell
                cell.label_shopName?.text = "东大旅游吧"
                cell.label_productName?.text = "常州一日游"
                cell.label_totalPrice?.text = "1200"
                cell.label_totalCount?.text = "2"
                cell.orderImg.image = UIImage.init(named: "Commodity editor_btn_picture")
                switch(status){
                    case "remarked":
                        cell.label_orderStatus?.text = "已评价"
                        cell.label_orderStatus.textColor = Consts.lightGray
                    break
                    
                    case "unRefund":
                        cell.label_orderStatus?.text = "退款中"
                    break
                    
                    case "refund":
                        cell.label_orderStatus?.text = "已退款"
                        cell.label_orderStatus.textColor = Consts.lightGray
                    
                default:
                    break
                }
                return cell
                }
        return UITableViewCell()
        }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.table.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = OrderDetailVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func didReceiveJsonResults(json: JSON, tag: String) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
