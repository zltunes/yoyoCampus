//
//  TestViewController.swift
//  yoyoCampus
//
//  Created by DuZhiXia on 15/9/17.
//  Copyright © 2015年 DuZhiXia. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    

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
        Consts.setUpNavigationBarWithBackButton(self, title: "测试页面", backTitle: "<")
    }
    
    func setUpInitialLooking(){
        let newWidth = self.view.frame.width
        let newHeight = self.view.frame.height
        
        self.view.backgroundColor = Consts.grayView
        
        let lbl = Consts.setUpLabel("我是测试狂魔", color: Consts.tintGreen, font: Consts.ft24, x: 0, y: 64 + 100 * Consts.ratio, centerX: newWidth / 2)
        self.view.addSubview(lbl)
//        print(lbl.frame)
        
        let btn1 = Consts.setUpButton("测试1", frame: CGRect(x: 50 * Consts.ratio, y: lbl.frame.maxY + 50 * Consts.ratio, width: newWidth - 50 * 2 * Consts.ratio, height: 96 * Consts.ratio), font: Consts.ft18, radius: Consts.radius)
        btn1.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        self.view.addSubview(btn1)
        
        let btn2 = Consts.setUpButton("测试2", frame: CGRect(x: 50 * Consts.ratio, y: btn1.frame.maxY + 50 * Consts.ratio, width: newWidth - 50 * 2 * Consts.ratio, height: 96 * Consts.ratio), font: Consts.ft18, radius: Consts.radius)
        btn2.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        self.view.addSubview(btn2)
    }
    
    func setUpActions(){
        
    }
    
    func setUpOnlineData(){
        
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func buttonClicked(sender:UIButton){
        if(sender.titleLabel?.text == "测试1"){
            let vc = MyUploadGoodsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(sender.titleLabel?.text == "测试2"){
            
        }
        
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
