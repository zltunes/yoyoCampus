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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUpNavigationBar()
        self.setUpInitialLooking()
        self.setUpActions()
        self.setUpOnlineData()
    }

    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "我的订单", backTitle: "<")
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
