//
//  extensionCALayer.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/24.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit

extension CALayer {
    var borderUIColor: UIColor {
        get {
            return UIColor(CGColor: self.borderColor!)
        }
        set {
            self.borderColor = newValue.CGColor
        }
    }
}

class extensionCALayer: NSObject {

}
