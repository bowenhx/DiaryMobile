/**
 -  User.h
 -  BKSDK
 -  Created by ligb on 16/11/24.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  用户信息模型类,存储了当前登录用户的id，token等值。
 */

#import <Foundation/Foundation.h>
#import "UserGroups.h"

//当前用户登录状态
#define LOGINSTATUS     [SaveUser mGetUser].token.length

#define USER        [SaveUser mGetUser]        //当前登录的user对象
#define TOKEN       ([SaveUser mGetUser].token.length > 0 ? [SaveUser mGetUser].token:@"")  //user 的 token
#define USERID      ([SaveUser mGetUser].uid.length > 0 ? [SaveUser mGetUser].uid : @"")    //user 的 id
#define USERGROUPS  [UserGroups mInitGroupsWithDic:[SaveUser mGetUser].groups]  //用户对象下包含的groups对象



@interface User : NSObject

@property (copy, nonatomic) NSString *adminid;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *groupid;
@property (copy, nonatomic) NSString *grouptitle;
@property (copy, nonatomic) NSString *loginovertime;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *username;
@property (strong, nonatomic) NSDictionary *groups;

@end


/**
 
 adminid = 1;
 avatar = "http://ucenter.baby-kingdom.com/avatar.php?uid=91893&size=big";
 email = "";
 groupid = 1;
 groups =     {
     isbanpost = 1;
     isbanuser = 1;
     isclosethread = 1;
     iseditpost = 1;
     ismanagereport = 1;
     ismovethread = 1;
     isviewip = 1;
     iswarnpost = 1;
 };
 grouptitle = "\U7ba1\U7406\U54e1";
 loginovertime = 0;
 token = "eNpFyk0OwiAQhuG7zLoL0FqhZyFpxoJ1klIqP6mx4e4SqnE387zfDpGsGVyK0MNFXFtkuoMG0jiMTpuCN4ZSCKYFdky20pRIy9398q7K1puQ5qigL5.xSHM5FShoFKwYwua8rvLGJz9t4VVLCsYvaE0tmiYaH46OQsdcciHPVVBbWr7Kq0zepfUvuVCIGFMowjPkD.jqRDw=";
 uid = 91893;
 username = digichoi;
 
 */
