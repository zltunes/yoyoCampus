
//
//  ConfirmOrderVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/27.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

class ConfirmOrderVC: UIViewController,APIDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource{

    ///需从ShopGoodViewController获取的数据:
    internal var goodName:String = ""//商品名称
    internal var quantity:Int = 1//商品数量
    internal var oldPrice:Float = 0.00//原价(单价)
    internal var discount:Float = 0.00//优惠卡金额
    internal var goodID:String = ""
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var remarkTextView: UITextView!
    
    @IBOutlet var submmitBtn: UIButton!//tag:10
    
    var api = YoYoAPI()
    
    var hasDiscountCard = false//有无优惠卡
    
    var orderCreateURL:String = ""
    
    var getDiscountCardURL:String = ""
    
    var remark:String = ""

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
        self.remarkTextView.text = "填写您的要求，让商家更好地提供服务"
        setUpOnlineData("getDiscountCard")
    }
    
    func setUpActions(){
        self.api.delegate = self
        self.remarkTextView.delegate = self
        
        let nib1 = UINib(nibName: "cellWithTwoBtns", bundle: nil)
        let nib2 = UINib(nibName: "twoLabelCell", bundle: nil)
        let nib3 = UINib(nibName: "OneBtnCell", bundle: nil)
        self.table.registerNib(nib1, forCellReuseIdentifier: "cellWithTwoBtns")
        self.table.registerNib(nib2, forCellReuseIdentifier: "twoLabelCell")
        self.table.registerNib(nib3, forCellReuseIdentifier: "OneBtnCell")
        
    }
    
    func setUpOnlineData(tag:String){
        switch(tag){
            case "orderCreate":
                self.orderCreateURL = "\(Consts.mainUrl)/v1.0/user/order/"
                if(remarkTextView.text == "填写您的要求，让商家更好地提供服务" || remarkTextView.text.isEmpty){
                    self.remark = ""
                }else{
                    self.remark = remarkTextView.text
                }
                let param = ["good_id":self.goodID,"quantity":self.quantity,"remark":self.remark]
                api.httpRequest("POST", url: self.orderCreateURL, params: param as? [String : AnyObject], tag: "orderCreate")
            break
            
            case "getDiscountCard":
                self.getDiscountCardURL = "\(Consts.mainUrl)/v1.0/card/"
                api.httpRequest("GET", url: getDiscountCardURL, params: nil, tag: "getDiscountCard")
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
            case "orderCreate":
                let orderID = json["order_id"]
                let vc = OrderPayVC()
                vc.order_ID = json["order_id"].string!
                self.navigationController?.pushViewController(vc, animated: true)
            break
            
            case "getDiscountCard":
                if(json["code"]==nil){
                    hasDiscountCard = true
                }else{
//                    两种情况：1、没卡 2、过期
                    hasDiscountCard = false
                }
                table.reloadData()
            break
            
        default:
            break
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 4
        }else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20 * Consts.ratio
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            switch(indexPath.row){
            case 0:
                let cell = self.table.dequeueReusableCellWithIdentifier("twoLabelCell") as! twoLabelCell
                cell.oldPriceLabel?.hidden = true
                cell.leftLabel?.text = self.goodName
                cell.presentPriceLabel?.text = "¥ \(self.oldPrice)"
                return cell
                break
                
            case 1:
                let cell = self.table.dequeueReusableCellWithIdentifier("cellWithTwoBtns") as!
                    cellWithTwoBtns
                cell.leftLabel?.text = "数量"
                cell.countLabel?.text = "\(quantity)"
                cell.minusBtn.setBackgroundImage(UIImage.init(named: "dingdan_btn_minus.png"), forState: .Normal)
                cell.minusBtn.enabled = true
                cell.minusBtn.tag = 0//数量-
                cell.minusBtn.addTarget(self, action: "btnClicked:", forControlEvents: .TouchUpInside)
                cell.plusBnt.setBackgroundImage(UIImage.init(named: "dingdan_btn_plus.png"), forState: .Normal)
                cell.plusBnt.tag = 1//数量+
                cell.plusBnt.addTarget(self, action: "btnClicked:", forControlEvents: .TouchUpInside)
                return cell
                break
                
            case 2:
                if(!self.hasDiscountCard){
//                    无卡
                let cell = self.table.dequeueReusableCellWithIdentifier("OneBtnCell") as!
                    OneBtnCell
                cell.leftLabel?.text = "使用万能优惠卡"
                cell.btn_operation.setTitle("获取", forState: .Normal)
                cell.btn_operation.addTarget(self, action: "btnClicked:", forControlEvents: .TouchUpInside)
                cell.btn_operation.tag = 2//获取
                return cell
                }else{
//                    有卡
                let cell = self.table.dequeueReusableCellWithIdentifier("cellWithTwoBtns") as!
                    cellWithTwoBtns
                cell.leftLabel?.text = "使用万能优惠卡"
                cell.minusBtn.hidden = true
                cell.countLabel.hidden = true
                cell.plusBnt.setBackgroundImage(UIImage.init(named: "dingdan_btn_get"), forState: .Normal)
                return cell
                }
                break
                
            case 3:
                let cell = self.table.dequeueReusableCellWithIdentifier("twoLabelCell", forIndexPath: indexPath) as! twoLabelCell
                cell.leftLabel?.text = "合计"
                if(!hasDiscountCard){
                    cell.oldPriceLabel?.hidden = true
                    cell.presentPriceLabel?.text = "¥ \(oldPrice * Float(quantity))"
                }else{
                    cell.presentPriceLabel?.text = "¥ \((oldPrice - discount) * Float(quantity))"
                    cell.presentPriceLabel.textColor = UIColor.redColor()
                    let attributeText = NSAttributedString(string: "¥ \(oldPrice * Float(quantity))", attributes: [NSStrikethroughStyleAttributeName:1])
                    cell.oldPriceLabel?.hidden = false
                    cell.oldPriceLabel?.attributedText = attributeText
                }
                return cell
                break
                
            default:
                break
            }
            
        }else{//section1
            let cell = self.table.dequeueReusableCellWithIdentifier("twoLabelCell", forIndexPath: indexPath) as! twoLabelCell
            cell.oldPriceLabel.hidden = true
            if(indexPath.row == 0){
                cell.leftLabel?.text = "绑定手机"
                cell.presentPriceLabel?.text = AppDelegate.tel
            }else{
                cell.leftLabel?.text = "所在校区"
                cell.presentPriceLabel?.text = AppDelegate.location
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        table.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if(self.remarkTextView.text == "填写您的要求，让商家更好地提供服务"){
            self.remarkTextView.text = ""
        }
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if(self.remarkTextView.text.isEmpty){
            self.remarkTextView.text = "填写您的要求，让商家更好地提供服务"
        }else{
            self.remark = self.remarkTextView.text!
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.remarkTextView.resignFirstResponder()
    }
    
    @IBAction func btnClicked(sender: UIButton) {
        switch(sender.tag){
        case 0://数量-
            if(self.quantity == 1){
                sender.enabled = false
            }else{
                self.quantity--
                self.table.reloadData()
            }
            break
            
        case 1://数量+
            self.quantity++
            self.table.reloadData()
            break
            
        case 2://获取优惠卡
            let vc = CouponViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 10://提交订单  
            setUpOnlineData("orderCreate")
            break
            
        default:
            break
        }
    
    }
    
    


}
