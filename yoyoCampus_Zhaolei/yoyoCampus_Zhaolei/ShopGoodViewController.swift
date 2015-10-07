//
//  ShopGoodViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/7.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class ShopGoodViewController: UIViewController {

    @IBOutlet var photoImgView: UIImageView!
    
    @IBOutlet var goodNameLabel: UILabel!
    
    @IBOutlet var roundBtn: UIButton!

    @IBOutlet var shopNameBtn: UIButton!
    
    @IBOutlet var originPriceLabel: UILabel!
    
    @IBOutlet var presentPriceLabel: UILabel!
    
    @IBOutlet var interestCountLabel: UILabel!
    
    @IBOutlet var soldCountLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var detailBtn: UIButton!
    
    @IBOutlet var remarkBtn: UIButton!
    
    @IBOutlet var horizontalScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigaitonBar()
        self.setUpInitialLooking()
        self.setUpActions()
        self.setUpOnlineData()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavigaitonBar(){
        Consts.setUpNavigationBarWithBackButton(self, title: "详情", backTitle: "<")
        let shareBtnItem = UIBarButtonItem(image: UIImage(named: "xiangqing_status bar_share"), style: UIBarButtonItemStyle.Plain, target: self, action: "Share")
        shareBtnItem.tintColor = Consts.white
        self.navigationItem.rightBarButtonItem = shareBtnItem
    }
    
    func setUpInitialLooking(){
        let newWidth = self.view.frame.width
        
        self.view.backgroundColor = Consts.grayView
        
        self.goodNameLabel.text = "恒通驾校报名"
        
        self.roundBtn.layer.cornerRadius = self.roundBtn.frame.width/2
        
        self.shopNameBtn.titleLabel?.text = "恒通"
        
        let attributedText = NSAttributedString(string: "¥ 5330", attributes: [NSStrikethroughStyleAttributeName: 1])//0表示不显示删除线，1表示显示删除线
        self.originPriceLabel.attributedText = attributedText
        
        self.presentPriceLabel.text = "¥ 4330"
        
        self.interestCountLabel.text = "10 人感兴趣"
        
        self.soldCountLabel.text = "已售 10"
        
        self.timeLabel.text = "2015-09-02"
        
        
    }
    
    func setUpActions(){
        
    }
    
    func setUpOnlineData(){
        
    }
    
    func goback(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func share(){
        
    }

}
