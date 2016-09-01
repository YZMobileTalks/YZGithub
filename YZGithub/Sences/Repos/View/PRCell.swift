//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang
//  Github: https://github.com/YZMobileTalks
//
import UIKit
import Kingfisher

class PRCell: UITableViewCell {

    @IBOutlet weak var PRUserImage: UIImageView!
    @IBOutlet weak var PRTitle: UILabel!
    @IBOutlet weak var PRBody: UILabel!
    
    var prinfo:PullRequest? {
        didSet{
            PRUserImage.kf_setImageWithURL(NSURL(string: prinfo!.user!.avatar_url!)!)
            PRTitle.text = prinfo!.title!
            PRBody.attributedText = prinfo!.body!.richText()
            
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
