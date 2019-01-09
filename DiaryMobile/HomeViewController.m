//
//  HomeViewController.m
//  DiaryMobile
//
//  Created by ligb on 2019/1/9.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (nonatomic , strong)UISegmentedControl *segmentedControl;     //标签类型
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)loadNewView {
     [self loadNavSegmentedVCTitle:@[@"最 新",@"推 薦"] views:nil];
}

- (void)loadNavSegmentedVCTitle:(NSArray *)titles views:(NSArray *)views {
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

- (void)selectTitleType:(UISegmentedControl *)send {
    
    
}


- (void)editBlogAction {
    
}
@end
