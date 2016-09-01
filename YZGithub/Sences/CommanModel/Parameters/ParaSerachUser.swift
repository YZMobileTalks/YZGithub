//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import Foundation

public enum SearchUserQueryPrefix:String {
    case Type = "type"
    case In = "in"
    case Repos = "repos"
    case Location = "location"
    case Language = "language"
    case Followers = "followers"
    case Created = "created"
}
public enum UserType:String {
    case Default = ""
    case User = "user"
    case Org = "org"
}

public enum UserInField : String {
    case Default = ""
    case Email = "email"
    case UserName = "login"
    case FullName = "fullname"
}
public class ParaSearchUser : NSObject {
    var q:String
    var sort:String
    var order:String
    
    
    var keyword:String?
    var typePara:UserType?
    var inPara:UserInField?
    var reposPara:String?
    var locationPara:String?
    var languagePara:String?
    var createdPara:String?
    var followersPara:String?
    
    var page:Int = 1
    var perPage:Int = 10
    
    init(query:String ,sort:String ,order:String) {
        
        self.q = query
        self.sort = sort
        self.order = order
        
    }
    
    convenience override init() {
        self.init(query:"type:user" ,sort:"followers" ,order:"desc")
    }
    
    func combineQuery()->String {
        
        var query = ""
        
        if(keyword != nil){
            query += "\(keyword!)"
        }
        
        //type:org
        if(typePara != nil){
            let typeStr = typePara!.rawValue
            query += " type:\(typeStr)"
        }
        
        //in:email
        if(inPara != nil){
            let inStr = inPara!.rawValue
            query += " in:\(inStr)"
        }
        
        //repos:>9000
        if(reposPara != nil){
            query += " repos:\(reposPara!)"
        }
        
        //location:iceland
        if(locationPara != nil){
            query += " location:\(locationPara!)"
        }
        
        //language:javascript
        if(languagePara != nil){
            query += " language:\(languagePara!)"
        }
        
        //created:<2011-01-01
        if(createdPara != nil){
            query += " created:\(createdPara!)"
        }
        
        //followers:>=1000
        if(followersPara != nil){
            query += " followers:\(followersPara!)"
        }
        
        if(query.isEmpty || (query == "") ){
            query = "type:user"
        }
        
        return query
    }
    
}

