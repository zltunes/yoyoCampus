//
//  AppDelegate.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/9/21.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import SwiftyJSON

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
    ///用户登录状态
    static var isLogin:Bool = false
    ///用户手机号
    static var tel:String = ""
    ///access_token
    static var access_token:String = ""
    ///沙盒，存储isLogin\tel\access_token
    static var filePath:String = ""
    
    static var wechat_openid:String = ""
    
    static var wechat_accessToken:String = ""
    
    static var wechat_name:String = ""
    
    static var wechat_photoURL:NSURL = NSURL()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        //键盘基本设置
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().disableInViewControllerClass(PersonalInfoViewController)
//        IQKeyboardManager.sharedManager().disableInViewControllerClass(PersonalInfomationViewController)
        
        //访问沙盒文件PersonInfo.plist
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as
            NSArray
        let documentDirectory = paths.objectAtIndex(0) as! NSString
        AppDelegate.filePath = documentDirectory.stringByAppendingPathComponent("zhaolei.plist")
        
        let  plistDict = NSMutableDictionary(contentsOfFile:AppDelegate.filePath)
        
        if plistDict == nil{
//            为.plist创建字典
            var dict:NSMutableDictionary = ["access_token":""]
            dict.setObject(false, forKey: "isLogin")
            dict.setObject("", forKey: "tel")
            dict.setObject("", forKey: "photo")
            dict.setObject("", forKey: "name")
            dict.setObject("", forKey: "enroll_year")
            dict.setObject("", forKey: "location")
            dict.setObject(0, forKey: "weibo_bind")
            dict.setObject(0, forKey: "weixin_bind")
            
            dict.writeToFile(AppDelegate.filePath, atomically:false)
        }else{
            AppDelegate.isLogin = plistDict?.valueForKey("isLogin") as! Bool
            AppDelegate.tel = plistDict?.valueForKey("tel") as! String
            AppDelegate.access_token = plistDict?.valueForKey("access_token") as! String
        }
        
        print("isLogin:\(AppDelegate.isLogin)")
        print("tel:\(AppDelegate.tel)")
        print("access_token:\(AppDelegate.access_token)")
        
        
//        设置友盟Appkey
        UMSocialData.setAppKey("5625ea6667e58e2328001e3f")
        
//         设置微信AppId、appSecret，分享url
//        URL必须为http链接，如果设置为nil则默认为友盟官网链接
        UMSocialWechatHandler.setWXAppId("wxcd544705acc90854", appSecret: "4b855c5546bf62fa20ec07af7e5ffc2d", url: "http://baidu.com")
        
//        设置qZone appid
        UMSocialQQHandler.setQQWithAppId("1104847133", appKey: "KgBQDT8eiZelAyIU", url: "http://baidu.com")
        
        
//        对未安装客户端进行隐藏 
        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline])
        
        
        return true
    }

//      微信系统回调方法
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

