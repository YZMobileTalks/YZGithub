//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import UIKit
import MBProgressHUD
import Alamofire
import ObjectMapper
import SwiftyJSON


class LoginViewController: YZWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.setMyBackgroundColor(UIColor.navBarTintColor())
    }
    
    deinit{
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func webViewDidStartLoad(webView: UIWebView) {
        super.webViewDidStartLoad(webView)
    }
    
    override func webViewDidFinishLoad(webView: UIWebView) {
        super.webViewDidFinishLoad(webView)
        let  url:String =  (webView.request?.URL?.absoluteString)!
        let codePrefix:String = "code="
        
        if url.containsString(codePrefix) {
            let range = url.rangeOfString(codePrefix)!
            let index = url.startIndex.distanceTo(range.startIndex) + 5
            let codeR = url.startIndex.advancedBy(index) ..< url.endIndex
            let code = url.substringWithRange(codeR)
            signIn(code)
        }
    }
    
    func signIn(code:String) {
        let para = [
            "client_id":GithubClientID,
            "client_secret":GithubClientSecret,
            "code":code,
            "redirect_uri":GithubRedirectUrl,
        ]
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Alamofire.request(.POST, "https://github.com/login/oauth/access_token",parameters: para).responseString { [weak self](response) in
            MBProgressHUD.hideAllHUDsForView(self!.view, animated: true)
            switch response.result {
            case .Failure(let error):
                GlobalHubHelper.showError("登陆失败:\(error)", view: (self?.view)!)
            case .Success(_):
                let str = String(data: response.data!, encoding: NSUTF8StringEncoding)
                if let str = str {
                    let arr:[String] = (str.componentsSeparatedByString("&"))
                    if arr.count > 0 {
                        let accesstoken = arr[0].substringFromIndex(arr[0].startIndex.advancedBy(13))
                        let scope = arr[1].substringFromIndex(arr[1].startIndex.advancedBy(7))
                        let tokentype = arr[2].substringFromIndex(arr[2].startIndex.advancedBy(11))
                        
                        //获取token 并保存到userdefault中
                        var token = AppToken.shareInstance
                        token.access_token = String(format: "token %@", accesstoken)
                        token.token_type = tokentype
                        token.scope = scope
                        
                        self!.getUserInfo(accesstoken)
                    }
                }
            }
            
        }
    }
    
    func getUserInfo(token:String) {
        
        let provider = Provider.sharedProvider
        provider.request(GitHubAPI.MyInfo, completion:{
            (result) -> () in
            switch result{
            case let .Success(response):
                do {
                    if let gitUser:ObjUser = Mapper<ObjUser>().map(try response.mapJSON()) {
                        
                        ObjUser.saveUserInfo(gitUser)
                        //post successful noti
                        self.navigationController?.popViewControllerAnimated(true)
                        NSNotificationCenter.defaultCenter().postNotificationName(NotificationGitLoginSuccessful, object:nil)
                        
                    } else {
                    }

                }catch{
                }
            
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                print(error)
            }
        } )
    }
}
