//
//  customConst.swift
//  MasterTao
//
//  Created by DuZhiXia on 15/7/31.
//  Copyright (c) 2015年 Thanatos. All rights reserved.
//

import UIKit
import AVFoundation

class Consts {
    ///屏幕比例
    static let ratio : CGFloat = UIScreen.mainScreen().bounds.width / 720
    
    /*********************************************/
    //字体
    /*********************************************/

    
    ///9号系统字体
    static let ft9 = UIFont.systemFontOfSize(9)
    
    ///10号系统字体
    static let ft10 = UIFont.systemFontOfSize(10)
    
    ///11号系统字体
    static let ft11 = UIFont.systemFontOfSize(11)
    
    ///12号系统字体
    static let ft12 = UIFont.systemFontOfSize(12)
    
    ///13号系统字体
    static let ft13 = UIFont.systemFontOfSize(13)
    
    ///14号系统字体
    static let ft14 = UIFont.systemFontOfSize(14)
    
    ///15号系统字体
    static let ft15 = UIFont.systemFontOfSize(15)
    
    ///16号系统字体
    static let ft16 = UIFont.systemFontOfSize(16)
    
    ///17号系统字体
    static let ft17 = UIFont.systemFontOfSize(17)
    
    ///18号系统字体
    static let ft18 = UIFont.systemFontOfSize(18)
    
    ///20号系统字体
    static let ft20 = UIFont.systemFontOfSize(20)
    
    ///24号系统字体
    static let ft24 = UIFont.systemFontOfSize(24)
    
    ///9号系统字体高度,用于计算行高
    static let hoFt9 : CGFloat = 11.0
    
    ///10号系统字体高度,用于计算行高
    static let hoFt10 : CGFloat = 12.0
    
    ///11号系统字体高度,用于计算行高
    static let hoFt11 : CGFloat = 13.5
    
    ///12号系统字体高度,用于计算行高
    static let hoFt12 : CGFloat = 14.0
    
    ///13号系统字体高度,用于计算行高
    static let hoFt13 : CGFloat = 16.0
    
    ///14号系统字体高度,用于计算行高
    static let hoFt14 : CGFloat = 17.0
    
    ///15号系统字体高度,用于计算行高
    static let hoFt15 : CGFloat = 18.0
    
    ///16号系统字体高度,用于计算行高
    static let hoFt16 : CGFloat = 19.5
    
    ///18号系统字体高度,用于计算行高
    static let hoFt18 : CGFloat = 21.5
    
    ///24号系统字体高度,用于计算行高
    static let hoFt24 : CGFloat = 29.0
    
    /*********************************************/
    //间距
    /*********************************************/
    
    ///行间距,用于计算行高
    static let lineSpace : CGFloat = 3.0
    
    ///按钮圆角半径
    static let radius : CGFloat = 10.0 * Consts.ratio
    
    ///custom alert圆角半径
    static let alertRadius : CGFloat = 15 * Consts.ratio
    
    ///表格分割线缩进
    static let tableSeperatorEdge = UIEdgeInsets(top: 0, left: 10 * Consts.ratio, bottom: 0, right: 10 * Consts.ratio)
    
    /*********************************************/
    //颜色
    /*********************************************/
    
    ///主色调绿色,RGB:82,197,176,alpha = 1
    static let tintGreen = UIColor(red: 82 / 255, green: 197 / 255, blue: 176 / 255, alpha: 1)
    
    ///悬浮按钮橙色,RGB:248,186,80,alpha = 1
    static let btnOrange = UIColor(red: 248 / 255, green: 186 / 255, blue: 80 / 255, alpha: 1)
    
    ///灰色背景,RGB:228,228,228,alpha = 1
    static let grayView = UIColor(red: 239 / 255, green: 239 / 255, blue: 238 / 255, alpha: 1)
    
    ///浅灰色cell背景,RGB:241,243,245,alpha = 1
    static let lightCellBkg = UIColor(red: 241 / 255, green: 243 / 255, blue: 245 / 255, alpha: 1)
    
    ///深灰色分割线,RGB:34,34,34,alpha = 1
    static let darkGray = UIColor(red: 34 / 255, green: 34 / 255, blue: 34 / 255, alpha: 1)
    
    ///浅灰色字体,RGB:102,102,102,alpha = 1
    static let lightGray = UIColor(red: 102 / 255, green: 102 / 255, blue: 102 / 255, alpha: 1)
    
