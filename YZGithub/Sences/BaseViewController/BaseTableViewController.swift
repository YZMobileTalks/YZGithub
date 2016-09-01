//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import UIKit
import SnapKit

class BaseTableViewController<T>: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil  , bundle: nibBundleOrNil)
    }
    
    var dataArray:[T]? {
        didSet{
            self.tableView.reloadData()
        }
    }
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    var cellName:String? {
        let name =  NSStringFromClass(T.self as! AnyClass) + "Cell"
        let cellname = name.componentsSeparatedByString(".")
         return cellname[1]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTableView()
    }
    func customTableView() {
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.size.left.top.equalTo(self.view)
        }
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerNib(UINib(nibName: cellName!,bundle: nil), forCellReuseIdentifier: cellName!)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //MARK: DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray != nil {
            return dataArray!.count 
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellName!, forIndexPath: indexPath) as? BaseCell
        cell?.setModel(dataArray![indexPath.row])
        cell!.selectionStyle = .None
        return cell!
    }
}
