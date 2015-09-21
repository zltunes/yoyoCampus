
import Foundation
import UIKit

@objc protocol HttpProtocol
{
    optional func didReceiveJsonResults(results:AnyObject,tag:String)
    optional func requestFailed(results:AnyObject,tag:String)
    
}

class HttpController:NSObject
{
    var delegate:HttpProtocol?
    
    ///发起get请求,url为地址,para为请求携带参数,tag为区分请求的标示符,不带http头
    func requestFromURL(url:String,para:AnyObject?,tag:String)
    {
        
        Config.shareInstance().isNetworkRunning = CheckNetwork.doesExistenceNetwork()
        
        if !Config.shareInstance().isNetworkRunning
        {
            Tool.showErrorHUD("请检查网络连接")
        }
        else
        {
            
            let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            manager.GET(url, parameters: para, success:
                {(operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
                    
                    self.delegate?.didReceiveJsonResults?(responseObject ,tag:tag)
                    
                    
                }
                , failure:
                {(operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
                    print("$$$$$$$$$$$" + operation.description)
                    Tool.dismissHUD()
                    NSLog("requestFailure: \(error)")
                    self.delegate?.requestFailed?(operation.responseObject, tag: tag)
                }
            )
        }
    }
    
    ///发起get请求,url为地址,para为请求携带参数,tag为区分请求的标示符,带http头
    func requestFromUrlWithHttpHeader(url:String , para:AnyObject?,tag:String, headerKey : String, headerValue : String)
    {
        Config.shareInstance().isNetworkRunning = CheckNetwork.doesExistenceNetwork()
        
        if !Config.shareInstance().isNetworkRunning
        {
            Tool.showErrorHUD("请检查网络连接")
        }
        else
        {
            
            let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            manager.requestSerializer.setValue(headerValue, forHTTPHeaderField: headerKey)
            manager.GET(url, parameters: para, success: {(operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
                
                
                self.delegate?.didReceiveJsonResults?(responseObject ,tag:tag)
                
                
                }, failure: {(operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
                    
                    print("$$$$$$$$$$$" + operation.description)
                    Tool.dismissHUD()
                    NSLog("requestFailure: \(error)")
                    self.delegate?.requestFailed?(operation.responseObject, tag: tag)
                    
                }
            )
        }
    }

    
    ///发起post请求,url为地址,para为请求携带参数,tag为区分请求的标示符,不带http头
    func postToURL(url:String , para:AnyObject?,tag:String)
    {
        
        Config.shareInstance().isNetworkRunning = CheckNetwork.doesExistenceNetwork()
        
        if !Config.shareInstance().isNetworkRunning
        {
            Tool.showErrorHUD("请检查网络连接")
        }
        else
        {
            
            let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            manager.POST(url, parameters: para, success: {(operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
                
                
                self.delegate?.didReceiveJsonResults?(responseObject ,tag:tag)
                
                
                }, failure: {(operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
                    
                    print("$$$$$$$$$$$" + operation.description)
                    Tool.dismissHUD()
                    NSLog("requestFailure: \(error)")
                    self.delegate?.requestFailed?(operation.responseObject, tag: tag)
                    
                }
            )
        }
        
    }
    
    ///发起post请求,url为地址,para为请求携带参数,tag为区分请求的标示符,带http头
    func postToUrlWithHttpHeader(url:String , para:AnyObject?,tag:String, headerKey : String, headerValue : String)
    {
        Config.shareInstance().isNetworkRunning = CheckNetwork.doesExistenceNetwork()
        
        if !Config.shareInstance().isNetworkRunning
        {
            Tool.showErrorHUD("请检查网络连接")
        }
        else
        {
            
            let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            manager.requestSerializer.setValue(headerValue, forHTTPHeaderField: headerKey)
            manager.POST(url, parameters: para, success: {(operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
                
                
                self.delegate?.didReceiveJsonResults?(responseObject ,tag:tag)
                
                
                }, failure: {(operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
                    
                    print("$$$$$$$$$$$" + operation.description)
                    Tool.dismissHUD()
                    NSLog("requestFailure: \(error)")
                    self.delegate?.requestFailed?(operation.responseObject, tag: tag)
                    
                }
            )
        }
    }
    
    
    ///发起delete请求,url为地址,para为请求携带参数,tag为区分请求的标示符,不带http头
    func deleteToURL(url:String , para:AnyObject?,tag:String)
    {
        
        Config.shareInstance().isNetworkRunning = CheckNetwork.doesExistenceNetwork()
        
        if !Config.shareInstance().isNetworkRunning
        {
            Tool.showErrorHUD("请检查网络连接")
        }
        else
        {
            
            let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            
            manager.DELETE(url, parameters: para, success: {(operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
                
                
                self.delegate?.didReceiveJsonResults?(responseObject ,tag:tag)
                
                
                }, failure: {(operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
                    
                    print("$$$$$$$$$$$" + operation.description)
                    Tool.dismissHUD()
                    NSLog("requestFailure: \(error)")
                    self.delegate?.requestFailed?(operation.responseObject, tag: tag)
                    
                }
            )
        }
    }
    
    ///发起delete请求,url为地址,para为请求携带参数,tag为区分请求的标示符,带http头
    func deleteToUrlWithHttpHeader(url:String , para:AnyObject?,tag:String, headerKey : String, headerValue : String)
    {
        Config.shareInstance().isNetworkRunning = CheckNetwork.doesExistenceNetwork()
        
        if !Config.shareInstance().isNetworkRunning
        {
            Tool.showErrorHUD("请检查网络连接")
        }
        else
        {
            
            let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            manager.requestSerializer.setValue(headerValue, forHTTPHeaderField: headerKey)
            manager.DELETE(url, parameters: para, success: {(operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
                
                
                self.delegate?.didReceiveJsonResults?(responseObject ,tag:tag)
                
                
                }, failure: {(operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
                    
                    print("$$$$$$$$$$$" + operation.description)
                    Tool.dismissHUD()
                    NSLog("requestFailure: \(error)")
                    self.delegate?.requestFailed?(operation.responseObject, tag: tag)
                    
                }
            )
        }
    }
    
    ///发起put请求,url为地址,para为请求携带参数,tag为区分请求的标示符,不带http头
    func putToURL(url:String , para:AnyObject?,tag:String)
    {
        
        Config.shareInstance().isNetworkRunning = CheckNetwork.doesExistenceNetwork()
        
        if !Config.shareInstance().isNetworkRunning
        {
            Tool.showErrorHUD("请检查网络连接")
        }
        else
        {
            
            let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            
            manager.PUT(url, parameters: para, success: {(operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
                
                
                self.delegate?.didReceiveJsonResults?(responseObject ,tag:tag)
                
                
                }, failure: {(operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
                    
                    print("$$$$$$$$$$$" + operation.description)
                    Tool.dismissHUD()
                    NSLog("requestFailure: \(error)")
                    self.delegate?.requestFailed?(operation.responseObject, tag: tag)
                    
                }
            )
        }
    
    }
    
    ///发起put请求,url为地址,para为请求携带参数,tag为区分请求的标示符,带http头
    func putToURLWithHttpHeader(url:String , para:AnyObject?,tag:String, headerKey : String, headerValue : String)
    {
        
        Config.shareInstance().isNetworkRunning = CheckNetwork.doesExistenceNetwork()
        
        if !Config.shareInstance().isNetworkRunning
        {
            Tool.showErrorHUD("请检查网络连接")
        }
        else
        {
            
            let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            manager.requestSerializer.setValue(headerValue, forHTTPHeaderField: headerKey)
            manager.PUT(url, parameters: para, success: {(operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
                
                
                self.delegate?.didReceiveJsonResults?(responseObject ,tag:tag)
                
                
                }, failure: {(operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
                    
                    print("$$$$$$$$$$$" + operation.description)
                    Tool.dismissHUD()
                    NSLog("requestFailure: \(error)")
                    self.delegate?.requestFailed?(operation.responseObject, tag: tag)
                    
                }
            )
        }
        
    }
    
    ///发起postData请求,url为地址,para为请求携带参数,tag为区分请求的标示符,不带http头,该请求主要用来传输文件
    func postDataToURL(url:String, para:AnyObject?, data:NSData! , tag:String){
        Config.shareInstance().isNetworkRunning = CheckNetwork.doesExistenceNetwork()
        
        if !Config.shareInstance().isNetworkRunning
        {
            Tool.showErrorHUD("请检查网络连接")
        }
        else
        {
            
            let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            
            manager.POST(url, parameters: para, constructingBodyWithBlock: {(formdata:AFMultipartFormData!) -> Void in
                
                formdata.appendPartWithFileData(data, name: "file", fileName: Config.accessToken! + ".jpg", mimeType: "image/jpg")
                
                }, success: {(operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
                    
                    self.delegate?.didReceiveJsonResults?(responseObject ,tag:tag)
                    
                    
                }, failure: {(operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
                    
                    print("$$$$$$$$$$$" + operation.description)
                    Tool.dismissHUD()
                    NSLog("requestFailure: \(error)")
                    self.delegate?.requestFailed?(operation.responseObject, tag: tag)
                    
                }
            )
        }
    }
        
        
    

    
    
    
}