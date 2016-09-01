//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import Foundation
import ObjectMapper

//[
//    {
//        "name": "master",
//        "commit": {
//            "sha": "7fd1a60b01f91b314f59955a4e4d4e80d8edf11d",
//            "url": "https://api.github.com/repos/octocat/Hello-World/commits/7fd1a60b01f91b314f59955a4e4d4e80d8edf11d"
//        }
//    },
//    {
//        "name": "test",
//        "commit": {
//            "sha": "b3cbd5bbd7e81436d2eee04537ea2b4c0cad4cdf",
//            "url": "https://api.github.com/repos/octocat/Hello-World/commits/b3cbd5bbd7e81436d2eee04537ea2b4c0cad4cdf"
//        }
//    }
//]
class Branches: NSObject,Mappable {
    var name:String?
    var commit:Commit?
    override init() {
        
    }
    required init?(_ map: Map) {
        
    }
    func mapping(map: Map) {
        name <- map["name"]
        commit <- map["commit"]
    }
}
