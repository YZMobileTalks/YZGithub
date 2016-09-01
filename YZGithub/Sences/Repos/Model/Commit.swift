//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import ObjectMapper

//"commit": {
    //            "sha": "7fd1a60b01f91b314f59955a4e4d4e80d8edf11d",
    //            "url": "https://api.github.com/repos/octocat/Hello-World/commits/7fd1a60b01f91b314f59955a4e4d4e80d8edf11d"
    //        }
class Commit: NSObject,Mappable {
    var sha:String?
    var url:String?
    var message:String?
    required init?(_ map: Map) {
        
    }
    override init() {
        
    }
    func mapping(map: Map) {
        sha <- map["sha"]
        url <- map["url"]
        message <- map["message"]
    }
}
