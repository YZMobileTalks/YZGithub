//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import UIKit

extension NSMutableAttributedString {
    func linkWithString(string:String,inString:String,url:String) {
        let range = inString.NSRangeFromRange(inString.rangeOfString(string)!)
        self.addAttributes([NSFontAttributeName:UIFont.italicSystemFontOfSize(16),NSLinkAttributeName:NSURL(string:url)!], range: range)
    }
}