    ///高亮灰色字体,RGB:102,102,102,alpha = 0.5
    static let highlightedLightGray = UIColor(red: 102 / 255, green: 102 / 255, blue: 102 / 255, alpha: 0.5)
    
    ///标题文字颜色
    static let title = UIColor.whiteColor()
    
    ///各种文本的placeholder颜色
    static let holderGray = UIColor(red: 201 / 255, green: 201 / 255, blue: 206 / 255, alpha: 1)
    
    ///按钮文字颜色
    static let btnTitleColor = UIColor.whiteColor()
    
    ///白色
    static let white = UIColor.whiteColor()
    
    ///黑色
    static let black = UIColor.blackColor()
    
    /*********************************************/
    //地址
    /*********************************************/
    
    static let mainUrl = "http://api2.hloli.me:9001"
    
    /*********************************************/
    //动画相关
    /*********************************************/
    
    ///动画持续时间
    static let animeDuration = 0.2

    /*********************************************/
    //乱七八糟的类方法
    /*********************************************/

    ///把数据变成人民币格式,两位小数点
    class func formatNumber(str : NSString)-> String?{
        let numFormat = NSNumberFormatter()
        numFormat.numberStyle = .CurrencyStyle
        let num = NSNumber(double: str.doubleValue)
        if(numFormat.stringFromNumber(num) == nil){
            print("not a number")
        }
        var tmp : NSString = numFormat.stringFromNumber(num)!
        tmp = tmp.stringByReplacingOccurrencesOfString("$", withString: "￥")
        return tmp as String
    }
    
    ///UI偷懒用,构造一个frame紧贴文字边缘的label
    class func setUpLabel(title : String!, color : UIColor!, font : UIFont!, x : CGFloat!, y : CGFloat!,centerX : CGFloat?)-> UILabel!{
        let label = UILabel()
        label.text = title
        label.font = font
        label.sizeToFit()
        label.textColor = color
        label.frame = CGRect(x: x, y: y, width: label.frame.width, height: label.frame.height)
        if(centerX != nil){
            label.center.x = centerX!
        }
        return label
    }
    ///UI偷懒用，构造一个普通圆角按钮
    class func setUpNormalBtn(title:String!,frame:CGRect!,font:UIFont!,tintColor:UIColor!)->UIButton{
        let btn = UIButton(type: .System)
        btn.setTitle(title, forState: .Normal)
        btn.frame = frame
        btn.titleLabel?.font = font
        btn.tintColor = tintColor
//        btn.sizeToFit()
        return btn
    }
    ///UI偷懒用,构造一个颜色为主题颜色,字体为设定的按钮字体的圆角按钮
    class func setUpButton(title : String!,frame: CGRect!,font: UIFont! ,radius : CGFloat)->UIButton{
        let btn = UIButton(frame: frame)
        btn.backgroundColor = Consts.tintGreen
        btn.setTitle(title, forState: .Normal)
        btn.setTitleColor(Consts.btnTitleColor, forState: .Normal)
        btn.setTitleColor(Consts.highlightedLightGray, forState: .Highlighted)
        btn.titleLabel?.font = font
        btn.layer.cornerRadius = radius
        btn.layer.masksToBounds = true
        return btn
    }
    
