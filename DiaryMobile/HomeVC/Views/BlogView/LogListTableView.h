//
//  LogListTableView.h
//  EduKingdom
//
//  Created by ligb on 2017/1/11.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogListModel.h"


//当order = dateline 时，获取的是最新发布日志列表
//#define ORDER_DATELINE  @"dateline"
////当order = hot 时，获取的是推荐阅读日志列表
//#define ORDER_HOT  @"hot"

typedef enum : NSUInteger {
    BlogList_All = 0,//日誌分類頁面
    BlogList_My      //我的日誌
} BlogListAll;

typedef void (^BlogListPageBlock)(LogListPage * page);

@interface LogListTableView : UIView
@property (nonatomic , strong) UIViewController *controller;
@property (nonatomic , assign) BlogListAll blogListAll;

@property (nonatomic , strong) UITableView *tabView;
//绑定分类catid 对象
@property (nonatomic , strong ) DiaryTypeModel *itemCatid;
//绑定导航条大分类order
@property (nonatomic , copy)NSString *order;

@property (nonatomic , copy)BlogListPageBlock blogPage;

@property (nonatomic , assign) NSInteger page;

//banner广告
//@property (nonatomic , strong) NSArray <BADBannerView *> *adBanners;

//手動下拉刷新,page 变化时的刷新
- (void)pullLoadAction;

//手動上拉加载,page 有变化
- (void)uploadingAction;

//刷新到第一页
- (void)goToFirstPage;


//自動刷新:这里只是刷新，不再做page 修改
- (void)refreshData;


//Yes代表下拉刷新，No代表上啦加载更多
@property (nonatomic , assign) BOOL isPullRefresh;

/**
 加载table 数据
 @param catid 日志分类
 @param order 分类类型：
 当order = dateline 时，获取的是最新发布日志列表
 当order = hot 时，获取的是推荐阅读日志列表
 */
//- (void)loadDataTabCatid:(NSString *)catid order:(NSString *)order;


@end
