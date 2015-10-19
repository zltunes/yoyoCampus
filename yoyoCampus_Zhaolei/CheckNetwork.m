//
//  CheckNetwork.m
//  先声
//
//  Created by Wangshuo on 14-8-1.
//  Copyright (c) 2014年 WangShuo. All rights reserved.
//

#import "CheckNetwork.h"

@implementation CheckNetwork

+ (BOOL)  doesExistenceNetwork
{
    Reachability *r = [Reachability reachabilityWithHostName:@"jwc.seu.edu.cn"] ;
    
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
            // 没有网络连接
            return NO;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            return YES;
            break;
        case ReachableViaWiFi:
            //NSLog(@"WIFI");
            // 使用WiFi网络
            return YES;
            break;
    }
}
@end
