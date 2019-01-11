//
//  FriendListVC.m
//  BKMobile
//
//  Created by 薇 颜 on 15/8/29.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "FriendListVC.h"
#import "FriendListCell.h"
#import "UserInformationViewController.h"
#import "FriendModel.h"

@interface FriendListVC ()<UITableViewDataSource, UITableViewDelegate, FriendListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *friendList;
@property (nonatomic, strong) NSMutableArray *selectFriends;
@property (nonatomic, assign) NSUInteger selectIndex;
@end

@implementation FriendListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _selectIndex = 999;
    _friendList = [NSMutableArray array];
    _selectFriends = [NSMutableArray array];
    self.view.backgroundColor = [UIColor colorViewBg];
    
    //TableView
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setBackgroundView:nil];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(NAV_BAR_HEIGHT);
        }];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerNib:[UINib nibWithNibName:@"FriendListCell" bundle:nil] forCellReuseIdentifier:@"FriendListCell"];
    }
    __weak typeof(self)bself = self;
    //添加下拉刷新功能
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [bself requestFriendList];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];
}

- (void)loadNewView{
    if (_friendType == FriendList_My) {
        self.title = @"我的好友";
    }else if (_friendType == FriendList_Select){
        self.title = @"選擇好友";
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
}

- (void)tapRightBtn{
    NSLog(@"_selectFriends = %@",_selectFriends);
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:_selectFriends.count];
    [_selectFriends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FriendModel *model = [_friendList objectAtIndex:[obj integerValue]-10];
        [items addObject:model.username];
    }];
    
    if (_usernames) {
        _usernames (items);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    if (_friendType == FriendList_My) {
        [BKGoogleStatistics mGoogleScreenAnalytics:kMyCenterFriendIndex];
    } else {
        [BKGoogleStatistics mGoogleScreenAnalytics:kBlogPrivacySelectedFrd];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)headerView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.screen_W, 10.0)];
    [imageView setImage:[UIImage imageNamed:@"def_iv_Lace"]];
    return imageView;
}

#pragma mark - Private Method
- (void)requestFriendList{
    if (_friendList.count) {
        if (_friendType == FriendList_My) {
            [BKGoogleStatistics mGoogleScreenAnalytics:kMyCenterFriendIndex];
        } else {
            [BKGoogleStatistics mGoogleScreenAnalytics:kBlogPrivacySelectedFrd];
        }
       
    }
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [BKHttpUtil mHttpWithUrl:EAPI_Friend_List parameter:@{@"token":TOKEN, @"group": @"-1"} response:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else {
            NSArray *dataList = model.data;
            if (dataList.count) {
                [_friendList removeAllObjects];
                for (NSDictionary *dic in dataList) {
                    FriendModel *model = [[FriendModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_friendList addObject:model];
                }
                [_tableView reloadData];
            }
            [self.view showHUDTitleView:model.message image:nil];
        }
        [self.view removeHUDActivity];
       
        [_tableView endRefreshing];
    }];
}
#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _friendList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FriendListCell";
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    FriendModel *model = [_friendList objectAtIndex:indexPath.row];
    cell.nameLabel.text = model.username;
    cell.groupLabel.text = model.grouptitle;
    NSURL *urlIcon = [NSURL URLWithString:model.avatar];
    [cell.avatarImageView sd_setImageWithURL:urlIcon placeholderImage:nil];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    if (_friendType == FriendList_Select) {
        cell.delFriendBtn.hidden = YES;
        
    }
    
    return cell;
}
#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_friendType == FriendList_My) {
        FriendModel *model = [_friendList objectAtIndex:indexPath.row];
        UserInformationViewController *userInfoVC = [[UserInformationViewController alloc] initWithNibName:@"UserInformationViewController" bundle:nil];
        userInfoVC.avatar = model.avatar;
        userInfoVC.uid = model.uid;
        userInfoVC.name = model.username;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }else if (_friendType == FriendList_Select){
        FriendListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        __block NSUInteger index = 9999999;
        [_selectFriends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj integerValue] -10 == indexPath.row) {
                //判断是否点击的是同一个
                cell.accessoryType = UITableViewCellAccessoryNone;
                index = idx;
                *stop = true;
            }
        }];
        
        if (index == 9999999) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [_selectFriends addObject:@(indexPath.row+10)];
        }else{
             [_selectFriends removeObject:@(indexPath.row+10)];
        }

    }
    
}
#pragma mark - FriendListCellDelegate
- (void)friendListCellDeleteButtonClick:(NSIndexPath *)indexPath{
    
    [[[UIAlertView alloc] initWithTitle:nil message:@"是否解除好友關係？"
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        DLog(@"取消");
    }] otherButtonItems:[RIButtonItem itemWithLabel:@"確定" action:^{
        
        FriendModel *model = [_friendList objectAtIndex:indexPath.row];
        NSString *strId = [NSString stringWithFormat:@"%d",(int)model.uid];

        [self.view showHUDActivityView:@"正在加載..." shade:NO];
         //提交忽略信息到服務器
        [BKHttpUtil mHttpWithUrl:EAPI_Friend_Delete parameter:@{@"token":TOKEN, @"uid":strId} response:^(BKNetworkModel *model, NSString *netErr) {
            [self.view removeHUDActivity];
            if (netErr) {
                [self.view showHUDTitleView:netErr image:nil];
            }else {
                //解除成功
                [self.view showHUDTitleView:model.message image:nil];
                if (model.status == 1) {
                    [_friendList removeObjectAtIndex:indexPath.row];
                    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                    [_tableView reloadData]; //indexPath已经改变，必须刷新表格，防止再次解除好友关系时候出错
                }
            }
        }];
        
    }], nil] show];
    
}
@end
