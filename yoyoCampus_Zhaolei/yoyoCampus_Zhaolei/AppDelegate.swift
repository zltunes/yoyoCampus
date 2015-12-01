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
    
    var introl_viewed:Bool = true
    ///用户登录状态
    static var isLogin:Bool = false
    ///用户手机号
    static var tel:String = ""
    ///用户所在校区
    static var location:String = ""
    ///access_token
    static var access_token:String = "guest"
    ///沙盒，存储isLogin\tel\access_token
    static var filePath:String = ""
    
    static var wechat_openid:String = ""
    
    static var wechat_accessToken:String = ""
    
    static var wechat_name:String = ""
    
    static var wechat_photoURL:NSURL = NSURL()
    
    
//    最底层：tabbarController
    static var tabBarController = UITabBarController()
    
//    三个tab各自的navigationController
    static var navigationController_home = CustomNavigationController()
    static var navigationController_shop = CustomNavigationController()
    static var navigationController_my = CustomNavigationController()
    
//    三个rootViewController
    var homeVC = RootVC()
    var shopVC = ShopVC()
    var myVC = PersonCenterVC()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        //键盘基本设置
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().disableInViewControllerClass(PersonalInfoViewController)
        
        //访问沙盒文件PersonInfo.plist
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as
            NSArray
        let documentDirectory = paths.objectAtIndex(0) as! NSString
        AppDelegate.filePath = documentDirectory.stringByAppendingPathComponent("ihui.plist")
        
        let plistDict = NSMutableDictionary(contentsOfFile:AppDelegate.filePath)
        
        if plistDict == nil{
//            为.plist创建字典
            var dict:NSMutableDictionary = ["access_token":"guest"]
            dict.setObject(false, forKey: "isLogin")
            dict.setObject("", forKey: "tel")
            dict.setObject("", forKey: "photo")
            dict.setObject("", forKey: "name")
            dict.setObject("", forKey: "enroll_year")
            dict.setObject("", forKey: "location")
            dict.setObject(0, forKey: "weibo_bind")
            dict.setObject(0, forKey: "weixin_bind")
            dict.setObject([""], forKey: "search_history")
            dict.writeToFile(AppDelegate.filePath, atomically:false)
            
            self.introl_viewed = false
           
        }else{
            AppDelegate.isLogin = plistDict?.valueForKey("isLogin") as! Bool
            AppDelegate.tel = plistDict?.valueForKey("tel") as! String
            AppDelegate.access_token = plistDict?.valueForKey("access_token") as! String
            AppDelegate.location = plistDict?.valueForKey("location") as! String
        }
        
        print("isLogin:\(AppDelegate.isLogin)")
        print("tel:\(AppDelegate.tel)")
        print("access_token:\(AppDelegate.access_token)")
        print("location:\(AppDelegate.location)")
        
        
//        设置友盟Appkey
        UMSocialData.setAppKey("5625ea6667e58e2328001e3f")
        
//         设置微信AppId、appSecret，分享url
//        URL必须为http链接，如果设置为nil则默认为友盟官网链接
        UMSocialWechatHandler.setWXAppId("wxcd544705acc90854", appSecret: "4b855c5546bf62fa20ec07af7e5ffc2d", url: "http://baidu.com")
        
//        设置qZone appid
        UMSocialQQHandler.setQQWithAppId("1104847133", appKey: "KgBQDT8eiZelAyIU", url: "http://baidu.com")
        
        
//        对未安装客户端进行隐藏 
        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline])
        
        self.homeVC.view.backgroundColor = UIColor.redColor()
        self.homeVC.tabBarItem.image = UIImage.init(named: "my center_btn_shop_n_xxhdpi")
        self.homeVC.tabBarItem.selectedImage = UIImage.init(named: "my center_btn_shop_p_xxhdpi")
        self.homeVC.title = "主页"
        
        self.shopVC.view.backgroundColor = UIColor.yellowColor()
        self.shopVC.tabBarItem.image = UIImage.init(named: "homepage_btn_shop_n_xxhdpi")
        self.shopVC.tabBarItem.selectedImage = UIImage.init(named: "homepage_btn_shop_p_xxhdpi")
        self.shopVC.title = "商家"
        
        self.myVC.tabBarItem.image = UIImage.init(named: "my center_btn_me_n_xxhdpi")
        self.myVC.tabBarItem.selectedImage = UIImage.init(named: "my center_btn_me_p_xxhdpi")
        self.myVC.title = "个人"
        
        AppDelegate.navigationController_home = CustomNavigationController(rootViewController: homeVC)
        AppDelegate.navigationController_shop = CustomNavigationController(rootViewController: shopVC)
        AppDelegate.navigationController_my = CustomNavigationController(rootViewController: myVC)

        AppDelegate.tabBarController.viewControllers = [AppDelegate.navigationController_home,AppDelegate.navigationController_shop,AppDelegate.navigationController_my]
        AppDelegate.tabBarController.tabBar.tintColor = Consts.tintGreen
        AppDelegate.tabBarController.tabBar.backgroundColor = Consts.white
        
//        if(self.introl_viewed){
//            self.window?.rootViewController = AppDelegate.tabBarController
//        }else{
//            self.window?.rootViewController = IntrolVC()
//        }
        print("plistDict\(plistDict)")
        if(plistDict == nil){
            self.window?.rootViewController = IntrolVC()
        }else{
            self.window?.rootViewController = AppDelegate.tabBarController
        }
        
        
        return true
    }

    
    
//      微信系统回调方法
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
//        渠道为微信、支付宝且安装了支付宝钱包或者测试模式时：
        
        Pingpp.handleOpenURL(url) { (result, error) -> Void in
            print(result)
            if(result == "success"){
                Tool.showSuccessHUD("支付成功！前往我的订单查看！")
                
            }else if (result == "cancel"){
                Tool.showErrorHUD("用户取消交易！")
            }else{
                Tool.showErrorHUD("支付失败，请重试！")
            }
        }
        
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

