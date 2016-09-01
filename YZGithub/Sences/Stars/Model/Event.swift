//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import UIKit
import ObjectMapper

enum EventType:String {
    case IssueCommentEvent
    case PullRequestEvent
    case WatchEvent
    case CreateEvent
    case PushEvent
}

class Event:NSObject,Mappable {
    var created_at:String?
    var type:EventType?
    var payload:NSDictionary?
    var id:String?
    var actor:ObjUser?
    var repo:Repository?
    var ispublic:Bool?
    required init?(_ map: Map) { 
        
    }
    
    func mapping(map: Map) {
        created_at <- map["created_at"]
        type <- map["type"]
        payload <- map["payload"]
        id <- map["id"]
        actor <- map["actor"]
        repo <- map["repo"]
        ispublic <- map["public"]
    }
}