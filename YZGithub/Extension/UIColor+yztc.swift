//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import Foundation

extension UIColor{
        class func hexStr(hexStr : NSString,alpha : CGFloat) -> UIColor {
        let realHexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: realHexStr as String)
        var color:UInt32 = 0
        
        // 把16进制的字符串转成 Int 数据放到color变量中
        // bool
        if scanner.scanHexInt(&color) {
            // & 与运算符
            let r = CGFloat( (color & 0xFF0000) >> 16 ) / 255.0
            let g = CGFloat( (color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat( (color & 0x0000FF) ) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
        }else{
            print("invalid hex string",terminator:"")
            return UIColor.whiteColor()
        }
    }
    class func navBarTintColor() -> UIColor {
        return UIColor.hexStr("00631B", alpha: 1)
    }
}
