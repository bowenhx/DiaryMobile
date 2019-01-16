//
//  UIViewController+Utilities.m
//  DiaryMobile
//
//  Created by stray s on 2019/1/12.
//  Copyright © 2019年 com.professional.cn. All rights reserved.
//

#import "UIViewController+Utilities.h"

@implementation UIViewController (Utilities)

- (void)setParames:(id)parames {
}

- (void)showNextControllerName:(NSString *)className
                        params:(id)params
                        isPush:(BOOL)isPush {
    UIViewController *controller = [[NSClassFromString(className) alloc] init];
    if (params) [controller setParames:params];
    if (isPush) {
//        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
