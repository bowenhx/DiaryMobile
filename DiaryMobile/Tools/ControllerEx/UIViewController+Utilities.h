//
//  UIViewController+Utilities.h
//  DiaryMobile
//
//  Created by stray s on 2019/1/12.
//  Copyright © 2019年 com.professional.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utilities)

- (void)setParames:(id)parames;

- (void)showNextControllerName:(NSString *)className
                        params:(id)params
                        isPush:(BOOL)isPush;
@end
