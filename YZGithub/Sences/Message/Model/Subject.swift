//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import ObjectMapper

class Subject:NSObject,Mappable {
    var title:String?
    var type:String?
    var latest_comment_url:String?
    var url:String?
    required init?(_ map: Map) { 
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        type <- map["type"]
        latest_comment_url <- map["latest_comment_url"]
        url <- map["url"]
    }
}