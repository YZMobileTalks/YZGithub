//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import Moya
import Alamofire
import ObjectMapper
import DGElasticPullToRefresh


class ExploreDevelopersViewController: UIViewController {

    let cellIdentifier = "DeveloperTableViewCell"
    
    
    // MARK: Data
    let para = ParaSearchUser()
    var data = [ObjUser]()
    
    lazy var tableView: UITableView = {
        var table:UITableView = UITableView(frame: self.view.bounds)
        table.dataSource = self
        table.delegate = self
        table.registerNib(UINib(nibName: "DeveloperTableViewCell", bundle: nil), forCellReuseIdentifier: "DeveloperTableViewCell")
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        table.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
                self!.fetchDeveData()
            }, loadingView: loadingView)
        table.dg_setPullToRefreshFillColor(UIColor(red: 22/255, green: 150/255, blue: 122/255, alpha: 1))
        table.dg_setPullToRefreshBackgroundColor(table.backgroundColor!)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
        fetchDeveData()
    }
    
    func customUI() {
        
    }
    deinit {
        tableView.dg_removePullToRefresh()
    }
    func fetchDeveData() {
        Provider.sharedProvider.request(GitHubAPI.SearchUsers(para: para)) {[weak self] (result) in
            switch result{
            case let .Success(response):
                do{
                    if let userResult:SearchUserResponse = Mapper<SearchUserResponse>().map(try response.mapJSON()) {
                        
                        if userResult.items == nil{
                            return
                        }
                        
                        if self!.para.page == 1{
                            self!.data.removeAll()
                            self!.data += userResult.items!
                            self!.tableView.dg_stopLoading()
                            self!.tableView.reloadData()
                        }else {
                            self!.data += userResult.items!
                            self!.tableView.reloadData()
                        }
                    }
                }catch{
                    self!.tableView.dg_stopLoading()
                }
            case let .Failure(error):
                print(error)
                self!.tableView.dg_stopLoading()
            }
        }
    }
    func refeshingHandle() {
        para.page = 1
        fetchDeveData()
    }
    func footerRefesh() {
        para.page += 1
        fetchDeveData()
    }
}
extension ExploreDevelopersViewController:UIScrollViewDelegate {
  
}

extension ExploreDevelopersViewController:UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == data.count {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "next")
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DeveloperTableViewCell
        cell.deve = data[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == data.count {
            return 44
        }
        return 70
    }
}
extension ExploreDevelopersViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == data.count {
            footerRefesh()
        }else{
            let devVC = DeveloperViewController()
            devVC.developer = data[indexPath.row]
            parentViewController?.navigationController?.pushViewController(devVC, animated: true)
        }
    }
}