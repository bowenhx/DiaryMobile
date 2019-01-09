//
//  BaseViewController.m
//  DiaryMobile
//
//  Created by ligb on 2019/1/9.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewNormalBackColor.color;
    
    
    [self loadNewView];
    
    [self loadNewData];
}

- (void)loadNewView {
    
}

- (void)loadNewData {
}

- (void)tapBackBtn {
    
}

- (void)tapRightBtn {
    
}


- (UIButton *)backBtn {
    if (nil == _backBtn) {
        //返回按钮
        UIImage *backImage = [UIImage imageNamed:@"def_btn_Return_unpressed"];
        _backBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
        [_backBtn setImage: backImage forState: UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [_backBtn addTarget: self action: @selector(tapBackBtn) forControlEvents: UIControlEventTouchUpInside];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView: _backBtn];
        left.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem = left;
    }
    return _backBtn;
}


- (UIButton *)rightBtn{
    if (nil == _rightBtn) {
        //右按钮
        _rightBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 70, 44);
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        [_rightBtn addTarget: self action: @selector(tapRightBtn) forControlEvents: UIControlEventTouchUpInside];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView: _rightBtn];
        right.style = UIBarButtonItemStylePlain;
        self.navigationItem.rightBarButtonItem = right;
    }
    return _rightBtn;
}

@end
