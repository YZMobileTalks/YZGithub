//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import UIKit
import SnapKit

class RepoListViewController: UIViewController {

    //MARK: 搜索属性
    var page = 1
    var perpage = 10
    var type = "owner"
    var sort = "created"
    var direction = "desc"

    //MARK: DATA
    var developer:ObjUser? = nil
    var reposArray:[Repository]?
    
    lazy var tableView:UITableView? = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customUI()
        fetchRepoList()
    }
    func customUI() {
        view.addSubview(tableView!)
        title = "仓库列表"
        tableView?.snp_makeConstraints(closure: { (make) in
            make.top.bottom.leading.trailing.equalTo(view)
        })
//        tableView?.estimatedRowHeight = 100
//        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.registerNib(UINib(nibName: "RepoTableViewCell",bundle: nil), forCellReuseIdentifier: "RepoTableViewCell")
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func fetchRepoList() {
        Provider.sharedProvider.request(GitHubAPI.UserRepos(username: (developer?.login)!, page: page, perpage: perpage, type: type, sort: sort, direction: direction)) { (result) in
            switch result {
            case let .Success(response):
                do{
                    if let repos:[Repository]? = try response.mapArray(Repository) {
                        if self.page == 1 {
                            self.reposArray?.removeAll()
                            self.reposArray = repos!
                        }else{
                            self.reposArray = self.reposArray! + repos!
                        }
                        self.page += 1
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
extension RepoListViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let a = reposArray {
                return a.count + 1
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == reposArray?.count {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            let label = UILabel()
            label.frame.size = CGSize(width: 120, height: 40)
            label.textColor = UIColor.whiteColor()
            label.text = "点击加载更多"
            label.textAlignment = .Center
            cell.addSubview(label)
            label.snp_makeConstraints(closure: { (make) in
                make.center.equalTo(cell)
            })
            cell.backgroundColor = UIColor.hexStr("00631b", alpha: 1)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("RepoTableViewCell", forIndexPath: indexPath) as? RepoTableViewCell
        cell?.repo = reposArray![indexPath.row]
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row  == reposArray?.count{
            return 40
        }
        return 100
    }
}
extension RepoListViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == reposArray?.count {
            fetchRepoList()
            return
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let repoInfoVC = sb.instantiateViewControllerWithIdentifier("repoinfo") as? RepoInfoViewController
        repoInfoVC!.repoInfo = reposArray![indexPath.row]
        navigationController?.pushViewController(repoInfoVC!, animated: true)
    }
}

