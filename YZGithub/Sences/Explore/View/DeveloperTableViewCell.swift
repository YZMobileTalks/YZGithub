//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import Alamofire
import Kingfisher

class DeveloperTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLable: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!    
    @IBOutlet weak var userInfo: UILabel!
    
    var deve:ObjUser? {
        didSet{
           userImage.kf_setImageWithURL(NSURL(string: deve!.avatar_url!)!)
            userName.text = deve!.login
            userInfo.text = deve!.email
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
