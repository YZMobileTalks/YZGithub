//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit

class MessageCell: UITableViewCell {

    var message:Message? {
        didSet{
            if let reason = message?.reason {
                switch reason {
                case Reason.subscribed:
                    messageTypeImage.image = UIImage(named: "octicon_watch_20")
                default:
                    messageTypeImage.image = UIImage(named: "octicon_pull_request_25")
                }
            }
            if let title = message?.subject?.title {
                messageTitle.text = title
            }
            if let time = message?.updated_at {
                messageTime.text = time
            }
        }
    }
    
    @IBOutlet weak var messageTypeImage: UIImageView!
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
