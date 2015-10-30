//
//  API.swift
//  yoyoCampus_Zhaolei
//
//  Created by 赵磊 on 15/10/17.
//  Copyright © 2015年 赵磊. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Reachability

protocol APIDelegate{
    ///对api返回数据的处理
    func didReceiveJsonResults(json:JSON,tag:String)
}

let httpHeaderKay:String = "access_token"

class YoYoAPI: NSObject {
    
    var delegate:APIDelegate?
    
    var httpHeader:[String:String] = ["":""]
    
    override init() {
        ///请求头
        if let tokenDict = NSMutableDictionary(contentsOfFile:AppDelegate.filePath){
                var headerValue = tokenDict.valueForKey("access_token") as! String
                httpHeader = [httpHeaderKay:headerValue]
        }else{
            
        }
    }
    
    ///GET请求
    func httpRequest(method:String,url:String,params:[String:AnyObject]?,tag:String){
        Config.shareInstance().isNetworkRunning = CheckNetwork.doesExistenceNetwork()
        
        if !Config.shareInstance().isNetworkRunning{
            Tool.showErrorHUD("貌似没联网哦!")
        }
        else{
            switch(method){
                
//            GET
            case "GET":
//                get默认url编码方式，没有body，不必指定编码方式
                    Alamofire.request(.GET,url,parameters:params,headers:httpHeader)
                        .responseJSON{  response in
                            if response.result.error == nil{
                            
                            self.delegate?.didReceiveJsonResults(JSON(response.result.value!), tag:tag)

                            }else{
                                //                        输出失败信息
                                print("get请求失败!\nurl ——> \(url)\nerror ——> \(response.result.error)")
                            }
                    }
                break
                
//                POST
            case "POST":
//                post默认url编码，要用json方式必须显式指定!
                Alamofire.request(.POST,url,parameters:params,headers:httpHeader,encoding: .JSON)
                    .responseJSON{  response in
                        if response.result.error == nil{
                            self.delegate?.didReceiveJsonResults(JSON(response.result.value!), tag:tag)
                        }else{
                            //                        输出失败信息
                            print("post请求失败!\nurl ——> \(url)\nerror ——> \(response.result.error)")
                        }
                }
                break
        
//                PUT
            case "PUT":
                Alamofire.request(.PUT,url,parameters:params,headers:httpHeader,encoding: .JSON)
                    .responseJSON{  response in
                        if response.result.error == nil{
                            self.delegate?.didReceiveJsonResults(JSON(response.result.value!), tag:tag)
                        }else{
                            //                        输出失败信息
                            print("put请求失败!\nurl ——> \(url)\nerror ——> \(response.result.error)")
                        }
                }
                break
                
//                DELETE
            case "DELETE":
                Alamofire.request(.DELETE,url,parameters:params,headers:httpHeader,encoding: .JSON)
                    .responseJSON{  response in
                        if response.result.error == nil{
                            self.delegate?.didReceiveJsonResults(JSON(response.result.value!), tag:tag)
                        }else{
                            //                        输出失败信息
                            print("delete请求失败!\nurl ——> \(url)\nerror ——> \(response.result.error)")
                        }
                }
                break
                
            default:
                print("http request method is Wrong!")
                break
            }
        }
    }
}