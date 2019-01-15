//
//  MyViewController.m
//  DiaryMobile
//
//  Created by ligb on 2019/1/9.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import "MyViewController.h"
#import "LoginViewController.h"
#import "UserHelper.h"
#import "WebViewController.h"

@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIButton *outButton;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (LOGINSTATUS) {
        [self mLoginViewStatus];
    } else {
        [self mOutLoginViewStatus];
    }
}

- (void)loadNewView {
    self.tableView.backgroundColor = kViewNormalBackColor.color;
    [self.tableView setTableHeaderView:[self userHeadView]];
    [self.tableView setTableFooterView:[self footerBtn]];
}

- (void)loadNewData {
    _dataSource = @[@"我的日記", @"關於我們"];
}

- (void)mLoginViewStatus {
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:USER.avatar] placeholderImage:[UIImage imageNamed:@"author_avatar"]];
    _userName.text = USER.username;
    [_outButton setTitle:@"退出" forState:UIControlStateNormal];
}

- (void)mOutLoginViewStatus {
    [_userIcon setImage:[UIImage imageNamed:@"author_avatar"]];
    _userName.text = @"未登錄";
    [_outButton setTitle:@"登錄" forState:UIControlStateNormal];
}

- (UIView *)userHeadView {
    UIView *iView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 180)];
    iView.backgroundColor = kViewNormalBackColor.color;
    _userIcon = [[UIImageView alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH - 65) / 2, 30, 65, 65)];
    _userIcon.image = [UIImage imageNamed:@"author_avatar"];
    _userIcon.layer.cornerRadius = 32.5f;
    _userIcon.clipsToBounds = YES;
    [iView addSubview:_userIcon];
    
    _userName = [[UILabel alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH - 100) / 2, _userIcon.max_Y + 15, 100, 25)];
    _userName.textColor = [UIColor darkTextColor];
    _userName.textAlignment = NSTextAlignmentCenter;
    _userName.text = @"未登錄";
    [iView addSubview:_userName];
    return iView;
}

- (UIView *)footerBtn {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    _outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _outButton.frame = CGRectMake(20, footerView.h - 44, kSCREEN_WIDTH - 40, 44);
    UIImage *image = [[UIImage imageNamed:@"header_bg"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [_outButton setBackgroundImage:image forState:UIControlStateNormal];
    _outButton.layer.masksToBounds = YES;
    _outButton.layer.cornerRadius = 3;
    [_outButton setTitle:@"登錄" forState:UIControlStateNormal];
    [footerView addSubview:_outButton];
    [_outButton addTarget:self action:@selector(didSelectLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}

- (void)didSelectLoginAction:(UIButton *)btn {
    if (LOGINSTATUS) {
        CustomAlertController *customAlert = [[CustomAlertController alloc] init];
        customAlert.message(@"確定退出？").cancelTitle(@"取消").confirmTitle(@"確定").controller(self).alertStyle(alert);
        [customAlert show:nil confirmAction:^(UIAlertAction *action) {
            [self mLoginOutAction];
        } cancelAction:nil];
    } else {
        //登陆
        [LoginViewController initWithLoginVC:self from:@"myView"];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self showNextControllerName:@"FriendsTableViewController" params:@{@"title":@"我的日記"} isPush:YES];
    } else {
        [WebViewController pushOpenWebViewControllerWithURL:kDiaryAbout title:@"關於我們" withFromViewCotroller:self];
    }
    
}


#pragma mark - 退出登录
- (void)mLoginOutAction {
    [self.view showHUDActivityView:nil shade:NO];
    //退出登录
    [BaseNetworking mHttpWithUrl:kLoginLoginOut parameter:@{@"token":TOKEN} response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else{
            if (model.status == 1) {
                [self outLoginAction];
            } else {
                [self.view showHUDTitleView:model.message image:nil];
            }
        }
    }];
}


- (void)outLoginAction {
    //清除用户基本信息
    [UserHelper mClearUserInfoData];
    [self mOutLoginViewStatus];
}
@end
