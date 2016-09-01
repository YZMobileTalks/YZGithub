//
//  Created by www.52learn.wang.
//  Copyright © 2016年 www.52learn.wang. All rights reserved.
//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178
//  博客：http://www.52learn.wang//  Github: https://github.com/wu2LearnTeam
//  微博：http://weibo.com/mobiledevelopment
//
import UIKit
import ObjectMapper


class PullInfo :NSObject,Mappable{
    var sha: String?
    var label: String?
    var user: ObjUser?
    var repo: Repository?
    var ref: String?
    
    override init() {
        
    }
    required init?(_ map: Map) {
        
    }
    func mapping(map: Map) {
        sha <- map["sha"]
        label <- map["label"]
        user <- map["User"]
        repo <- map["Repo"]
        ref <- map["ref"]
    }
    
}

class PullRequest: NSObject,Mappable {
    
    func mapping(map: Map) {
        milestone <- map["milestone"]
        locked <- map["locked"]
        title <- map["title"]
        url <- map["url"]
        merge_commit_sha <- map["merge_commit_sha"]
        commits_url <- map["commits_url"]
        review_comment_url <- map["review_comment_url"]
        updated_at <- map["updated_at"]
        review_comments_url <- map["review_comments_url"]
        updated_at <- map["updated_at"]
        review_comments_url <- map["review_comments_url"]
        user <- map["user"]
        body <- map["body"]
    }
    var milestone: String?
    var locked: NSNumber?
    var title: String?
    var url: String?
    var merge_commit_sha: String?
    var commits_url: String?
    var review_comment_url: String?
    var updated_at: String?
    var review_comments_url: String?
    var comments_url: String?
    var assignee: String?
    var Base: PullInfo?
    var patch_url: String?
    var merged_at: String?
    var state: String?
    var body: String?
    var id: NSNumber?
    var number: NSNumber?
    var issue_url: String?
    var user: ObjUser?
    var closed_at: String?
    var Head: PullInfo?
//    var assignees: Array?
    var statuses_url: String?
    var created_at: String?
//    var _links: _links?
    var diff_url: String?
    var html_url: String?
    required init?(_ map: Map) {
    }
    override init() {
    }
    
}
