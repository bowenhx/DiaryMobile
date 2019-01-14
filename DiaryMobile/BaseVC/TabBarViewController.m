//
//  TabBarViewController.m
//  DiaryMobile
//
//  Created by ligb on 2019/1/9.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import "TabBarViewController.h"
#import "KDefine.h"

@interface TabBarViewController ()
@property (weak, nonatomic) IBOutlet UITabBar *myTabBar;

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imgs = @[@"tab_button_commu_unselected",
                      @"tab_button_adbo_unselected",
                      @"tab_button_me_unselected"];
    
    NSArray *arrSelectImage = @[@"tab_button_commu_selected",
                                @"tab_button_adbo_selected",
                                @"tab_button_me_selected"
                                ];
    
    NSArray *titles = @[@"首頁", @"通訊錄", @"我的"];
    for (int i=0; i<_myTabBar.items.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        UIImage *image = [[UIImage imageNamed:imgs[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *select = [[UIImage imageNamed:arrSelectImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitle:titles[i]];
        
        // 设置 tabbarItem 选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
        NSDictionary *dicNormalAtt = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        [item setTitleTextAttributes:dicNormalAtt forState:UIControlStateNormal];
        
        NSDictionary *dicSelectedAtt = @{NSFontAttributeName: [UIFont systemFontOfSize:15],
                                         NSForegroundColorAttributeName: kTabBarColor.color
                                         };
        [item setTitleTextAttributes:dicSelectedAtt forState:UIControlStateSelected];
        [item setImage:image];
        [item setSelectedImage:select];
        [item setImageInsets:UIEdgeInsetsMake(-2.5, 0, 2.5, 0)];
    }
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationWithTabbarChangeSelectIndex:) name:kNotificationForTabbarChangeSelectIndex object:nil];
}


- (void)notificationWithTabbarChangeSelectIndex:(NSNotification *)notification {
    NSInteger nowIndex = [notification.object integerValue];
    dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
    dispatch_after(waitTime, dispatch_get_main_queue(), ^(void){
        self.selectedIndex = nowIndex;
    });
}
@end
