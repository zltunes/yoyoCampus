//
//  IntrolVC.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/11/30.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

class IntrolVC: UIViewController{

    @IBOutlet var scroll: UIScrollView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoMain(sender: UIButton) {
        self.presentViewController(AppDelegate.tabBarController, animated: false, completion: nil)
    }
    

}
