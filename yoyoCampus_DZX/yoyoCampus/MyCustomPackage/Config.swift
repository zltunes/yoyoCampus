import Foundation


class Config:NSObject
{
    var isNetworkRunning : Bool = false
    
    class func shareInstance()->Config{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:Config? = nil
            
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=Config()
            }
        )
        return YRSingleton.instance!
    }
    
    class var accessToken:String?
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return settings.objectForKey("accessToken") as? String
    }
    
    class var registerToken:String?
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return settings.objectForKey("registerToken") as? String
    }
    
    class var userID:String?
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return settings.objectForKey("userID") as? String
    }
    
    class var userHeadImage:String?
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return settings.objectForKey("userHeadImage") as? String
    }
    
    class var userSex:String?
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return settings.objectForKey("userSex") as? String
    }
    
    class var userName:String?
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return settings.objectForKey("userName") as? String
    }
    
    class var userNickName:String?
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return settings.objectForKey("userNickName") as? String
    }
    
    class var userPhone:String?
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return settings.objectForKey("userPhone") as? String
    }
    
    class var masterID:String?
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return settings.objectForKey("masterID") as? String
    }
    
    ///存储删除操作
    
    //***Access Token***
    class func saveAccessToken(token:NSString )
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("accessToken")
        
        settings.setObject(token, forKey: "accessToken")
        settings.synchronize()
    }
    
    class func removeAccessToken()
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("accessToken")
        settings.synchronize()
    }
    
    //***Register Token***
    
    class func saveRegisterToken(id:NSString)
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("registerToken")
        
        settings.setObject(id, forKey: "registerToken")
        settings.synchronize()
    }
    
    class func removeRegisterToken()
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("registerToken")
        settings.synchronize()
    }
    
    //***User ID***
    
    class func saveUserID(id:NSString)
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("userID")
        
        settings.setObject(id, forKey: "userID")
        settings.synchronize()
    }
    
    class func removeUserID()
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("userID")
        settings.synchronize()
    }
    
    //***User Head Image***
    
    class func saveUserHeadImage(id:NSString)
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("userHeadImage")
        
        settings.setObject(id, forKey: "userHeadImage")
        settings.synchronize()
    }
    
    class func removeUserHeadImage()
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("userHeadImage")
        settings.synchronize()
    }
    
    //***User Sex***
    
    class func saveUserSex(id:NSString)
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("userSex")
        
        settings.setObject(id, forKey: "userSex")
        settings.synchronize()
    }
    
    class func removeUserSex()
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("userSex")
        settings.synchronize()
    }
    
    //***User Name***
    
    class func saveUserName(id:NSString)
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("userName")
        
        settings.setObject(id, forKey: "userName")
        settings.synchronize()
    }
    
    class func removeUserName()
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("userName")
        settings.synchronize()
    }
    
    //***User Nick Name***
    
    class func saveUserNickName(id:NSString)
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("userNickName")
        
        settings.setObject(id, forKey: "userNickName")
        settings.synchronize()
    }
    
    class func removeUserNickName()
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("userNickName")
        settings.synchronize()
    }
    
    //***User Phone***
    
    class func saveUserPhone(id:NSString)
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("userPhone")
        
        settings.setObject(id, forKey: "userPhone")
        settings.synchronize()
    }
    
    class func removeUserPhone()
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("userPhone")
        settings.synchronize()
    }
    
    //***Master ID***
    
    class func saveMasterID(id:NSString)
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("masterID")
        
        settings.setObject(id, forKey: "masterID")
        settings.synchronize()
    }
    
    class func removeMasterID()
    {
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey("masterID")
        settings.synchronize()
    }
    
}