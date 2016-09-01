//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import SnapKit
import Kingfisher

class SettingViewController: BaseViewController {

    var tableView = UITableView(frame: CGRectZero, style: .Grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
    }
    func customUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "settingCell")
        tableView.snp_makeConstraints { (make) in
            make.size.equalTo(self.view)
            make.left.top.equalTo(self.view)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit{
        print("销毁")
    }
}
extension SettingViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = (indexPath.section,indexPath.row)
        
        switch index {
        case (0,0):
            let cell = tableView.viewWithTag(101) as! UITableViewCell
            KingfisherManager.sharedManager.cache.clearDiskCacheWithCompletionHandler({ 
                GlobalHubHelper.showMessage("缓存清除成功", view: self.view)
                cell.textLabel?.text = "无缓存"
            })
        default:
            if ObjUser.deleteUserInfo() {
                GlobalHubHelper.showMessage("退出成功", view: view)
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationGitLogOutSuccessful, object: nil)
                self.navigationController?.popViewControllerAnimated(true)
            }else{
                GlobalHubHelper.showError("退出失败", view: view)
            }
        }
    }
}
extension SettingViewController:UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath)
        
        let index = (indexPath.section,indexPath.row)
        switch index {
        case (0,0):
            KingfisherManager.sharedManager.cache.calculateDiskCacheSizeWithCompletionHandler({ (size) in
                cell.textLabel?.text = "清除缓存  (\(size / 1024  / 1024) M)"
            })
            cell.textLabel?.text = "清除缓存"
            cell.tag = 101
        case(1,0):
                cell.textLabel?.text = "退出"
        default:
                print("等待")
        }
        return cell
    }
}
