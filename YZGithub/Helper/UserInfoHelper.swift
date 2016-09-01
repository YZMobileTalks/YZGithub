//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import UIKit

class UserInfoHelper: NSObject {

    static let sharedInstance = UserInfoHelper()
    
    var user:ObjUser? {
        get{
            let user = ObjUser.loadUserInfo()
            return user
        }
        set(newValue){
            ObjUser.saveUserInfo(newValue)
        }
    }
    var isLogin:Bool{
        get {
            if user != nil {
                if ( ((user!.name) != nil) && !((user!.name!).isEmpty) && (AppToken().access_token != nil)){
                    return true
                }
            }
            return false
        }
    }
    var isUser:Bool {
        get {
            if (isLogin && ( (user!.type!) == "User" )) {
                return true
            }
            return false
        }
    }

    var userToken:String {
        get {
            return AppToken().access_token!
        }
        set(newtoken) {
            var token = AppToken.shareInstance
            token.access_token = newtoken
        }
    }
    func deleteUser() {
        
        ObjUser.deleteUserInfo()
    }
}
