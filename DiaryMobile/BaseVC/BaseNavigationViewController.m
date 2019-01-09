//
//  BaseNavigationViewController.m
//  DiaryMobile
//
//  Created by ligb on 2019/1/9.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 设置背景
    [navBar setBackgroundImage:[UIImage imageNamed:@"header_bg"] forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
