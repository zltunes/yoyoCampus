//
//  CustomNavigationController.swift
//  yoyoCampus
//
//  Created by DuZhiXia on 15/9/19.
//  Copyright © 2015年 DuZhiXia. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.setBackgroundImage(Consts.imageFromColor(Consts.tintGreen, size: self.navigationBar.frame.size), forBarMetrics: UIBarMetrics.Default)
        
        if (self.respondsToSelector("interactivePopGestureRecognizer")) {
            self.interactivePopGestureRecognizer!.delegate = nil
        }
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
