//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import Kingfisher
import JLSwiftRouter

class EventCell: BaseCell {

    @IBOutlet weak var eventOwnerAvator: UIImageView!
    @IBOutlet weak var eventLabel: UITextView!
    @IBOutlet weak var EventInfo: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var eventTypeImage: UIImageView!
    
    override func setModel<T>(model: T) {
        let event = model as? Event
        if let e = event {
            if let url = e.actor?.avatar_url {
                    self.eventOwnerAvator.kf_setImageWithURL(NSURL(string: url)!)
            }
            if let type = e.type {
                switch type {
                case .IssueCommentEvent:
                    self.eventTypeImage.image = UIImage(named: "octicon_comment_15")
                    if let body = e.payload?["comment"]?["body"] {
                        var text = (body as? String)?.stringByReplacingOccurrencesOfString(" ", withString: "")
                       text = text?.stringByReplacingOccurrencesOfString("\n", withString: "")
                        text = text?.stringByReplacingOccurrencesOfString("\r", withString: "")
                        self.EventInfo.text = text
                    }
                case .PullRequestEvent:
                    self.eventTypeImage.image = UIImage(named: "octicon_pull_request_25")
                    self.EventInfo.text = ""
                case .WatchEvent:
                    self.eventTypeImage.image = UIImage(named: "octicon_star_20")
                    self.EventInfo.text = ""
                case .CreateEvent:
                    self.eventTypeImage.image = UIImage(named: "octicon_repo_15")
                    self.EventInfo.text = ""
                case .PushEvent:
                    self.eventTypeImage.image = UIImage(named: "octicon_push_25")
                    let commit =  (e.payload!["commits"] as! [AnyObject])[0] as? [String:AnyObject?]
                    if let commit = commit {
                            self.EventInfo.text = commit["message"]! as? String
                    }
                }
            }
            generateEvent(e)
        }
    }
    func generateEvent(e:Event) {
        if let type = e.type {
            var eventinfo:NSMutableAttributedString?
            self.eventLabel.attributedText = NSMutableAttributedString (string: "")
            var info = ""
            if let name = e.actor?.login{
                    switch type {
                    case .IssueCommentEvent:
                            info  =   name  + "  " + (e.payload?["action"] as! String) + " issue  " + (e.repo?.name)!
                    case .PullRequestEvent:
                            info  = name  + "  " + (e.payload?["action"] as! String) + " pull request  " + (e.repo?.name)!                        
                    case .WatchEvent:
                            info = name  + "  " + (e.payload?["action"] as! String) + "  " + (e.repo?.name)!                        
                    case .CreateEvent:
                            info = name  + "  created " + (e.payload?["ref_type"] as! String) + "  " + (e.repo?.name)!                        
                    case .PushEvent:
                            info = name  + "  pushed to  " + (e.payload?["ref"] as! String) + " at  " + (e.repo?.name)!
                        }
                eventinfo = NSMutableAttributedString(string:info, attributes: [:])
                eventinfo?.linkWithString(name,inString: info,url: "/user/\(name)")
                let urlstart = e.repo?.url?.rangeOfString("/repos")?.startIndex
                let url = e.repo?.url?.substringFromIndex(urlstart!)
                eventinfo?.linkWithString((e.repo?.name)!,inString: info,url: url!)
            }
            if   let temp = eventinfo {
                self.eventLabel.attributedText = temp
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventLabel.delegate = self
        eventLabel.editable = false
        eventLabel.scrollEnabled = false
        eventLabel.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
extension BaseCell:UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let router = Router.sharedInstance
        router.routeURL(URL.absoluteString) 
        return true
    }
}
