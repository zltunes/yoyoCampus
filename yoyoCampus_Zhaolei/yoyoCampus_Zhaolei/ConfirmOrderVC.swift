
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

    @IBOutlet var table: UITableView!
    
    @IBOutlet var remarkTextView: UITextView!
    
    @IBOutlet var submmitBtn: UIButton!//tag:10
    
    
    var api = YoYoAPI()
    
    var hasDiscountCard = true//有无优惠卡
    
    var useDiscountCard = true//使用优惠卡
    
    var count = 1//商品数量
    
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
        self.remarkTextView.text = "填写您的要求，让商家更好地提供服务"
    }
    
    func setUpActions(){
        self.api.delegate = self
        
        let nib1 = UINib(nibName: "cellWithTwoBtns", bundle: nil)
        let nib2 = UINib(nibName: "twoLabelCell", bundle: nil)
        let nib3 = UINib(nibName: "OneBtnCell", bundle: nil)
        self.table.registerNib(nib1, forCellReuseIdentifier: "cellWithTwoBtns")
        self.table.registerNib(nib2, forCellReuseIdentifier: "twoLabelCell")
        self.table.registerNib(nib3, forCellReuseIdentifier: "OneBtnCell")
        
    }
    
    func setUpOnlineData(){
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        
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
                cell.leftLabel?.text = "恐龙园两日游"
                cell.presentPriceLabel?.text = "¥ 600"
                return cell
                break
                
            case 1:
                let cell = self.table.dequeueReusableCellWithIdentifier("cellWithTwoBtns") as!
                    cellWithTwoBtns
                cell.leftLabel?.text = "数量"
                cell.countLabel?.text = "\(count)"
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
                cell.btn_operation.tag = 2//获取
                return cell
                }else{
//                    有卡
                let cell = self.table.dequeueReusableCellWithIdentifier("cellWithTwoBtns") as!
                    cellWithTwoBtns
                cell.leftLabel?.text = "使用万能优惠卡"
                cell.minusBtn.hidden = true
                cell.countLabel.hidden = true
                    if(!useDiscountCard){
                        cell.plusBnt.setBackgroundImage(UIImage.init(named: "dingdan_btn_select"), forState: .Normal)
                    }else{
                        cell.plusBnt.setBackgroundImage(UIImage.init(named: "dingdan_btn_get"), forState: .Normal)
                    }
                return cell
                }
                break
                
            case 3:
                let cell = self.table.dequeueReusableCellWithIdentifier("twoLabelCell", forIndexPath: indexPath) as! twoLabelCell
                cell.leftLabel?.text = "合计"
                if(!useDiscountCard){
                    cell.oldPriceLabel?.hidden = true
                    cell.presentPriceLabel?.text = "¥ 1200"
                }else{
                    cell.presentPriceLabel?.text = "¥ 1000"
                    cell.presentPriceLabel.textColor = UIColor.redColor()
                    let attributeText = NSAttributedString(string: "¥ 1200", attributes: [NSStrikethroughStyleAttributeName:1])
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
                cell.presentPriceLabel?.text = "15651907759"
            }else{
                cell.leftLabel?.text = "所在校区"
                cell.presentPriceLabel?.text = "东南大学九龙湖校区"
            }
            
            return cell
        }
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0 && indexPath.row == 2){
            self.table.deselectRowAtIndexPath(indexPath, animated: true)
            //优惠卡一栏
            if(!self.useDiscountCard){
                self.useDiscountCard = true
            }else{
                self.useDiscountCard = false
            }
            self.table.reloadData()
        }else{
            self.table.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {

    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if(self.remarkTextView.text == "填写您的要求，让商家更好地提供服务"){
            print("hahaha")
            self.remarkTextView.text = ""
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.remarkTextView.resignFirstResponder()
    }
    
    @IBAction func btnClicked(sender: UIButton) {
        switch(sender.tag){
        case 0://数量-
            if(self.count == 1){
                sender.enabled = false
            }else{
                self.count--
                self.table.reloadData()
            }
            break
            
        case 1://数量+
            self.count++
            self.table.reloadData()
            break
            
        case 2://获取优惠卡
            let vc = CouponViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 10://提交订单  
            let vc = OrderPayVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    
    }
    
    


}
