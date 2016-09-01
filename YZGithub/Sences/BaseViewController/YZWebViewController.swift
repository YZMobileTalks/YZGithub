//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import UIKit
import WebKit
import MBProgressHUD

class YZWebViewController: BaseViewController, WKNavigationDelegate {

    var webView:UIWebView?
    
    var url:String? {
        didSet{
            let urlTemp = NSURL(string: url!)
            let urlRequest = NSURLRequest(URL: urlTemp!)
            if webView != nil {
                self.webView!.loadRequest(urlRequest)
            }
        }
    }
    var html:String?{
        didSet{
            if  webView != nil {
                self.webView?.loadHTMLString(html!, baseURL: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setMyBackgroundColor(UIColor.navBarTintColor())
        customInit()
    }
    
    func customInit() {
        configWebView()
    }
    func configWebView() {
        
        var frame = self.view.bounds
        frame.origin.y = -44
        frame.size.height += 44
        webView = UIWebView(frame: frame)
        
        self.view.addSubview(webView!)
        
        if url != nil {
            let urlTmp = NSURL(string: url!)
            let urlRequest = NSURLRequest(URL: urlTmp!)
            self.webView!.loadRequest(urlRequest)
        }
        if html != nil {
            self.webView?.loadHTMLString(html!, baseURL: nil)
        }
        
        webView?.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
extension YZWebViewController:UIWebViewDelegate{
    
    func webViewDidStartLoad(webView: UIWebView) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        self.webView!.scrollView.contentInset = UIEdgeInsetsMake(self.topOffset, 0, 0, 0)
        self.webView!.scrollView.scrollRectToVisible(CGRectMake(0, 0, self.view.frame.size.width, 0.1), animated: true)
        
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        print(error)
    }

    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    func goBack() {
        
        if (webView!.canGoBack) {
            webView!.goBack()
        }else {
            leftItemAction(nil)
        }
    }
    
    func goForward() {
        if webView!.canGoForward {
            webView!.goForward()
        }else {
            
        }
    }
}
