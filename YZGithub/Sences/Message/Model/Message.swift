//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import ObjectMapper

enum Reason:String {
    case subscribed
    case manual
    case author
    case comment
    case mention
    case team_mention
    case state_change
    case assign
}

class Message:NSObject,Mappable {
    var subject:Subject?
    var last_read_at:String?
    var unread:Int?
    var id:String?
    var updated_at:String?
    var reason:Reason?
    var repository:Repository?
    var url:String?
    required init?(_ map: Map) { 
        
    }
    
    func mapping(map: Map) {
        subject <- map["subject"]
        last_read_at <- map["last_read_at"]
        unread <- map["unread"]
        id <- map["id"]
        updated_at <- map["updated_at"]
        reason <- map["reason"]
        repository <- map["repository"]
        url <- map["url"]
    }
}
