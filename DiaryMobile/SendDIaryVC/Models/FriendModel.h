//
//  FriendModel.h
//  BKMobile
//
//  Created by HY on 16/5/26.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//
//  我的页面，我的好友模型

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property (nonatomic, copy) NSString    *avatar;
@property (nonatomic, copy) NSString    *grouptitle;
@property (nonatomic, copy) NSString    *recentnote;
@property (nonatomic, copy) NSString    *username;
@property (nonatomic, assign) NSInteger gid;
@property (nonatomic, assign) NSInteger groupid;
@property (nonatomic, assign) NSInteger uid;

@end

/*
 avatar = "http://ucenter.baby-kingdom.com/avatar.php?uid=1430030&size=small";
 gid = 1;
 groupid = 5;
 grouptitle = "\U7981\U6b62\U8a2a\U554f";
 recentnote = "";
 uid = 1430030;
 username = ccforbowl;
 */
