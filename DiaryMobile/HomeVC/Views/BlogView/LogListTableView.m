//
//  LogListTableView.m
//  EduKingdom
//
//  Created by ligb on 2017/1/11.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "LogListTableView.h"
#import "KDefine.h"
#import "LogListModel.h"
#import "WebViewController.h"
//#import "UserInformationViewController.h"
//#import "MyBlogListViewController.h"
//#import "MotifViewController.h"
//#import "LogListViewController.h"
#import "DiaryListViewCell.h"
//#import "BKGoogleStatistics.h"

static NSString *BLOG_CELL = @"DiaryListViewCell";

@interface LogListTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSMutableArray *dataSource;
@property (nonatomic , strong) NSMutableArray <LogListModel *>* tempData;
@property (nonatomic , assign) BOOL isFirst;//记录是否是首次进入页面
@property (nonatomic , strong) NSMutableArray <NSMutableArray *> *vDataSource;
@end;
//  @[@[@"",@[6]],
//    @[@"",@[6]]]

@implementation LogListTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _page = 1;
        //添加刷新方法
        [self addRefreshing];
    }
    return self;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray <LogListModel *>*)tempData {
    if (!_tempData) {
        _tempData = [NSMutableArray array];
    }
    return _tempData;
}

- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.backgroundColor = kViewNormalBackColor.color;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_tabView];
        [_tabView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.bottom.right.left.equalTo(self);
        }];
        
        //注册xib
        [_tabView registerNib:[UINib nibWithNibName:BLOG_CELL bundle:nil] forCellReuseIdentifier:BLOG_CELL];  
    }
    return _tabView;
}

- (void)addRefreshing {
    //添加下拉刷新功能
    MJRefreshGifHeader* gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullLoadAction)];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tabView.mj_header = gifHeader;
    
    //添加上拉加载更多功能
    MJRefreshBackGifFooter* gifFooter = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadingAction)];
    self.tabView.mj_footer = gifFooter;
    self.tabView.mj_footer.hidden = YES;
}

- (void)goToFirstPage {
    _isPullRefresh = NO;
    _page = 1;
    [_tabView.mj_footer resetNoMoreData];
    [self refreshData];
}

#pragma mark - 刷新模块：下拉刷新
- (void)pullLoadAction{
    
    _isPullRefresh = YES;
    
    _page --;
    if (_page < 1 ) {
        _page = 1;
    }
    
    [_tabView.mj_footer resetNoMoreData];
    [self refreshData];
}

#pragma mark - 刷新模块：上拉加载更多
- (void)uploadingAction {
    _isPullRefresh = NO;
    _page ++;
    [self refreshData];
}

- (void)setAdBanners:(NSArray<UIView *> *)adBanners {
//    _adBanners = adBanners;
    if (self.tempData.count) {
        [self uniteLoadData];
    }
    
}

- (void)uniteLoadData {
//    [self.dataSource removeAllObjects];
//    if (_adBanners.count) {
//        NSArray *tempList = [LogListModel uniteListData:self.tempData];
//        [self.dataSource setArray:tempList];
//    } else {
        [self.dataSource setArray:self.tempData];
//    }
    
    [_tabView reloadData];
}

