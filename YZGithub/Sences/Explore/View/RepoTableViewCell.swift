//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import SwiftDate
import Kingfisher

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoLastActiveTime: UILabel!
    @IBOutlet weak var repoStarNumber: UILabel!
    @IBOutlet weak var repoInfo: UILabel!
    @IBOutlet weak var repoForkNumber: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!
    
    var repo:Repository? {
        
        didSet{
            updateUI()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI() {
        repoName.text = repo?.name
        repoInfo.text = repo?.cdescription
        repoForkNumber.text = "\(repo!.forks_count!)"
        repoStarNumber.text = "\(repo!.stargazers_count!)"
        repoLastActiveTime.text = (repo!.pushed_at!.toDate(DateFormat.ISO8601)?.toRelativeString(abbreviated: false, maxUnits: 1))! + " age"
        if let lan = repo?.language {
            repoLanguage.text = lan
        }
        
        repoImage.kf_setImageWithURL(NSURL(string: (repo?.owner!.avatar_url)!)!)
    }
    
}
