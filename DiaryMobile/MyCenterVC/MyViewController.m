//
//  MyViewController.m
//  DiaryMobile
//
//  Created by ligb on 2019/1/9.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import "MyViewController.h"


@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    
    
}

- (void)loadNewView {
    self.tableView.backgroundColor = kViewNormalBackColor.color;
    [self.tableView setTableHeaderView:[self userHeadView]];
    [self.tableView setTableFooterView:[self footerBtn]];
}

- (void)loadNewData {
    _dataSource = @[@"我的日记", @"关于"];
}

- (UIView *)userHeadView {
    UIView *iView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 180)];
    iView.backgroundColor = kViewNormalBackColor.color;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH - 65) / 2, 30, 65, 65)];
    imageView.image = [UIImage imageNamed:@"author_avatar"];
    imageView.layer.cornerRadius = 32.5f;
    imageView.clipsToBounds = YES;
    [iView addSubview:imageView];
    
    UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH - 100) / 2, imageView.max_Y + 15, 100, 25)];
    labText.textColor = [UIColor darkTextColor];
    labText.textAlignment = NSTextAlignmentCenter;
    labText.text = @"未登錄";
    [iView addSubview:labText];
    return iView;
}

- (UIView *)footerBtn {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, footerView.h - 44, kSCREEN_WIDTH - 40, 44);
    UIImage *image = [[UIImage imageNamed:@"header_bg"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3;
    [button setTitle:@"登錄" forState:UIControlStateNormal];
    [footerView addSubview:button];
    [button addTarget:self action:@selector(didSelectLoginAction) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}

- (void)didSelectLoginAction {
    
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
        
    }
    
}

@end
