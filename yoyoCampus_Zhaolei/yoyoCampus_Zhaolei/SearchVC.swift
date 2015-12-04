//
//  SearchVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/11/16.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchVC: UIViewController,UITextFieldDelegate,APIDelegate,UITableViewDelegate,UITableViewDataSource {

    var searchTextField:UITextField! = UITextField()
    
    var api = YoYoAPI()
    
    var goodsURL:String = "\(Consts.mainUrl)/v1.0/goods/search/"
    ///商品搜索结果
    var goodsArray:[JSON] = []
    ///商品搜索展开,每展开一次page+1
    var goodsPage:Int = 1
    var goodsParam:[String:AnyObject] = ["":""]
    ///商品搜索结束标志
    var goodsFinished:Bool = false
    
    
    var idleURL:String = "\(Consts.mainUrl)/v1.0/idle/search/"
    ///闲置搜索结果
    var idleArray:[JSON] = []
    var idlePage:Int = 1
    var idleParam:[String:AnyObject] = ["":""]
    var idleFinished:Bool = false
    
    var shopURL:String = "\(Consts.mainUrl)/v1.0/shop/search/"
    ///商铺搜索结果
    var shopArray:[JSON] = []
    var shopPage:Int = 1
    var shopParam:[String:AnyObject] = ["":""]
    var shopFinished:Bool = false
    
    var plistDict = NSMutableDictionary()
    
    var searchHistoryArray:[String] = [""]
    
    var searchText:String = ""
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var hiddenImg: UIImageView!
    
    @IBOutlet var hiddenLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpInitialLooking()
        setUpNavigationBar()
        setUpActions()
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.hidesBottomBarWhenPushed = true
        super.viewWillAppear(animated)
    }
    
    func setUpInitialLooking(){
        self.view.backgroundColor = Consts.grayView
        self.table.backgroundColor = Consts.grayView
        self.setExtraCellLineHidden(self.table)
        
        plistDict = NSMutableDictionary(contentsOfFile: AppDelegate.filePath)!
//        searchHistoryArray = plistDict["search_history"] as! [String]
//        self.table.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func setExtraCellLineHidden(tableView:UITableView){
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = view
    }
    
    func setUpNavigationBar(){
        let newFrame = UIScreen.mainScreen().bounds
        
        let newItem = UIBarButtonItem(title: "<", style: .Plain, target: self, action: "goBack")
        newItem.tintColor = Consts.title
        self.navigationItem.leftBarButtonItem = newItem
        
        searchTextField.frame = CGRect(x: newFrame.width/6, y: 0, width: newFrame.width/1.5, height: 25)
        searchTextField.layer.cornerRadius = 3.0
        searchTextField.backgroundColor = UIColor(red: 7.0/255.0, green: 127.0/255.0, blue: 113.0/255.0, alpha: 1.0)
        searchTextField.placeholder = "请输入商品名、店铺名"
        searchTextField.textColor = Consts.white
        searchTextField.font = UIFont.systemFontOfSize(12.0)

        let searchIcon = UIImageView(image:Consts.imageFromColor(searchTextField.backgroundColor!, size: CGSize(width: 5, height: 25)))
        searchTextField.leftView = searchIcon
        searchTextField.leftViewMode = UITextFieldViewMode.Always
        self.navigationItem.titleView = searchTextField
        
        let rightItem = UIBarButtonItem(title: "搜索", style: .Plain, target: self, action: "search")
        rightItem.tintColor = Consts.title
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func setUpActions(){
        searchTextField.delegate = self
        api.delegate = self
        
        let nib1 = UINib(nibName: "SearchGoodsCell", bundle: nil)
        let nib2 = UINib(nibName: "SearchShopCell", bundle: nil)
        let nib3 = UINib(nibName: "SearchMoreCell", bundle: nil)
        self.table.registerNib(nib1, forCellReuseIdentifier: "SearchGoodsCell")
        self.table.registerNib(nib2, forCellReuseIdentifier: "SearchShopCell")
        self.table.registerNib(nib3, forCellReuseIdentifier: "SearchMoreCell")
    }
    
    func search(){
        if(self.searchTextField.text == ""){
            Tool.showErrorHUD("商品名、店铺名不可为空!")
            searchTextField.resignFirstResponder()
        }else{
            searchText = searchTextField.text!
            searchTextField.resignFirstResponder()
            goodsPage = 1
            setUpOnlineData("search_goods")
            setUpOnlineData("search_idle")
            setUpOnlineData("search_shop")
        }
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.searchTextField.resignFirstResponder()
    }
    
    func setUpOnlineData(tag:String){
        switch(tag){
            case "search_goods":
                goodsParam = ["keyword":searchText,"location":AppDelegate.selectedLocation,"page":goodsPage]
                api.httpRequest("GET", url:goodsURL, params: goodsParam, tag: "search_goods")
            break
            
            case "search_idle":
                idleParam = ["keyword":searchText,"location":AppDelegate.selectedLocation,"page":idlePage]
                api.httpRequest("GET", url: idleURL, params: idleParam, tag: "search_idle")
            break
            
            case "search_shop":
                shopParam = ["keyword":searchText,"location":AppDelegate.selectedLocation,"page":shopPage]
                api.httpRequest("GET", url: shopURL, params: shopParam, tag: "search_shop")
            break
            
        default:
            break
        }
    }
    
    func didReceiveJsonResults(json: JSON, tag: String) {
        switch(tag){
            case "search_goods":
                print(json)
                if(goodsPage == 1){
                    self.goodsArray = json["result"].array!
                }else if(goodsPage > 1 && json["result"].count > 0){
                    self.goodsArray += json["result"].array!
                }else if(goodsPage > 1 && json["result"].count == 0){
                    goodsFinished = true
                }
            break
            
            case "search_idle":
                print(json)
                if(idlePage == 1){
                    self.idleArray = json["result"].array!
                }else if(idlePage > 1 && json["result"].count > 0){
                    self.idleArray += json["result"].array!
                }else if(idlePage > 1 && json["result"].count == 0){
                    idleFinished = true
                }
            break
            
            case "search_shop":
                print(json)
                if(shopPage == 1){
                    self.shopArray = json["result"].array!
                }else if(shopPage > 1 && json["result"].count > 0){
                    self.shopArray += json["result"].array!
                }else if(shopPage > 1 && json["result"].count == 0){
                    shopFinished = true
                }
            break
            
        default:
            break
            
        }
        setEmptyMarkHidden()
        self.table.reloadData()
    }
    
    func setEmptyMarkHidden(){
        if(goodsArray.count == 0 && idleArray.count == 0 && shopArray.count == 0){
            hiddenImg.hidden = false
            hiddenLabel.hidden = false
        }else{
            hiddenImg.hidden = true
            hiddenLabel.hidden = true
        }
    }

    func textFieldDidBeginEditing(textField: UITextField) {
//            开始编辑时下拉菜单显示搜索历史
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            if(goodsArray.count > 2 && goodsPage == 1){
                return 3
            }else if(goodsArray.count < 3){
                return goodsArray.count
            }else{
//                goodsArray.count > 2 && goodsPage > 1
                return goodsArray.count+1
            }
            break
        
        case 1:
            if(idleArray.count>2 && idlePage == 1){
                return 3
            }else if(idleArray.count < 3){
                return idleArray.count
            }else{
                return idleArray.count+1
            }
            break
            
        case 2:
            if(shopArray.count>2 && shopPage == 1){
                return 3
            }else if(shopArray.count < 3){
                return shopArray.count
            }else{
                return shopArray.count+1
            }
            break
            
        default:
            return 1
            break
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(indexPath.section){
        case 0:
            if(goodsArray.count > 2 && goodsPage == 1){
                if(indexPath.row == 2){
                    return 31
                }else{
                    return 64
                }
            }else if(goodsArray.count > 2 && goodsPage > 1){
                if(indexPath.row == goodsArray.count){
                    return 31
                }else{
                    return 64
                }
            }else{
                return 64
            }
            break
    
        case 1:
            if(idleArray.count > 2 && idlePage == 1){
                if(indexPath.row == 2){
                    return 31
                }else{
                    return 64
                }
            }else if(idleArray.count > 2 && idlePage > 1){
                if(indexPath.row == idleArray.count){
                    return 31
                }else{
                    return 64
                }
            }else{
                return 64
            }
            break
            
        case 2:
            if(shopArray.count > 2 && shopPage == 1){
                if(indexPath.row == 2){
                    return 31
                }else{
                    return 64
                }
            }else if(shopArray.count > 2 && shopPage > 1){
                if(indexPath.row == shopArray.count){
                    return 31
                }else{
                    return 64
                }
            }else{
                return 64
            }
            break
            
        default:
            return 64
            break
            
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section){
        case 0:
            if(goodsArray.count>0){
            return "商品"
            }else{
                return ""
            }
            break
            
        case 1:
            if(idleArray.count > 0){
                return "闲置"
            }else{
                return ""
            }
            
            break
            
        case 2:
            if(shopArray.count > 0){
                return "店铺"
            }else{
                return ""
            }
            
            break
            
        default:
            return ""
            break
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section){
        case 0:
            if(goodsArray.count > 2 && goodsPage == 1){
                if(indexPath.row == 2){
                    let cell = tableView.dequeueReusableCellWithIdentifier("SearchMoreCell", forIndexPath: indexPath) as! SearchMoreCell
                        cell.iconImg.image = UIImage.init(named: "search_open_xxhdpi")
                        cell.statusLabel.text = "查看更多商品"
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("SearchGoodsCell", forIndexPath: indexPath) as! SearchGoodsCell
                    setUpSearchGoodsCell(cell, atIndexPath: indexPath)
                    return cell
                }
            }else if(goodsArray.count < 3){
                let cell = tableView.dequeueReusableCellWithIdentifier("SearchGoodsCell", forIndexPath: indexPath) as! SearchGoodsCell
                setUpSearchGoodsCell(cell, atIndexPath: indexPath)
                return cell
            }else{
                // if(goodsArray.count > 2 && goodsPage > 1)
                if(indexPath.row == goodsArray.count){
                    let cell = tableView.dequeueReusableCellWithIdentifier("SearchMoreCell", forIndexPath: indexPath) as! SearchMoreCell
                    if(goodsFinished){
                        cell.statusLabel.text = "已经没有更多商品"
                        cell.iconImg.image = UIImage.init(named: "search_close_xxhdpi")
                    }else{
                        cell.statusLabel.text = "查看更多商品"
                        cell.iconImg.image = UIImage.init(named: "search_open_xxhdpi")
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("SearchGoodsCell", forIndexPath: indexPath) as! SearchGoodsCell
                    setUpSearchGoodsCell(cell, atIndexPath: indexPath)
                    return cell
                }
            }
            break
            
        case 1:
            if(idleArray.count > 2 && idlePage == 1){
                if(indexPath.row == 2){
                    let cell = tableView.dequeueReusableCellWithIdentifier("SearchMoreCell", forIndexPath: indexPath) as! SearchMoreCell
                    cell.iconImg.image = UIImage.init(named: "search_open_xxhdpi")
                    cell.statusLabel.text = "查看更多闲置"
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("SearchGoodsCell", forIndexPath: indexPath) as! SearchGoodsCell
                    setUpSearchGoodsCell(cell, atIndexPath: indexPath)
                    return cell
                }
            }else if(idleArray.count < 3){
                let cell = tableView.dequeueReusableCellWithIdentifier("SearchGoodsCell", forIndexPath: indexPath) as! SearchGoodsCell
                setUpSearchGoodsCell(cell, atIndexPath: indexPath)
                return cell
            }else{
                // if(idleArray.count > 2 && idlePage > 1)
                if(indexPath.row == idleArray.count){
                    let cell = tableView.dequeueReusableCellWithIdentifier("SearchMoreCell", forIndexPath: indexPath) as! SearchMoreCell
                    if(idleFinished){
                        cell.statusLabel.text = "已经没有更多闲置"
                        cell.iconImg.image = UIImage.init(named: "search_close_xxhdpi")
                    }else{
                        cell.statusLabel.text = "查看更多闲置"
                        cell.iconImg.image = UIImage.init(named: "search_open_xxhdpi")
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("SearchGoodsCell", forIndexPath: indexPath) as! SearchGoodsCell
                    setUpSearchGoodsCell(cell, atIndexPath: indexPath)
                    return cell
                }
            }

             
            
            break
            
        case 2:
            if(shopArray.count > 2 && shopPage == 1){
                if(indexPath.row == 2){
                    let cell = tableView.dequeueReusableCellWithIdentifier("SearchMoreCell", forIndexPath: indexPath) as! SearchMoreCell
                    cell.iconImg.image = UIImage.init(named: "search_open_xxhdpi")
                    cell.statusLabel.text = "查看更多店铺"
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("SearchShopCell", forIndexPath: indexPath) as! SearchShopCell
                    setUpSearchShopCell(cell, atIndexPath: indexPath)
                    return cell
                }
            }else if(shopArray.count < 3){
                let cell = tableView.dequeueReusableCellWithIdentifier("SearchShopCell", forIndexPath: indexPath) as! SearchShopCell
                setUpSearchShopCell(cell, atIndexPath: indexPath)
                return cell
            }else{
                // if(ShopArray.count > 2 && ShopPage > 1)
                if(indexPath.row == shopArray.count){
                    let cell = tableView.dequeueReusableCellWithIdentifier("SearchMoreCell", forIndexPath: indexPath) as! SearchMoreCell
                    if(shopFinished){
                        cell.statusLabel.text = "已经没有更多店铺"
                        cell.iconImg.image = UIImage.init(named: "search_close_xxhdpi")
                    }else{
                        cell.statusLabel.text = "查看更多店铺"
                        cell.iconImg.image = UIImage.init(named: "search_open_xxhdpi")
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("SearchShopCell", forIndexPath: indexPath) as! SearchShopCell
                    setUpSearchShopCell(cell, atIndexPath: indexPath)
                    return cell
                }
            }

            break
            
        default:
            return UITableViewCell()
            break
        }
    }
    
    func setUpSearchGoodsCell(cell:SearchGoodsCell,atIndexPath indexPath:NSIndexPath){
        if(indexPath.section == 0){
            let goodJSON = goodsArray[indexPath.row]
            cell.label_goodsName.text = goodJSON["name"].string!
            let price = Float(goodJSON["price"].int!)/100.00
            cell.label_price.text = "¥ \(price)"
            cell.label_shopName.text = goodJSON["shop_name"].string!
        }else{
            let idleJSON = idleArray[indexPath.row]
            cell.label_goodsName.text = idleJSON["name"].string!
            let price = Float(idleJSON["price"].int!)/100.00
            cell.label_price.text = "¥ \(price)"
            cell.label_shopName.text = idleJSON["user_name"].string!
            cell.label_hui.hidden = true
        }

    }
    
    func setUpSearchShopCell(cell:SearchShopCell,atIndexPath indexPath:NSIndexPath){
        let shopJSON = shopArray[indexPath.row]
        cell.label_shopName.text = shopJSON["name"].string!
        cell.label_mainSell.text = shopJSON["main"].string!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = self.table.cellForRowAtIndexPath(indexPath)
        switch(indexPath.section){
        case 0:
            if(cell!.isKindOfClass(SearchGoodsCell.self)){
                let vc = ShopGoodViewController()
                vc.goods_ID = goodsArray[indexPath.row]["goods_id"].string!
                self.navigationController?.pushViewController(vc, animated: true)
            }else if(cell!.isKindOfClass(SearchMoreCell)){
                if(goodsFinished){
                    goodsPage = 1
                    goodsFinished = false
                }else{
                    goodsPage += 1
                }
                setUpOnlineData("search_goods")
            }
            break
            
        case 1:
            if(cell!.isKindOfClass(SearchGoodsCell.self)){
                let vc = IdleGoodViewController()
                vc.idle_id = idleArray[indexPath.row]["idle_id"].string!
                self.navigationController?.pushViewController(vc, animated: true)
            }else if(cell!.isKindOfClass(SearchMoreCell)){
                if(idleFinished){
                    idlePage = 1
                    idleFinished = false
                }else{
                    idlePage += 1
                }
                setUpOnlineData("search_idle")
            }
            break
            
        case 2:
            if(cell!.isKindOfClass(SearchShopCell.self)){
                let vc = ShopGoodsVC()
                vc.shopID = shopArray[indexPath.row]["shop_id"].string!
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else if(cell!.isKindOfClass(SearchMoreCell)){
                if(shopFinished){
                    shopPage = 1
                    shopFinished = false
                }else{
                    shopPage += 1
                }
                setUpOnlineData("search_shop")
            }
            break
            
        default:
            break
            
        }

    }
    
    ///实现拖动时关闭键盘
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if(scrollView == self.table){
            self.searchTextField.resignFirstResponder()
        }
    }

}
