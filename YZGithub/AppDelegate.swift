//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import Iconic
import JLSwiftRouter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()
//        Iconic.registerIconFont()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        customUI()
        customSocial()
        customRouter()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return true
    }

    func customUI() {
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.navBarTintColor()
        UINavigationBar.appearance().titleTextAttributes = NSDictionary.init(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
    }
    func customSocial()  {
        UMSocialData.setAppKey("56025946e0f55a744000439c")
        UMSocialSinaSSOHandler.openNewSinaSSOWithAppKey("3006877935", secret: "46fd11d135010fcc578a1b0ced7e50d4", redirectURL: "https://api.weibo.com/oauth2/default.html")
    }
    func customRouter() {
        let router = Router.sharedInstance
        router.map("/user/:name") { (result) -> (Bool) in
            let devVc = DeveloperViewController()
            devVc.developerName = result!["name"]
            self.showDetailPage(devVc)
            return true
        }
        router.map("repos/:owner/:reponame") { (result) -> (Bool) in
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let repoVC  = sb.instantiateViewControllerWithIdentifier("repoinfo") as!RepoInfoViewController
            repoVC.repoOwner = result!["owner"]
            repoVC.repoName = result!["reponame"]
            self.showDetailPage(repoVC)
            return true
        }
    }
    func showDetailPage(vc:UIViewController) {
        let rootvc = self.window?.rootViewController
        if  rootvc is UINavigationController{
            let nav = rootvc as! UINavigationController
            nav.pushViewController(vc, animated: true)
        }else if rootvc is UITabBarController {
            let tabvc = rootvc as! UITabBarController
            let selectVc = tabvc.selectedViewController
            if   selectVc is UINavigationController {
                let nav = selectVc as! UINavigationController
                nav.pushViewController(vc, animated: true)
            }else{
                GlobalHubHelper.showError("待模态", view: (selectVc?.view)!)
            }
        }else {
            GlobalHubHelper.showError("待模态", view: (rootvc?.view)!)
        }

    }
}

