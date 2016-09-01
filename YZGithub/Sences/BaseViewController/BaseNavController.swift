//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit

class BaseNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 感觉不同的导航控制器跳转到不同的界面
        if let ident = self.restorationIdentifier {
            switch ident {
            case "new":
                let vc = NewsViewController(nibName: nil, bundle: nil)
                self.pushViewController(vc, animated: true)
            default:
                GlobalHubHelper.showError("没有这个控制器", view: self.view)
            }
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
