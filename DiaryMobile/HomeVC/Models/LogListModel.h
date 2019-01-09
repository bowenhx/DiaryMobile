//
//  LogListModel.h
//  EduKingdom
//
//  Created by ligb on 2017/1/11.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDefine.h"


@class LogListPage;

typedef void (^ListDataBlock)(NSArray * data , LogListPage *page, NSString *netErr);
typedef void (^BlogTypeBlock)(NSArray *data , NSString *netErr);

//列表中page
@interface LogListPage : NSObject
///// 后台返回的数据
@property (nonatomic , assign) NSInteger total;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , assign) NSInteger size;
@property (nonatomic , assign) NSInteger max_page;
/////
@property (nonatomic , assign) NSInteger selectPage;//该参数作为页面选择page
@end


//列表日志内容数据
@interface LogListModel : BKNetworkModel
@property (nonatomic , copy) NSString *username;
@property (nonatomic , copy) NSString *avatar;
@property (nonatomic , copy) NSString *subject;
@property (nonatomic , copy) NSString *dateline;
@property (nonatomic , copy) NSString *mesg;

@property (nonatomic , assign) NSInteger catid;
@property (nonatomic , assign) NSInteger blogid;
@property (nonatomic , assign) NSInteger uid;
@property (nonatomic , assign) NSInteger viewnum;
@property (nonatomic , assign) NSInteger replynum;
@property (nonatomic , assign) NSInteger ispassword;
@property (nonatomic , assign) float height;

//获取日志分类列表信息
+ (void)loadBlogListType:(NSString *)catid order:(NSString *)order page:(NSInteger)page block:(ListDataBlock)block;

//获取我的日志列表信息
+ (void)loadMyBlogListData:(NSInteger)page block:(ListDataBlock)block;

//获取我的好友日志列表
+ (void)loadMyFriendBlogListData:(NSInteger)page block:(ListDataBlock)block;

//合并广告数据
+ (NSArray *)uniteListData:(NSArray *)data;
@end


//日志分类数据
@interface BlogTypeList : NSObject <NSCoding>
@property (nonatomic , assign) NSInteger catid;
@property (nonatomic , copy) NSString *catname;

+ (void)getBlogTypeListBlock:(BlogTypeBlock)block;

@end
