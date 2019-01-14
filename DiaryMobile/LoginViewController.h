//
//  ViewController.h
//  DiaryMobile
//
//  Created by ligb on 2019/1/9.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

+ (BOOL)initWithLoginVC:(UIViewController *)viewController;

+ (BOOL)initWithLoginVC:(UIViewController *)viewController from:(NSString *)from;

//- (void)dismissLoginViewWithCompletion:(void (^ __nullable)(void))completion;

@end