//刷新數據
- (void)refreshData {
    if (_blogListAll == BlogList_All) {
        //防止刷新时候，多次切换，导致数据不对应上方选择的标签
//        if ([self.controller isKindOfClass:[MotifViewController class]]) {
//            MotifViewController *vc = (MotifViewController *)self.controller;
//            vc.segmentedControl.userInteractionEnabled = NO;
//        }
        
        if (_isFirst) {
            //添加googel 统计
            [self mAddGoogleStatisticsAction];
        } else {
            _isFirst = YES;
        }
        
        [self showHUDActivityView:@"正在加載..." shade:NO];
        NSString *iCatid = string(_itemCatid.catid);
        [LogListModel loadBlogListType:iCatid order:_order page:_page block:^(NSArray *data, LogListPage *page, NSString *netErr) {
            [self removeHUDActivity];
            [_tabView endRefreshing];
            
            //数据过来以后，再准许切换上方，防止多次切换，数据不对应问题
//            if ([self.controller isKindOfClass:[MotifViewController class]]) {
//                MotifViewController *vc = (MotifViewController *)self.controller;
//                vc.segmentedControl.userInteractionEnabled = YES;
//            }
            
            if (netErr) {
                if ([netErr hasPrefix:@"沒有更多"] || [netErr hasPrefix:@"載入完成"]) {
                    [self showHUDTitleView:@"載入完成" image:nil];
                    [_tabView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self showHUDTitleView:netErr image:nil];
                }
            } else {
                [self.tempData setArray:data];
                [self uniteLoadData];
                
                if (_blogPage) {
                    page.selectPage = _page;
                    _blogPage (page);
                }
                
                //表滚动逻辑
                if (_isPullRefresh && _page != 1) {
                    [self mTableScrollToBottom];
                } else {
                    [self mTableScrollToTop];
                }
            }
        }];
        
    } else if (_blogListAll == BlogList_My) {
        if (_tempData.count) {
            //添加googel 统计
            [self mAddGoogleStatisticsAction];
        }
        [self showHUDActivityView:@"正在加載..." shade:NO];
        [LogListModel loadMyBlogListData:_page block:^(NSArray *data, LogListPage *page, NSString *netErr) {
            [self removeHUDActivity];
            if (netErr) {
                if ([netErr hasPrefix:@"沒有更多"] || [netErr hasPrefix:@"載入完成"]) {
                    [self showHUDTitleView:@"載入完成" image:nil];
                } else {
                    [self showHUDTitleView:netErr image:nil];
                }
            } else {
                [self.tempData setArray:data];
                [self uniteLoadData];
                if (_blogPage) {
                    page.selectPage = _page;
                    _blogPage (page);
                }
            }
            [_tabView endRefreshing];
            //表滚动逻辑
            if (_isPullRefresh && _page != 1) {
                [self mTableScrollToBottom];
            } else {
                [self mTableScrollToTop];
            }
            
            if ([netErr hasPrefix:@"沒有更多"] || page.max_page == _page) {
                [_tabView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _tabView.mj_footer.hidden = self.dataSource.count ? NO : YES;
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiaryListViewCell *cell = [_tabView dequeueReusableCellWithIdentifier:BLOG_CELL forIndexPath:indexPath];
    
    EKBlogCellType vType = EKBlogCellTypeWithNormalBlog;
    if (_blogListAll == BlogList_My) {
        vType = EKBlogCellTypeWithMyBlog;
    }
    UIView *typeView = (UIView *)[cell.contentView viewWithTag:9762];
    if (typeView != nil) {
        [typeView removeFromSuperview];
    }
    
    LogListModel *model = _dataSource[indexPath.row];
//    if (model.bannerView) {
//        NSArray *aList = [cell.contentView subviews];
//        for (UIView *aView in aList) {
//            [aView setHidden:YES];
//        }
//        //添加广告VIEW
//        [cell.contentView addSubview:model.bannerView];
//        model.bannerView.tag = 9762;
//        model.bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, model.height);
//    } else {
//        NSArray *aList = [cell.contentView subviews];
//        for (UIView *aView in aList) {
//            [aView setHidden:NO];
//        }
        [cell mRefreshBlogCell:model type:vType];
//    }
    //用戶頭像操作
    cell.userIcon.tag = indexPath.row;
    [cell.userIcon addTarget:self action:@selector(selectUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogListModel *model = _dataSource[indexPath.row];
    if (model.blogid == 0) {
        return 50;
    }
    return model.height + 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LogListModel *model = _dataSource[indexPath.row];
    WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webVC.vNavTitle = @"日誌";
    webVC.name = model.subject;
    webVC.ispassword = model.ispassword;
    webVC.uid = string(model.uid);
    webVC.tid = string(model.blogid);
    [self.controller.navigationController pushViewController:webVC animated:YES];
   
}

- (void)selectUserInfo:(UIButton *)btn {
    LogListModel *model = [_dataSource objectAtIndex:btn.tag];
    if (model.uid == [USERID integerValue]) {
        //点击用户自己，不可以查看资料
        return;
    }
//    UserInformationViewController *userInfoVC = [[UserInformationViewController alloc] initWithNibName:@"UserInformationViewController" bundle:nil];
//    userInfoVC.avatar = model.avatar;
//    userInfoVC.uid = model.uid;
//    userInfoVC.name = model.username;
//    [self.controller.navigationController pushViewController:userInfoVC animated:YES];
}

#pragma mark - 其他逻辑
//设置表滚动到最顶部
- (void)mTableScrollToTop {
    //reloadDate会在主队列执行，而dispatch_get_main_queue会等待机会，直到主队列空闲才执行。防止滚动不精确
    if (_dataSource.count > 1) {
        [_tabView scrollToTopWithAnimated:YES];
    }
}

//设置表滚动到最底部
- (void)mTableScrollToBottom {
    if (_dataSource.count > 1) {
        [_tabView scrollToBottomWithAnimated:YES];
    }
}

//添加google 统计
- (void)mAddGoogleStatisticsAction {
//    if ([self.order isEqualToString:ORDER_DATELINE]) {
//        [BKGoogleStatistics mGoogleScreenAnalytics:kNewBlogIndex];
//    } else if ([self.order isEqualToString:ORDER_HOT]) {
//        [BKGoogleStatistics mGoogleScreenAnalytics:kRecommendBlogIndex];
//    } else {
//        [BKGoogleStatistics mGoogleScreenAnalytics:kMyBlogIndex];
//    }
}

@end

