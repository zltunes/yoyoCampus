//
//  SelectLocationVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/11/19.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectLocationVC: UIViewController,UITableViewDelegate,UITableViewDataSource,APIDelegate{

    var api = YoYoAPI()
    
    var table:UITableView = UITableView()
    
    var locationURL:String = ""
    
    var locationArray:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationBar()
        self.setUpInitialLooking()
        self.setUpActions()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setExtraCellLineHidden(tableView:UITableView){
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = view
    }
    
    func setUpNavigationBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "选择校区", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        self.view.backgroundColor = Consts.grayView
        
        self.table.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.table.backgroundColor = Consts.grayView
        self.view.addSubview(self.table)
        
        self.setExtraCellLineHidden(self.table)
        
        setUpOnlineData("location")
    }
    
    func setUpActions(){
        self.api.delegate = self
        
        self.table.delegate = self
        self.table.dataSource = self
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.table.dequeueReusableCellWithIdentifier("locationCell")
        cell = UITableViewCell(style: .Value1, reuseIdentifier: "locationCell")
        cell!.textLabel?.text = self.locationArray[indexPath.row].string!
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.table.deselectRowAtIndexPath(indexPath, animated: true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setUpOnlineData(tag:String){
        if(tag == "location"){
            self.locationURL = "\(Consts.mainUrl)/v1.0/location/"
            api.httpRequest("GET", url: self.locationURL, params: nil, tag: "location")
        }
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        if(tag == "location"){
            self.locationArray = json["location"].array!
            self.table.reloadData()
        }
    }

}
