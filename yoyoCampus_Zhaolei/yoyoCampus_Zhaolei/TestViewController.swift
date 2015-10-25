//
//  TestViewController.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/21.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnClicked(sender: UIButton) {
        let title:String = (sender.titleLabel?.text)!
        var vc = UIViewController()
        switch(title){
            case "闲置商品发布":
                vc = MyUploadGoodsViewController()
            break
            
            case "个人闲置":
                vc = IdleGoodViewController()
            break
            
            case "店铺商品":
                vc = ShopGoodViewController()
            break
            
            case "个人中心":
                vc = PersonCenterVC()
            break
            
        default:
            break
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
