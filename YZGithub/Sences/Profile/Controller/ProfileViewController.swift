//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import SnapKit
import Static
import Kingfisher


class ProfileViewController: BaseViewController{
    
    var user:ObjUser?
    var isLogin:Bool?
    
    var tableView : UITableView?
    var profileImageView : UIImageView?
    var nameLable : UILabel?
    var followersLable:UILabel = UILabel()
    var startLable:UILabel = UILabel()
    var headerView:UIImageView?{
        return tableView?.viewWithTag(101) as? UIImageView
    }
    var datasource = DataSource()
    
    let identifier : String = "reuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //通知中心.注册登录成功和退出事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateUserinfoData), name: NotificationGitLoginSuccessful, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateUserinfoData), name: NotificationGitLogOutSuccessful, object: nil)

        tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        self.view.addSubview(tableView!)
        tableView?.delegate = self
        
        tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier as String)
        tableView?.tableFooterView = UIView()
        
        customUI()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setMyBackgroundColor(UIColor(red: 0/255.0, green: 130/255.0, blue: 210/255.0, alpha: 0))
    }
    
    func customUI() {
        
        tableView?.contentInset = UIEdgeInsetsMake(175 - 44, 0, 0, 0)
        
        let header:UIImageView = UIImageView(frame: CGRect(x: 0,y:-175,width: 375,height: 175))
        header.image = UIImage(named: "profile_bk")
        header.tag = 101
        header.contentMode = UIViewContentMode.ScaleAspectFill
        profileImageView = UIImageView(image: UIImage(named: "app_logo_90"))
        header.addSubview(profileImageView!)
        
        profileImageView!.snp_makeConstraints { (make) in
            make.centerX.equalTo(header)
            make.width.height.equalTo(80)
            make.centerY.equalTo(header).offset(0)
        }
        profileImageView!.layer.masksToBounds = true
        profileImageView!.layer.cornerRadius = 40
        
        tableView?.addSubview(header)
        
        self.navigationController?.navigationBar.setMyBackgroundColor(UIColor(red: 0/255.0, green: 130/255.0, blue: 210/255.0, alpha: 0))
        
        
        nameLable = UILabel()
        nameLable!.text = "登陆"
        nameLable?.font = UIFont.systemFontOfSize(14)
        nameLable?.textColor = UIColor.whiteColor()
        header.addSubview(nameLable!)
        nameLable!.snp_makeConstraints { (make) in
            make.centerX.equalTo(header)
            make.top.equalTo(profileImageView!.snp_bottom).offset(10);
        }
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.login(_:)))
        nameLable?.addGestureRecognizer(tap)
        nameLable?.userInteractionEnabled = true
        header.userInteractionEnabled = true
        
//        //粉丝和关注的人
        header.addSubview(followersLable)
        followersLable.textColor = UIColor.whiteColor()
        followersLable.font = UIFont.systemFontOfSize(13)
        followersLable.snp_makeConstraints { (make) in
            make.right.equalTo((nameLable?.snp_centerX)!).offset(-10)
            make.top.equalTo((nameLable?.snp_bottom)!).offset(10)
        }
        
        header.addSubview(startLable)
        startLable.textColor = UIColor.whiteColor()
        startLable.font = UIFont.systemFontOfSize(13)
        startLable.snp_makeConstraints { (make) in
            make.left.equalTo((nameLable?.snp_centerX)!).offset(10)
            make.top.equalTo(followersLable)
        }
        
        //自定义cell
        var rows = [[Row]]()
        let row = Row(text: "关注",cellClass: Value1Cell.self, selection: {(index) in
            print("\(index)")
        })
        let row3 = Row(text: "设置",cellClass: Value1Cell.self)
        let row4 = Row(text: "分享",cellClass: Value1Cell.self)
        let row5 = Row(text: "评个分呗!",cellClass: Value1Cell.self)
        let row6 = Row(text: "关于",cellClass: Value1Cell.self)
        rows = [[row],[row3],[row4,row5,row6]]
        
        let header2 = Section.Extremity.Title("联系我们")
        
        let view = UIView(frame: CGRectMake(0, 0, 1, 0.01))
        view.backgroundColor = UIColor.redColor()
        let title =  Section.Extremity.View(view)
        
        datasource.sections = [Section(rows:rows[0],footer:title,header:title),Section(rows:rows[1],footer:title),Section(header:header2, rows:rows[2])]
        datasource.tableView = tableView
        datasource.tableView?.delegate = self
        updateUserinfoData()
    }
    
    func login(tap:UITapGestureRecognizer){
        NetworkHelper.clearCookies()
        let loginVC = LoginViewController()
        let url = String(format: "https://github.com/login/oauth/authorize/?client_id=%@&redirect_uri=%@&scope=%@", GithubClientID,GithubRedirectUrl,"user,user:email,user:follow,public_repo,repo,repo_deployment,repo:status,delete_repo,notifications,gist,read:repo_hook,write:repo_hook,admin:repo_hook,admin:org_hook,read:org,write:org,admin:org,read:public_key,write:public_key,admin:public_key")
        loginVC.url = url
        loginVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    //MARK: 更新UI
    func updateUserinfoData() {
        user = UserInfoHelper.sharedInstance.user
        isLogin = UserInfoHelper.sharedInstance.isLogin
        if isLogin! == true {
            nameLable?.text = user?.name
            profileImageView?.kf_setImageWithURL(NSURL(string: user!.avatar_url!)!)
            followersLable.text = "\((user?.followers!)! as Int) 人关注"
            startLable.text = "关注\((user?.following!)! as Int)人"
        }else{
            nameLable?.text = "登陆"
            profileImageView?.image = UIImage(named: "app_logo_90")
            followersLable.text = ""
            startLable.text = ""
        }
    }
}

extension ProfileViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //下拉
        if scrollView.contentOffset.y < -175 {
            print(scrollView.contentOffset.y)
            var frame = headerView?.frame
            frame?.size.height = fabs(scrollView.contentOffset.y)
            frame?.origin.y = scrollView.contentOffset.y
            headerView?.frame = frame!
        }else{//上拉
            
        }
        
    }
}
extension ProfileViewController:UITableViewDelegate, UMSocialUIDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = (indexPath.section,indexPath.row)
        switch index {
        case (0,0):
            if !isUserLogin() {
                GlobalHubHelper.showError("请先登陆", view: view)
                return
            }
            let follewVC = DeveloperListViewController()
            follewVC.developer = user
            follewVC.listType = DeveListType.Follewers
            self.navigationController?.pushViewController(follewVC, animated: true)
        case (2,0):
            UMSocialSnsService.presentSnsIconSheetView(self, appKey: "56025946e0f55a744000439c", shareText: "加入我们吧!", shareImage: UIImage(named: "app_logo_90"), shareToSnsNames: [UMShareToSina], delegate: self)
        case (1,0):
            let setVC = SettingViewController()
            navigationController?.pushViewController(setVC, animated: true)
        default:
            print("等会")
        }
    }
    func isUserLogin()  -> Bool {
        return user  == nil ? false : true 
    }
}