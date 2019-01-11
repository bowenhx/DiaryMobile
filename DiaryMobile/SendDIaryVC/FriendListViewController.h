//
//  FriendListVC.h
//  BKMobile
//
//  Created by 薇 颜 on 15/8/29.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    FriendList_My = 0, //我的好友列表
    FriendList_Select,  //选择好友页面
} FriendList;

typedef void (^SelectFriendsBlock)(NSArray *usernames);

@interface FriendListViewController : BaseViewController

@property (nonatomic , copy) SelectFriendsBlock usernames;
@property (nonatomic , assign) FriendList friendType;


@end
