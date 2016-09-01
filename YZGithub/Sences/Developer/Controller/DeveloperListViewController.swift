//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import ObjectMapper
import Alamofire

enum DeveListType {
    case Follewers
}

class DeveloperListViewController: BaseViewController {

    var developer:ObjUser?
    var developers:[ObjUser] = [ObjUser]()
    var listType:DeveListType? {
        didSet{
            switch listType! {
            case .Follewers:
                fetchFollewers()
            default:
                print("==")
            }
        }
    }
    
    lazy var tableView: UITableView? = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customUI()
    }
    func customUI() {
        view.addSubview(tableView!)
        title = "成员列表"
        tableView?.snp_makeConstraints(closure: { (make) in
            make.bottom.top.equalTo(view)
            make.width.height.equalTo(view)
        })
        tableView?.registerNib(UINib(nibName: "DeveloperTableViewCell",bundle: nil), forCellReuseIdentifier: "DeveloperTableViewCell")
    }
    func fetchFollewers() {
            Provider.sharedProvider.request(GitHubAPI.Followers(username: developer!.login!)) { [weak self](result) in
                switch result {
                case let .Success(value):
                    
                    do{
                    let string = try value.mapString()
                        print(string)
                    if let deves:[ObjUser] = try value.mapArray(ObjUser) {
                        self!.developers = deves
                        self?.tableView?.reloadData()
                        }
                    }catch{
                        print("解析失败")
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
extension DeveloperListViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let devInfo = DeveloperViewController()
        if listType != nil{
                devInfo.developer = developers[indexPath.row]
        }else{
                devInfo.developer = developer
        }
        self.navigationController?.pushViewController(devInfo, animated: true)
    }
}
extension DeveloperListViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listType != nil{
            return developers.count
        }else{
            return 1
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DeveloperTableViewCell",forIndexPath: indexPath) as? DeveloperTableViewCell
        if listType != nil{
                cell?.deve = developers[indexPath.row]
        }else{
                cell?.deve = developer
        }
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
}
