/**
 -  SaveUser.h
 -  BKSDK
 -  Created by HY on 16/11/24.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  使用NSKeyedArchiver存储方式，本地存取user对象
 
 
 获得用户：
     User *user = [SaveUser mGetUser];
     
 获得用户下groups：
     UserGroups *groups = [UserGroups mInitGroupsWithDic:[SaveUser mGetUser].groups];
 
 
 */

#import <Foundation/Foundation.h>
#import "User.h"

@interface SaveUser : NSObject


/**
 *  @brief  ##使用NSKeyedArchiver的归档，保存用户信息
 *
 *  @param  user  需要存储的用户对象
 */
+ (void)mSaveUser:(User *)user;


/**
 *  @brief  ##获取本地存储的user对象
 *
 *  @return 返回user信息
 */
+ (User *)mGetUser;

@end
