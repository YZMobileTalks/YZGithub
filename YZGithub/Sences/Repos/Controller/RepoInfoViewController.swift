//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import UIKit
import Moya
import MBProgressHUD

class RepoInfoViewController: UIViewController {
    
    enum  Identifier:String{
        case intro = "introIdentifier"
        case info = "infoIdentifier"
        case codeInfo = "codeInfoIdentifier"
    }
    deinit{
        print("销毁")
        for task in netTask {
            task.cancel()
        }
    }
    var netTask:[Cancellable] = [Cancellable]()
    var repoInfo:Repository? {
        didSet{
            fetchBranches()
        }
    }
    //设置名字需要请求仓库数据
    var repoName:String? {
        didSet {
            fetchRepoInfo()
        }
    }
    var repoOwner:String?
    var branches:[Branches]?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = repoName ?? repoInfo?.name
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "RepoIntroCell",bundle: nil), forCellReuseIdentifier: Identifier.intro.rawValue)
        tableView.registerNib(UINib(nibName: "RepoInfoCell",bundle: nil), forCellReuseIdentifier: Identifier.info.rawValue)
        tableView.registerNib(UINib(nibName: "RepoCodeInfoCell",bundle: nil), forCellReuseIdentifier: Identifier.codeInfo.rawValue)
        tableView.contentInset = UIEdgeInsetsMake(-100, 0, 0, 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func fetchRepoInfo() {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "加载仓库信息中"
         let nb = Provider.sharedProvider.request(GitHubAPI.UserSomeRepo(owner: repoOwner!, repo: repoName!)) { [weak self](result) in
            switch result {
            case .Success(let response):
                do {
                    if let repo:Repository? = try response.mapObject(Repository) {
                        self!.repoInfo = repo
                        print(self?.classForCoder)
                        if self?.tableView != nil {
                            self!.tableView.reloadData()
                        }
                    }
                }catch{
                        GlobalHubHelper.showError("数据解析失败", view: self!.view)
                }
            case .Failure(let error):
                GlobalHubHelper.showError("网络请求失败:\(error)", view: self!.view)
            }
            MBProgressHUD.hideAllHUDsForView(self!.view, animated: true)
        }
        netTask.append(nb)
    }
    func fetchBranches() {
       let nb =  Provider.sharedProvider.request(GitHubAPI.RepoBranchs(owner: repoInfo!.owner!.login!, repo: repoInfo!.name!)) {[weak self] (result) in
            switch result {
            case let .Success(response):
                do{
                    if let commits:[Branches]? = try response.mapArray(Branches) {
                        if commits != nil {
                            self!.branches = commits
                        }
                    }
                }catch{
                    
                }
            case let .Failure(error):
                print(error)
            }
        }
        netTask.append(nb)
    }
}

//MARK: Delegate
extension RepoInfoViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        let index = (indexPath.section,indexPath.row)
        switch index {
        case  (1,0):
            let developerListVC = DeveloperListViewController()
            developerListVC.developer = repoInfo?.owner
            if let nav = self.parentViewController?.navigationController {
                nav.pushViewController(developerListVC, animated: true)
            }else{
                self.navigationController?.pushViewController(developerListVC, animated: true)
            }
        case (1,1):
            showBranches()
        case (2,0):
            let prvc = PRListViewController()
            prvc.repoinfo = repoInfo
            self.navigationController?.pushViewController(prvc, animated: true)
        case (2,1):
            let readmeVC = ReadmeViewController()
            readmeVC.repo = repoInfo
            navigationController?.pushViewController(readmeVC, animated: true)
        default:
            print("等等")
        }
    }
    func showBranches() {
        if branches == nil {
            return
        }
        let title:[String] = branches!.map { (branch:Branches) -> String in
            return branch.name!
        }
        let sheet = JWSheet.init(frame: view.frame, items: title) { (index) in
            print(index)
        }
        tabBarController!.view.addSubview(sheet)
    }
}

//MARK: DataSource
extension RepoInfoViewController:UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        return 10
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 2
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(Identifier.intro.rawValue,forIndexPath: indexPath) as? RepoIntroCell
            if let repoinfo = repoInfo {
                cell!.repoinfo = repoinfo
            }
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(Identifier.info.rawValue, forIndexPath: indexPath) as? RepoInfoCell
            switch indexPath.row {
            case 0:
                cell?.customUI(UIImage(named: "octicon_person_25")!, actionName: "成员")
            case 1:
                cell?.customUI(UIImage(named: "coticon_branch_25")!, actionName: "分支")
            default:
                return cell!
            }
            return cell!
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(Identifier.info.rawValue, forIndexPath: indexPath) as? RepoInfoCell
            
            switch indexPath.row {
            case 0:
                cell?.customUI(UIImage(named: "octicon_pull_request_25")!, actionName: "合并请求")
            case 1:
                cell?.customUI(UIImage(named: "octicon_watch_red_25")!, actionName: "README")
            default:
                return cell!
            }
            return cell!
        }
    }
    
}
