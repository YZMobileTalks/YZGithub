//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import Foundation
import Alamofire
import ObjectMapper

class SearchUserResponse: NSObject,Mappable{
    
    var totalCount:Int?
    var incompleteResults:Bool?
    var items:[ObjUser]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        //        super.mapping(map)
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
        items <- map["items"]
    }
    
}