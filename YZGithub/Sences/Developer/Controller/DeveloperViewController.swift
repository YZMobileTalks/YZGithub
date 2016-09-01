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
import ObjectMapper

class DeveloperViewController: UIViewController {

    enum CellIdentifier:String {
        case UserBaseInfoCell
        case RepoInfoCell
    }
    //MARK: UI 属性
    let tableView:UITableView = UITableView(frame: CGRectZero, style: .Grouped)
    var headerView:UIView?
    var userImage:UIImageView?
    var userName:UILabel = UILabel()
    var follerNumber:UILabel = UILabel()
    var follingNumber:UILabel = UILabel()
    //MARK: UI 数据
    var headerHeight:CGFloat {
        return 200
    }
    var viewWidth: CGFloat{
        return view.frame.width
    }
    
    //MARK: Data
    var developer:ObjUser? {
        didSet{
            userImage?.kf_setImageWithURL(NSURL(string: developer!.avatar_url!)!)
            userName.text = developer?.login
            follerNumber.text = "\(developer?.followers ?? 0) 粉丝"
            follingNumber.text = "关注\(developer?.following ?? 0)人"
            title = developer?.login
        }
    }
    var developerName:String? {
        didSet{
            title = developerName
        }
    }
    
    //MARK: 生命流程
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
        fetchDeveloperInfo()
    }
    
    func customUI(){
        
        // MARK: tableview UI
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.registerNib(UINib(nibName: CellIdentifier.UserBaseInfoCell.rawValue,bundle: nil), forCellReuseIdentifier: CellIdentifier.UserBaseInfoCell.rawValue)
        tableView.registerNib(UINib(nibName: CellIdentifier.RepoInfoCell.rawValue,bundle: nil), forCellReuseIdentifier: CellIdentifier.RepoInfoCell.rawValue)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(64 + headerHeight, 0, 60, 0)
        tableView.snp_makeConstraints { (make) in
            make.size.equalTo(view)
            make.top.bottom.leading.trailing.equalTo(view)
        }
        
        // MARK: headerView
        headerView = UIView(frame: CGRectMake(0, -headerHeight, viewWidth, headerHeight))
        headerView?.backgroundColor = UIColor.redColor()
        tableView.addSubview(headerView!)
        let bgImageView = UIImageView(image: UIImage(named: "profile_bk"))
        bgImageView.contentMode = UIViewContentMode.ScaleAspectFill
        headerView!.addSubview(bgImageView)
        bgImageView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(headerView!)
            make.leading.trailing.equalTo(headerView!)
        }
        
        // MARK: user logo
        
        userImage = UIImageView(image: UIImage(named: "app_logo_90"))
        if let developer = developer{
            userImage?.kf_setImageWithURL(NSURL(string: developer.avatar_url!)!)
        }
        headerView?.addSubview(userImage!)
        userImage?.snp_makeConstraints(closure: { (make) in
            make.centerX.equalTo(headerView!)
            make.width.height.equalTo(90)
            make.bottom.equalTo(headerView!.snp_bottom).offset(-60)
        })
        userImage?.layer.masksToBounds = true
        userImage?.layer.cornerRadius = 45
        
        //MARK: user name 
        headerView?.addSubview(userName)
        userName.textColor = UIColor.whiteColor()
        userName.snp_makeConstraints { (make) in
            make.centerX.equalTo(headerView!)
            make.top.equalTo(userImage!.snp_bottom).offset(10)
        }
        
        //MARK: foller number
        headerView?.addSubview(follerNumber)
        follerNumber.textColor = UIColor.whiteColor()
        follerNumber.font = UIFont.systemFontOfSize(12)
        follerNumber.snp_makeConstraints { (make) in
            make.centerX.equalTo(headerView!).offset(-40)
            make.top.equalTo(userName.snp_bottom).offset(5)
        }
        
        headerView?.addSubview(follingNumber)
        follingNumber.textColor = UIColor.whiteColor()
        follingNumber.font = UIFont.systemFontOfSize(12)
        follingNumber.snp_makeConstraints { (make) in
            make.centerX.equalTo(headerView!).offset(40)
            make.top.equalTo(userName.snp_bottom).offset(5)
        }
    }
    
    func fetchDeveloperInfo() {
        var name:String?
        if  developerName != nil {
            name = developerName! 
        }else {
            name = (developer?.login)!
        }
        Provider.sharedProvider.request(GitHubAPI.UserInfo(username: name!)) {[weak self] (result) in
            switch result {
            case let .Success(response):
                do{
                    if let result1:ObjUser = Mapper<ObjUser>().map(try response.mapJSON()) {
                        self!.developer = result1
                        self!.tableView.reloadData()
                        self?.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                    }
                }catch{
                    
                }
            case let .Failure(error):
                print(error)
            }
        }
    }
}
extension DeveloperViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print(offsetY)
        if fabs(offsetY) > headerHeight {
            var oldFrame = headerView?.frame
            oldFrame?.size.height = fabs(offsetY) - 64
            oldFrame?.origin.y = offsetY + 64
            headerView?.frame = oldFrame!
        }else{
        }
    }
}
extension DeveloperViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = (indexPath.section, indexPath.row)
        switch index {
        case (2,0):
            let repoList = RepoListViewController()
            repoList.developer = developer
            navigationController?.pushViewController(repoList, animated: true)
        default:
            print("等等")
        }
    }
}

extension DeveloperViewController:UITableViewDataSource {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        return 10
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 1
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.UserBaseInfoCell.rawValue, forIndexPath: indexPath) as? UserBaseInfoCell
            cell?.selectionStyle = .None
            switch indexPath.row {
            case 0:
                cell?.customUI(name: "地址", value: developer?.location ?? "他没有写")
            case 1:
                cell?.customUI(name: "公司", value: developer?.company ?? "他没有写")
            default:
                cell?.customUI(name: "简介", value: developer?.bio ?? "这个人很懒,什么都没有写!")
            }
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.RepoInfoCell.rawValue, forIndexPath: indexPath) as? RepoInfoCell
            cell?.customUI(UIImage(named: "octicon_person_25")!,actionName:"详细资料")
            return cell!
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.RepoInfoCell.rawValue, forIndexPath: indexPath) as? RepoInfoCell
            cell?.customUI(UIImage(named: "coticon_repository_25")!, actionName: "仓库")
            return cell!
        }
        
    }
}