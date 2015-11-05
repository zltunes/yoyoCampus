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
    case unPaid,unUsed,unRemarked,remarked,refund
}

/*
unPaid:     1
unUsed:     2
unRemarked: 3
remarked:   4
refund:     0

*/

class OrdersVC: UIViewController,UITableViewDelegate,UITableViewDataSource,APIDelegate{

    @IBOutlet var table: UITableView!
    @IBOutlet var emptyLabel: UILabel!
    
    var api = YoYoAPI()
    
    var ordersViewURL:String = ""
    
    var ordersPage:Int = 1
    
    var ordersJSON:[JSON] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUpNavigationBar()
        self.setUpActions()
        self.setUpInitialLooking()
    }
    
    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "我的订单", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        self.view.backgroundColor = Consts.grayView
        
        self.table.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefreshing")
        
        self.table.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefreshing")
        
        setUpOnlineData("ordersView")

    }
    
    func headerRefreshing(){
        ordersPage = 1
        setUpOnlineData("ordersView")
    }
    
    func footerRefreshing(){
        ordersPage++
        setUpOnlineData("ordersView")
    }
    
    func setUpActions(){
        self.api.delegate = self
        
        let nib_orderCell = UINib(nibName: "OrderCell", bundle: nil)
        let nib_orderCellWithBtn = UINib(nibName: "OrderCellWithBtn", bundle: nil)
        self.table.registerNib(nib_orderCell, forCellReuseIdentifier: "OrderCell")
        self.table.registerNib(nib_orderCellWithBtn, forCellReuseIdentifier: "OrderCellWithBtn")
    }
    
    func setUpOnlineData(tag:String){
        switch(tag){
        case "ordersView":
            self.ordersViewURL = "\(Consts.mainUrl)/v1.0/user/orders/?page=\(ordersPage)"
            api.httpRequest("GET", url: ordersViewURL, params: nil, tag: "ordersView")
            break
            
        default:
            break
        }
    }

    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ordersJSON.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0
        }else{
            return 20 * Consts.ratio
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = ordersJSON[indexPath.section]["status"].int!
        if(status == 1 || status == 2 || status == 3){
            return 310 * Consts.ratio
        }else {
            return 250 * Consts.ratio
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(ordersJSON.count != 0){
        let orderJSON = ordersJSON[indexPath.section]
        let status = orderJSON["status"].int!
            if(status == 1 || status == 2 || status == 3){
                let cell = self.table.dequeueReusableCellWithIdentifier("OrderCellWithBtn", forIndexPath: indexPath) as! OrderCellWithBtn
                cell.label_shopName?.text = orderJSON["shop","name"].string!
                cell.label_productName?.text = orderJSON["good","name"].string!
                let price = Float(orderJSON["total_price"].int!)/100.00
                cell.label_totalPrice?.text = "\(price)"
                let quantity = orderJSON["quantity"].int!
                cell.label_totalCount?.text = "\(quantity)"
                cell.orderImg.sd_setImageWithURL(orderJSON["good","image"].URL!, placeholderImage: UIImage.init(named: "Commodity editor_btn_picture"))
                
                switch(status){
                    case 1:
                        cell.label_orderstatus?.text = "未付款"
                        cell.statusBtn.setTitle("付款", forState: .Normal)
                    break
                    
                    case 2:
                        cell.label_orderstatus?.text = "未消费"
                        cell.statusBtn.setTitle("退款", forState: .Normal)
                    break
                    
                    case 3:
                        cell.label_orderstatus?.text = "未评价"
                        cell.statusBtn.setTitle("评价", forState: .Normal)
                    break
                    
                default:
                    break
                }
                cell.statusBtn.tag = indexPath.section
                cell.statusBtn.addTarget(self, action: "btnClicked:", forControlEvents: .TouchUpInside)
                return cell
            }else{
                let cell = self.table.dequeueReusableCellWithIdentifier("OrderCell", forIndexPath: indexPath) as! OrderCell
                cell.label_shopName?.text = orderJSON["shop","name"].string!
                cell.label_productName?.text = orderJSON["good","name"].string!
                let price = orderJSON["total_price"].int!
                cell.label_totalPrice?.text = "\(price)"
                let quantity = orderJSON["quantity"].int!
                cell.label_totalCount?.text = "\(quantity)"
                cell.orderImg.image = UIImage.init(named: "Commodity editor_btn_picture")
                switch(status){
                    case 4:
                        cell.label_orderStatus?.text = "已评价"
                        cell.label_orderStatus.textColor = Consts.lightGray
                    break
                    
                    case 0:
                        cell.label_orderStatus?.text = "已退款"
                        cell.label_orderStatus.textColor = Consts.lightGray
                    
                default:
                    break
                }
                return cell
                }
        }else{
            return UITableViewCell()
        }
        }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.table.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = OrderDetailVC()
        vc.order_ID = ordersJSON[indexPath.section]["_id"].string!
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func didReceiveJsonResults(json: JSON, tag: String) {
        switch(tag){
        case "ordersView":
            if(json["orders"].count == 0 && ordersPage > 1){
                emptyLabel.hidden = true
//                刷新无更多数据
                ordersPage--
                table.footer.endRefreshingWithNoMoreData()
            }else if(json["orders"].count > 0 && ordersPage > 1){
                emptyLabel.hidden = true
                ordersJSON+=json["orders"].array!
            }else if(json["orders"].count == 0 && ordersPage == 1){
                emptyLabel.hidden = false
            }else if(json["orders"].count > 0 && ordersPage == 1){
                emptyLabel.hidden = true
                ordersJSON = json["orders"].array!
            }
            table.reloadData()
            table.header.endRefreshing()
            table.footer.endRefreshing()
            break
            
        default:
            break
        }
    }
    
    func btnClicked(sender:UIButton){
        switch(sender.titleLabel!.text!){
            case "付款":
                let vc = OrderPayVC()
                vc.order_ID = ordersJSON[sender.tag]["_id"].string!
                self.navigationController?.pushViewController(vc, animated: true)
            break
            
            case "退款":
                
            break
            
            case "评价":
                let vc = remarkVC()
                vc.order_id = ordersJSON[sender.tag]["_id"].string!
                self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