    ///UI偷懒用,构造一个frame紧贴文字边缘的label,文字支持多行
    class func setUpAttributedLabel(text : String,lineSpace : CGFloat!, color : UIColor!, font : UIFont!, x : CGFloat!, y : CGFloat!, width : CGFloat!)-> UILabel{
        let label = UILabel()
        label.frame = CGRect(x: x, y: y, width: width, height: 20)
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        let attributes = [NSParagraphStyleAttributeName : paragraphStyle]
        let attributedStr = NSMutableAttributedString(string: text, attributes: attributes)
        label.numberOfLines = 0
        label.textColor = color
        label.font = font
        label.lineBreakMode = .ByWordWrapping
        label.attributedText = attributedStr
        label.sizeToFit()
        return label
    }
    ///UI偷懒用，构造一个UITextField
    class func setUpUITextField(frame:CGRect,origin_X:CGFloat,font:UIFont,textColor:UIColor,placeholder:String) -> UITextField{
        let textField = UITextField(frame: frame)
        textField.frame.origin.x = origin_X
        textField.font = font
        textField.textColor = textColor
        textField.placeholder = placeholder
        return textField
    }
    
    
    ///UI偷懒用，构造一个UIView
    class func setUpUIView(frame:CGRect!,cornerRadius:CGFloat!,maskToBounds:Bool!,backColor:UIColor)->UIView{
        let view = UIView(frame: frame)
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = maskToBounds
        view.backgroundColor = backColor
        return view
    }
    ///将服务器端返回的Unicode编码的文字转成UTF8String
    class func unicodeStringDecode(originString: NSString)->NSString{
        let tmp1 : NSString = originString.stringByReplacingOccurrencesOfString("\\u", withString: "\\U")
        let tmp2 : NSString = tmp1.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
        let tmp3 : NSString = "\"" + (tmp2 as String) + "\""
        let tmpData : NSData = tmp3.dataUsingEncoding(NSUTF8StringEncoding)!
        let returnStr : NSString = NSPropertyListSerialization.propertyListFromData(tmpData, mutabilityOption: NSPropertyListMutabilityOptions.Immutable, format: nil, errorDescription: nil )as! NSString
        return returnStr.stringByReplacingOccurrencesOfString("\\r\\n", withString: "\n")
    }
    
    ///检查输入密码是否符合要求(仅检查位数)
    class func checkPassword(password:NSString)->Bool{
        let minLength = 6
        let maxLength = 32
        
        let cPassword : NSString = password
        var passwordOK = true
        if(cPassword.length < minLength)||(cPassword.length > maxLength){
            passwordOK = false
        }
        return passwordOK
    }
    
    ///检查手机号是否符合要求(检查是否纯数字以及位数)
    class func checkPhoneNum(phoneNum:String)->Bool{
        let phone : String = phoneNum
        var phoneOK = true
        for i in phone.characters{
            if !(i >= "0")&&(i <= "9"){
                phoneOK = false
            }
        }
        return ((phone.characters.count == 11) && phoneOK)
    }
    
    ///服务器返回的字符数组拼接(tag常用)
    class func recoverTags(tags:NSArray)->String{
        var finalTagText = ""
        for var i = 0; i <= tags.count - 1; i++ {
            finalTagText += tags.objectAtIndex(i)as! String
            if(i < tags.count - 1){
                finalTagText += " , "
            }
        }
        return finalTagText
    }
    
    ///用颜色构造UIImage
    class func imageFromColor(color: UIColor,size: CGSize)->UIImage{
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        let rect = UIScreen.mainScreen().bounds
        CGContextFillRect(context, rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
        
    }
    
    ///判断摄像头是否开启
    class func isAVCaptureActive() ->Bool{
        let aDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
//        var inputError : NSErrorPointer = nil
        
        do{
           try AVCaptureDeviceInput(device: aDevice)
        }
        catch{
                return false
        }
        
        return true
    }
    
    ///设置带返回按钮的导航条,在调用的类中必须实现goBack()方法,否则不添加返回按钮
    class func setUpNavigationBarWithBackButton(vc:UIViewController,title:String?,backTitle:String?){
        var newFrame = UIScreen.mainScreen().bounds
        let newTitle = UILabel(frame: CGRect(x: newFrame.width / 3, y: 0, width: newFrame.width / 3, height: 20))
        newTitle.text = title
        newTitle.textAlignment = .Center
        newTitle.textColor = Consts.title
        vc.navigationItem.titleView = newTitle
        
        if(vc.respondsToSelector("goBack")&&(backTitle != nil)){
            let newItem = UIBarButtonItem(title: backTitle, style: .Plain, target: vc, action: "goBack")
            newItem.tintColor = Consts.title
            vc.navigationItem.leftBarButtonItem = newItem
        }else if(backTitle == nil){
            let pure = UIView(frame: CGRectMake(0, 0, 5, 5))
            pure.backgroundColor = UIColor.clearColor()
            let deleteItem = UIBarButtonItem(customView: pure)
            vc.navigationItem.leftBarButtonItem = deleteItem
        }
    }
    
    ///获取多行分布的字符串
    class func getAttributedString(str: NSString)->NSMutableAttributedString{
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = Consts.lineSpace
        let attributes = [NSParagraphStyleAttributeName : paragraphStyle]
        return NSMutableAttributedString(string: str as String, attributes: attributes)
    }
    
}