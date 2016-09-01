//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import UIKit
import SnapKit
import MBProgressHUD

class MessagesViewController: UIViewController {

    var messageArray = [Message]()
    
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
        isLogin()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(fetchData), name: NotificationGitLoginSuccessful, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(fetchData), name: NotificationGitLogOutSuccessful, object: nil)
    }
    func customUI() {
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.size.left.top.equalTo(self.view)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.registerNib(UINib(nibName: "MessageCell",bundle: nil), forCellReuseIdentifier: "messageCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    func fetchData() {
        let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hub.labelText = "加载数据中"
        Provider.sharedProvider.request(GitHubAPI.Message(page: 0)) { (result) in
            switch result {
            case .Success(let response):
                do{
                    let array = try  response.mapArray(Message)
                    self.messageArray.appendContentsOf(array)
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.tableView.reloadData()
                }catch {
                    GlobalHubHelper.showMessage("数据解析失败", view: self.view)
                }
            case .Failure(let error):
                GlobalHubHelper.showError("error:\(error.response)", view: self.view)
            }
        }
    }
    func isLogin() {
        if UserInfoHelper.sharedInstance.isLogin {
            fetchData()
        }else {
            GlobalHubHelper.showError("请先登录...", view: self.view)
        }
    }
}
extension MessagesViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as? MessageCell
        cell?.message = messageArray[indexPath.row]
        return cell!
    }
}
extension MessagesViewController:UITableViewDelegate {
    
}
