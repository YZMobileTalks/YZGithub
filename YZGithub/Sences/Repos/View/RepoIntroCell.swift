//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import Kingfisher

class RepoIntroCell: UITableViewCell {

    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoAuthor: UILabel!
    @IBOutlet weak var repoIntro: UILabel!
    var repoinfo:Repository? {
        didSet{
            repoImage.kf_setImageWithURL(NSURL(string: (repoinfo!.owner!.avatar_url)!)!)
            repoName.text = repoinfo?.name
            repoAuthor.text = repoinfo?.owner?.login
            repoIntro.text = repoinfo?.cdescription
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
    
}
