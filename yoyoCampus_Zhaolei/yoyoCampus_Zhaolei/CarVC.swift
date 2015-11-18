//
//  CarVC.swift
//  YouYouSchool-iOS
//
//  Created by 浩然 on 15/10/31.
//  Copyright © 2015年 浩然. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CarVC: UIViewController {

    var categoryName = NSString()
    var labelName = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
     
        Alamofire.request(.GET, "http://api2.hloli.me:9001/v1.0/label/",parameters: ["category":categoryName],headers:httpHeader).responseJSON{
            response in
            let json = JSON(response.result.value!)
            for(var count = 0 ; count < json["label"].count ; count++){
                var name = json["label",count].stringValue
                self.labelName.addObject(name)
            }
            print(self.labelName)
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
