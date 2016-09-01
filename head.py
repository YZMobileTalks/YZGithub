#! usr/bin/python
#coding=utf-8

import os
path = os.path.abspath(os.curdir)
print path

def getfileName(path):
    list = os.listdir(path)
    for l in list:
        if os.path.isdir(os.path.join(path,l)):
            if l == "Pods":
                print "这是第三方"
            else:
                getfileName(os.path.join(path,l))
        else:
            if ".swift" in l:
#                 print os.path.join(path,l)
                f=open(os.path.join(path,l),'r+')
                flist=f.readlines(8)
#                 print flist
                flist[0] = "//\n"
                flist[1] = "//  Created by www.52learn.wang.\n"
                flist[2] = "//  Copyright © 2016年 www.52learn.wang. All rights reserved.\n"
                flist[3] = "//  QQ群－》ObjC:343640780 Swift:172090834 ReactNative:555705178\n"
                flist[4] = "//  博客：http://www.52learn.wang"
                flist[5] = "//  Github: https://github.com/wu2LearnTeam\n"
                flist[6] = "//  微博：http://weibo.com/mobiledevelopment\n"
                flist[7] = "//\n"
                flist.insert(8,"")
                f=open(os.path.join(path,l),'w+')
                f.writelines(flist)
#                 print('----' + f.readlines(1)[0])

getfileName(path)
