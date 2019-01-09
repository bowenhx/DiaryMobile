//
//  BaseViewController.h
//  DiaryMobile
//
//  Created by ligb on 2019/1/9.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic , strong) UIButton *backBtn;

@property (nonatomic , strong) UIButton *rightBtn;

//初始化view
- (void)loadNewView;

//初始化数据
- (void)loadNewData;

//导航左边按钮点击事件
- (void)tapBackBtn;

//导航右边按钮点击事件
- (void)tapRightBtn;
@end

NS_ASSUME_NONNULL_END
