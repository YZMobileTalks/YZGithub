//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit

struct AppToken {
    enum DefaultsKeys:String {
        case TokenKey = "TokenKey"
        case TokenType = "TokenType"
        case TokenScope = "TokenScope"
        case TokenExpiry = "TokenExpiry"
    }
    
    let defaults : NSUserDefaults
    
    static let shareInstance = AppToken()
    
    init(defaults:NSUserDefaults){
        self.defaults = defaults
    }
    init(){
        self.defaults = NSUserDefaults.standardUserDefaults()
    }
    var access_token:String?{
        get{
            let key = defaults.stringForKey(DefaultsKeys.TokenKey.rawValue)
            return key
        }
        set(newToken){
            defaults.setObject(newToken, forKey: DefaultsKeys.TokenKey.rawValue)
        }
    }
    var token_type:String? {
        get {
            
            let key = defaults.stringForKey(DefaultsKeys.TokenType.rawValue)
            return key
        }
        set(newType) {
            defaults.setObject(newType, forKey: DefaultsKeys.TokenType.rawValue)
        }
    }
    
    var scope:String? {
        get {
            let key = defaults.stringForKey(DefaultsKeys.TokenScope.rawValue)
            return key
        }
        set(newScope) {
            defaults.setObject(newScope, forKey: DefaultsKeys.TokenScope.rawValue)
        }
    }
    var isValid: Bool {
        if let token = access_token {
            return token.isEmpty
        }
        return false
    }

}