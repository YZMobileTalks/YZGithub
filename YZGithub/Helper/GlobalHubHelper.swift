//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import MBProgressHUD

class GlobalHubHelper {

    class func showMessage(message:String,view:UIView){
        let hub = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hub.labelText = message
        hub.mode = .Text
        hub.hide(true, afterDelay: 2)
    }
    class func showError(error:String,view:UIView){
        let hub = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hub.labelText = error
        hub.mode = .Text
        hub.labelColor = UIColor.navBarTintColor()
        hub.hide(true, afterDelay: 3)
    }
    
}
