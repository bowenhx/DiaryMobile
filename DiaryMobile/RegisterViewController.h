//
//  RegisterViewController.h
//  BKMobile
//
//  Created by Guibin on 15/10/21.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
@interface RegisterViewController : BaseViewController

/*当用户点击facebook 登录完成后跳转到完善资料页面*/
@property (nonatomic , copy) NSDictionary *infoData;
@property (nonatomic , copy) void (^ pushHomePageVC )(NSDictionary *info);
@end
