//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import ObjectMapper

class ExploreReposViewController: UIViewController {
    
    let cellIdentifier = "RepoTableViewCell"
    var reposData:[Repository]! = []
    
    // MARK: request parameters
    
    
    var paraSince:String = "daily"
    var paraLanguage:String = "all"

    
    
    lazy var tableView: UITableView = {
        var table:UITableView = UITableView(frame: self.view.bounds)
        table.dataSource = self
        table.delegate = self
        
        table.registerNib(UINib(nibName: "RepoTableViewCell", bundle: nil), forCellReuseIdentifier: "RepoTableViewCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData() {
        let provider = Provider.sharedProvider
        provider.request(GitHubAPI.TrendingRepos(since: "daily", language: "ALL")){ result in
            
            switch result {
            case let .Success(response):
                do{
                    if let repos:[Repository]? = try response.mapArray(Repository){
                            self.reposData.removeAll()
                            self.reposData = repos!
                            self.tableView.reloadData()
                            self.tableView.setContentOffset(CGPointZero, animated:true)
                    }else{
                            
                    }
                }catch {
                    
                }
            
            case let .Failure(error):
                print(error)
                guard let error = error as? CustomStringConvertible else {
                    break
                }
            }
        }
    }
}
extension ExploreReposViewController:UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reposData.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RepoTableViewCell
        cell.repo = reposData[indexPath.row]
        return cell
    }
}
extension ExploreReposViewController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let infoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("repoinfo") as? RepoInfoViewController
        infoVC?.repoInfo = reposData[indexPath.row]
        self.parentViewController?.navigationController?.pushViewController(infoVC!, animated: true)
    }
    
}