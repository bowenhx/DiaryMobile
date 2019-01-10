//
//  WebViewController.h
//  EduKingdom
//
//  Created by HY on 16/7/18.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController

@property (nonatomic,copy)NSString *vNavTitle; //标题
@property (nonatomic,copy)NSString *vWebUrl;   //url

@property (nonatomic , copy)NSString *tid;//帖子tid or 日誌id
@property (nonatomic , copy)NSString *name;//帖子標題 or 日誌標題
@property (nonatomic , copy)NSString *uid;//日志所属用户id
@property (nonatomic , assign) NSInteger ispassword;

+ (void)pushOpenWebViewControllerWithURL:(NSString *)url title:(NSString *)title withFromViewCotroller:(UIViewController *)from;
@end
