//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import UIKit
import SnapKit
import ObjectMapper
import SwiftyJSON
//import 


class ReadmeViewController: UIViewController {

    var contentView:UITextView?
    
    var repo:Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customUI()
        fetchReadMeFile()
    }
    
    deinit{
//        print("释放")
    }
    func customUI() {
        contentView = UITextView()
        view.addSubview(contentView!)
        contentView?.snp_makeConstraints(closure: { (make) in
            make.size.top.leading.equalTo(view)
        })
    }

    func fetchReadMeFile() {
        Provider.sharedProvider.request(GitHubAPI.RepoReadme(owner: repo!.owner!.login!, repo: repo!.name!)) { (result) in
            switch result {
            case let .Success(response):
                if response.statusCode == 404 {
                    self.contentView?.text = "作者太懒,什么都没有写"
                    return
                }
                do{
                    if NSThread.currentThread().isMainThread {
                        dispatch_async(dispatch_get_global_queue(0, 0), {
                            do{
                                let string = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments)
                                let decodedData = NSData(base64EncodedString: "\(string.valueForKey("content")!)", options: NSDataBase64DecodingOptions(rawValue: 1))!
                                let decodedString = NSString(data: decodedData, encoding: NSUTF8StringEncoding)!
                                let prettyText = decodedString.richText()
                                dispatch_async(dispatch_get_main_queue(), { 
                                        self.contentView?.attributedText = prettyText
                                })
                            }catch{
                            }
                        })
                    }else{
                        let string = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments)
                        let decodedData = NSData(base64EncodedString: "\(string.valueForKey("content")!)", options: NSDataBase64DecodingOptions(rawValue: 1))!
                        let decodedString = NSString(data: decodedData, encoding: NSUTF8StringEncoding)!
                        let prettyText = decodedString.richText()
                        self.contentView?.attributedText = prettyText
                    }
                }catch{
                    
                }
            case let .Failure(error):
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
