//
//  HomeViewController.m
//  DiaryMobile
//
//  Created by ligb on 2019/1/9.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import "HomeViewController.h"
#import "LogListModel.h"
#import "CustomScrollerHeadView.h"
#import "LogListTableView.h"

#define SELECTPAGE_VIEW_HEIGHT 45   //选择页数弹出的自定义view高度
//当order = dateline 时，获取的是最新发布日志列表
#define ORDER_DATELINE  @"dateline"
//当order = hot 时，获取的是推荐阅读日志列表
#define ORDER_HOT  @"hot"

@interface HomeViewController () <UIScrollViewDelegate> {
    __weak IBOutlet CustomScrollerHeadView *_customScrollerView;
}
@property (nonatomic , assign) NSInteger selectedIndex;
//标签类型
@property (nonatomic , strong)UISegmentedControl *segmentedControl;     //标签类型
@property (nonatomic , strong) LogListTableView *selectBlogView;
@property (nonatomic , strong) NSMutableArray <LogListTableView *> *vTableViews;
@property (nonatomic , strong) LogListPage  *listPage;

//我的日志，好友日志，数据源
@property (nonatomic , strong) NSMutableArray *dataSource;
//临时数据
@property (nonatomic , strong) NSMutableArray <LogListModel *>* tempData;

//我的日志，好友日志，页码
@property (nonatomic , assign) NSInteger vPage;

//Yes代表下拉刷新，No代表上啦加载更多
@property (nonatomic , assign) BOOL isPullRefresh;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}




- (void)loadNewView {
    [self mLoadNavSegmentedVCTitle:@[@"最 新",@"推 薦"] views:nil];
}

- (void)mLoadNavSegmentedVCTitle:(NSArray *)titles views:(NSArray *)views {
    //设置SegmentedControl 为标题view
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:titles];
    
    CGRect rect = CGRectMake(0, 0, 250, 30);
    if (IPHONE5) {
        rect = CGRectMake(0, 0, 200, 30);
    }
    
    _segmentedControl.frame = rect;
    _segmentedControl.tintColor = [UIColor whiteColor];
    _segmentedControl.selectedSegmentIndex = 0;
    
    NSDictionary *textFontDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil];
    [_segmentedControl setTitleTextAttributes:textFontDic forState:UIControlStateNormal];
    [_segmentedControl addTarget:self action:@selector(selectTitleType:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;
    
    //创建右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"def_btn_Edit_unpressed"]                                 style:UIBarButtonItemStylePlain target:self action:@selector(editBlogAction)];
}

- (void)loadNewData {
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
    [BlogTypeList getBlogTypeListBlock:^(NSArray *data, NSString *netErr) {
        [self.view removeHUDActivity];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        } else {
            [self addItemViewsData:data];
            
            //保存分类对象
            NSData *objData = [NSKeyedArchiver archivedDataWithRootObject:data];
            //创建分类对象的路径
            NSString *path = [BKTool getLibraryDirectoryPath:kBlogTypeKey];
            //把数据写入文件
            if ([objData writeToFile:path atomically:YES]) {
                NSLog(@"Write File Cusseece");
            }
        }
    }];
}

- (void)addItemViewsData:(NSArray *)data {
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:data.count];
    _vTableViews = [NSMutableArray arrayWithCapacity:data.count];
    //初始化页面分类view
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BlogTypeList *list = (BlogTypeList*)obj;
        [titles addObject:list.catname];
        
        //创建分类view
        LogListTableView *blogView = [[LogListTableView alloc] init];
        blogView.itemCatid = list;
        blogView.controller = self;
        blogView.order = ORDER_DATELINE;
        [_vTableViews addObject:blogView];
    }];
    
    CGFloat height = self.hidesBottomBarWhenPushed ? (self.screen_H - 64) : (self.screen_H - 64 - 49);
    //组装显示分类view
    [_customScrollerView addItemView:_vTableViews title:titles height:height];
    @WeakObj(self);
    //滑动或者点击分类
    _customScrollerView.itemsEcentAction = ^(NSInteger index) {
        selfWeak.selectBlogView = _vTableViews[index];
    };
    
    self.selectBlogView = _vTableViews[0];
}


- (void)setSelectBlogView:(LogListTableView *)selectBlogView {
    _selectBlogView = selectBlogView;
    [self refreshTabLoadData];
}

- (void)refreshTabLoadData {
    [_selectBlogView refreshData];
    @WeakObj(self);
    _selectBlogView.blogPage = ^(LogListPage *listPage) {
        selfWeak.listPage = listPage;
        NSLog(@"selectPage = %ld",(long)listPage.selectPage);
    };
}

#pragma mark - 切换顶部按钮 @"最新",@"推薦"
- (void)switchScrollerView {
    NSLog(@"select index = %ld",(long)self.selectedIndex);
    [_vTableViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LogListTableView *blogView = (LogListTableView *)obj;
        blogView.order = self.selectedIndex ?  ORDER_HOT : ORDER_DATELINE;
    }];
    
    _selectBlogView.page = 1;
    [self refreshTabLoadData];
}

- (void)selectTitleType:(UISegmentedControl *)send {
    [_vTableViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LogListTableView *blogView = (LogListTableView *)obj;
        blogView.order = send.selectedSegmentIndex ?  ORDER_HOT : ORDER_DATELINE;
    }];
    _selectBlogView.page = 1;
    [self refreshTabLoadData];
}


- (void)editBlogAction {
    [super showNextControllerName:@"EditDiaryViewController" params:nil isPush:YES];
}
@end
