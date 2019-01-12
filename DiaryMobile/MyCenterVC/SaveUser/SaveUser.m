/**
 -  SaveUser.m
 -  BKSDK
 -  Created by HY on 16/11/24.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#import "SaveUser.h"
#import "KDefine.h"

static NSString *const kUserData = @"userInfo.db";

static User *currUser;

@implementation SaveUser

#pragma mark - 保存用户信息
+ (void)mSaveUser:(User *)user {
    NSString *cachePath = [BKTool getDocumentsPath:kUserData];
    BOOL result = [NSKeyedArchiver archiveRootObject:user toFile:cachePath]; //归档
    if (result) {
        currUser = user;
    }
}


#pragma mark - 获取用户信息
+ (User *)mGetUser {
    if (nil != currUser) {
        return currUser;
    }
    NSString *cachePath = [BKTool getDocumentsPath:kUserData];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    return user;
}


@end
