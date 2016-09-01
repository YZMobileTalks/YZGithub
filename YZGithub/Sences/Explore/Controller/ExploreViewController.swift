//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import UIKit
import XMSegmentedControl
import SnapKit

class ExploreViewController: BaseViewController {


    var segmentView: XMSegmentedControl!
    let scrollView:UIScrollView = UIScrollView()
    var scrollHeight:CGFloat {
        return UIScreen.mainScreen().bounds.height - 66 - 44 - 44
    }
    var viewWidth:CGFloat {
        return self.view.bounds.size.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customUI()
    }
    func customUI() {
        segmentView = XMSegmentedControl(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 44), segmentTitle: ["仓库","开发者"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.TopEdge)
        
        segmentView.backgroundColor = UIColor(red: 22/255, green: 150/255, blue: 122/255, alpha: 1)
        segmentView.highlightColor = UIColor(red: 25/255, green: 180/255, blue: 145/255, alpha: 1)
        segmentView.tint = UIColor.whiteColor()
        segmentView.highlightTint = UIColor.blackColor()
        segmentView.delegate = self
        self.view.addSubview(segmentView)
        
        self.view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.top.equalTo(segmentView.snp_bottom)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view.snp_bottom).offset(-44)
        }
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(self.view.frame.width * 2, scrollView.bounds.height)
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.redColor()
        
        //仓库页面
        let repo = ExploreReposViewController()
        let table1 = repo.tableView
        table1.frame = CGRectMake(0, 0, viewWidth, scrollHeight)
        scrollView.addSubview(table1)
        self.addChildViewController(repo)
        
        //开发者页面
        let deve = ExploreDevelopersViewController()
        let table2 = deve.tableView
        table2.frame = CGRectMake(viewWidth, 0, viewWidth, scrollHeight)
        scrollView.addSubview(table2)
        self.addChildViewController(deve)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
extension ExploreViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x > viewWidth {
            segmentView.selectedSegment = 1
        }else{
            segmentView.selectedSegment = 0
        }
    }
}

extension ExploreViewController:XMSegmentedControlDelegate{
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        print(selectedSegment)
        if selectedSegment == 1 {
            UIView.animateWithDuration(0.2, animations: {
                    self.scrollView.contentOffset = CGPoint(x: self.viewWidth, y: 0)
            })
        }else {
            UIView.animateWithDuration(0.2, animations: {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            })
            
        }
    }
}
extension XMSegmentedControl{
    
}
