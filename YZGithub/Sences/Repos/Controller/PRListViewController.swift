//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import SnapKit
import MBProgressHUD


class PRListViewController: UIViewController {

    lazy var tableView: UITableView? = {
        let table = UITableView()
//        table.delegate = self
        table.dataSource = self
        return table
    }()
    var repoinfo:Repository? {
        didSet{
            fetchPRS()
        }
    }
    var prArray:[PullRequest]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
    }
    func customUI() {
        title = "PR列表"
        view.addSubview(tableView!)
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.tableFooterView = UIView()
        tableView?.registerNib(UINib(nibName: "PRCell",bundle: nil), forCellReuseIdentifier: "cell")
        tableView?.snp_makeConstraints(closure: { (make) in
            make.top.bottom.equalTo(view)
            make.leading.trailing.equalTo(view)
        })
    }
    deinit{
        print("释放")
    }
    func fetchPRS() {
        Provider.sharedProvider.request(GitHubAPI.RepoPullRequest(owner: repoinfo!.owner!.login!, repo: repoinfo!.name!)) { (result) in
            switch result {
            case let .Success(response):
                do{
                    if let prs:[PullRequest]? = try response.mapArray(PullRequest) {
                        if prs?.count == 0{
                            let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hub.labelText = "这个仓库太冷清,没人提PR"
                            hub.mode = .Text
                            hub.hide(true, afterDelay: 1)
                            return
                        }
                        self.prArray = prs
                        self.tableView?.reloadData()
                    }
                }catch{
                    
                }
            case let .Failure(error):
                print(error)
            }
        }
    }
}
extension PRListViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if prArray != nil {
            return prArray!.count
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? PRCell
        cell?.prinfo = prArray![indexPath.row]
        return cell!
    }
}
