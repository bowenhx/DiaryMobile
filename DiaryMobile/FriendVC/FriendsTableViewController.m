//
//  FriendsTableViewController.m
//  DiaryMobile
//
//  Created by ligb on 2019/1/10.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "KDefine.h"
#import "DiaryListViewCell.h"
#import "LogListModel.h"
#import "WebViewController.h"
#import "LoginViewController.h"

static NSString *kBLOG_CELL = @"DiaryListViewCell";

@interface FriendsTableViewController ()

//好友日志，数据源
@property (nonatomic , strong) NSMutableArray *dataSource;
//临时数据
@property (nonatomic , strong) NSMutableArray <LogListModel *>* tempData;

//我的日志，好友日志，页码
@property (nonatomic , assign) NSInteger vPage;

//Yes代表下拉刷新，No代表上啦加载更多
@property (nonatomic , assign) BOOL isPullRefresh;

@property (nonatomic, strong) UIView *backView;
@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _navTitle ? _navTitle : @"好友日記";
    
    [self loadNewView];
}

- (void)setParames:(id)parames {
    NSString *str = parames[@"title"];
    _navTitle = str;
    self.navigationItem.title = str;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (LOGINSTATUS) {
        _backView.hidden = YES;
        self.tableView.scrollEnabled = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (!self.dataSource.count) {
            [self.tableView.mj_header beginRefreshing];
        }
    } else {
        _backView.hidden = NO;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([self.view viewWithTag:1000]) {
            NSLog(@"不處理");
        } else {
            [self.view addSubview:self.backView];
        }
    }
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backView.tag = 1000;
        _backView.w = kSCREEN_WIDTH;
        _backView.backgroundColor = kViewNormalBackColor.color;
        UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake(20, kSCREEN_HEIGHT / 2 - 100, kSCREEN_WIDTH - 40, 50)];
        labText.text = @"點擊登錄";
        labText.font = [UIFont systemFontOfSize:20];
        labText.textAlignment = NSTextAlignmentCenter;
        labText.textColor = [UIColor darkGrayColor];
        
        [_backView addSubview:labText];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = _backView.bounds;
        btn.backgroundColor = [UIColor clearColor];
        [_backView addSubview:btn];
        [btn addTarget:self action:@selector(showLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backView;
}

- (void)loadNewView {
    _dataSource = [NSMutableArray array];
    _tempData = [NSMutableArray array];
    self.tableView.backgroundColor = kViewNormalBackColor.color;
    //注册xib
    [self.tableView registerNib:[UINib nibWithNibName:kBLOG_CELL bundle:nil] forCellReuseIdentifier:kBLOG_CELL];
    //添加下拉刷新功能
    MJRefreshGifHeader* gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullLoadAction)];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = gifHeader;
    
    
    //添加上拉加载更多功能
    MJRefreshBackGifFooter* gifFooter = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadingAction)];
    self.tableView.mj_footer = gifFooter;
    self.tableView.mj_footer.hidden = YES;

}

- (void)showLoginAction {
    [LoginViewController initWithLoginVC:self from:@"Friends"];
}


//下拉刷新
- (void)pullLoadAction {
    _isPullRefresh = YES;
    _vPage--;
    if (_vPage < 1 ) {
        _vPage = 1;
    }
    [self.tableView.mj_footer resetNoMoreData];
    [self refreshMyTableView];
}

//上啦加载
- (void)uploadingAction {
    _isPullRefresh = NO;
    _vPage ++;
    [self refreshMyTableView];
}

- (void)refreshMyTableView {
    if (_navTitle) {
        [self refreshMyBlogData];
    } else {
        [self refreshMyFriendBlogData];
    }
    
}

//好友日志
- (void)refreshMyFriendBlogData {
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [LogListModel loadMyFriendBlogListData:_vPage block:^(NSArray *data, LogListPage *page, NSString *netErr) {
        [self.view removeHUDActivity];
        
        [self.tableView endRefreshing];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        } else {
            [self.tempData setArray:data];
            [self uniteLoadData];
        }
        
        if ([netErr hasPrefix:@"沒有更多"] || page.max_page == _vPage) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}


- (void)refreshMyBlogData {
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [LogListModel loadMyBlogListData:_vPage block:^(NSArray *data, LogListPage *page, NSString *netErr) {
        [self.view removeHUDActivity];
        [self.tableView endRefreshing];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        } else {
            if (!data.count) {
                [self.view showHUDTitleView:@"沒有更多數據" image:nil];
            }
            [self.tempData setArray:data];
            [self uniteLoadData];
            
        }
        
        if ([netErr hasPrefix:@"沒有更多"] || page.max_page == _vPage) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
}

- (void)uniteLoadData {
    [self.dataSource setArray:self.tempData];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.mj_footer.hidden = self.dataSource.count ? NO : YES;
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiaryListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBLOG_CELL forIndexPath:indexPath];
    LogListModel *model = _dataSource[indexPath.row];
    [cell mRefreshBlogCell:model type:_navTitle ? EKBlogCellTypeWithMyBlog : EKBlogCellTypeWithNormalBlog];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogListModel *model = _dataSource[indexPath.row];
    if (model.blogid == 0) {
        return 50;
    }
    return model.height + 55;
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
    [self.navigationController pushViewController:webVC animated:YES];

}

@end
