/**
 -  UserGroups.h
 -  BKSDK
 -  Created by HY on 16/11/24.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  存储用户下groups信息，使用方法：
     User *user = [SaveUser mGetUser];
     UserGroups *groups = [UserGroups mInitGroupsWithDic:user.groupsDic];
 
 */

#import <Foundation/Foundation.h>

@interface UserGroups : NSObject

@property (copy, nonatomic) NSString *isbanpost;
@property (copy, nonatomic) NSString *isbanuser;
@property (copy, nonatomic) NSString *isclosethread;
@property (copy, nonatomic) NSString *iseditpost;
@property (copy, nonatomic) NSString *ismanagereport;
@property (copy, nonatomic) NSString *ismovethread;
@property (copy, nonatomic) NSString *isviewip;
@property (copy, nonatomic) NSString *iswarnpost;


/**
 *  @brief  ##初始化用户下groups对象
 *
 *  @param  dic 包含用户groups信息的字典
 *  @return 返回用户信息中的groups对象
 */
+(instancetype)mInitGroupsWithDic:(NSDictionary *)dic;

@end
