//
//  WebViewController.m
//  EduKingdom
//
//  Created by ligb on 16/7/18.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "WebViewController.h"
#import "CustomAlertController.h"
#import "KDefine.h"

//用來保存查看日志的密碼
#define BlogPw_KEY  @"BLOGPWKEY"
#define BlogKey(pw)      [NSString stringWithFormat:@"blog_pw_%@",(pw)]

@interface WebViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic , copy)NSString *vShareBlogUrl;
@property (nonatomic , strong)WKWebView * wkWebView;
@end

@implementation WebViewController


- (void)dealloc{
    if (_wkWebView) {
        _wkWebView.navigationDelegate = nil;
        _wkWebView.scrollView.delegate = nil;
        _wkWebView = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    
    self.navigationItem.title = self.vNavTitle;
    if ([self.vNavTitle isEqualToString:@"日誌"]) {
//        UIImage *image = [UIImage imageNamed:@"share_unpressed"];
//        [self.rightBtn setImage:image forState:UIControlStateNormal];
//        [self.rightBtn setW:image.size.width];
//        [self.rightBtn setH:image.size.height];

        [self verifyPassword];
    } else {
        [self loadRequest];
    }

}

-(void)loadRequest{
    //配置信息
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT -64) configuration:config];
    _wkWebView.navigationDelegate = self;
    _wkWebView.scrollView.delegate = self;
    [_wkWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_wkWebView setBackgroundColor:[UIColor clearColor]];
    [_wkWebView setMultipleTouchEnabled:YES];
    [_wkWebView setUserInteractionEnabled:YES];
    [_wkWebView setContentMode:UIViewContentModeScaleAspectFill];
    [_wkWebView setAutoresizesSubviews:YES];
    [_wkWebView.scrollView setShowsHorizontalScrollIndicator:NO];
    [_wkWebView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.view insertSubview:_wkWebView atIndex:0];
    
    if ([self.vWebUrl isKindOfClass:[NSURL class]]) {
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:(NSURL *)self.vWebUrl]];
    }else if ([self.vWebUrl isKindOfClass:[NSString class]]) {
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.vWebUrl]]];
    }
        
}
#pragma mark 验证日志详情页面需要密码查看
- (void)verifyPassword{
    if (self.ispassword && self.uid != USERID) {
        //需要密码才能查看
        //需要密碼時
        NSDictionary *forumDic = [BKSaveData getDictionary:BlogPw_KEY];
        if (forumDic) {
            //當字典有值，取出對應的密碼來驗證
            NSString *pw = forumDic[BlogKey(self.tid)];
            if ([@"" isStringBlank:pw]) {
                //弹出密码输入框
                [self addAlertViewAction];
            }else{
                //验证密码请求
                [self beginVerifyPasswordAction:pw showActivity:@"正在驗證..."];
            }
        } else {
            //弹出密码输入框
            [self addAlertViewAction];
        }
    }else{
        //验证密码请求
        [self beginVerifyPasswordAction:@"" showActivity:@"正在獲取鏈接"];
    }
}


- (void)beginVerifyPasswordAction:(NSString *)pw showActivity:(NSString *)text
{
     [self.view showHUDActivityView:text shade:NO];
    __weak typeof(self) bself = self;
    [BaseNetworking mHttpWithUrl:kBlogDetail parameter:@{@"token":TOKEN,@"id":self.tid,@"uid":self.uid,@"password":pw} response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else if (model.status == 1) {
            if ([model.data isKindOfClass:[NSDictionary class]]) {
                self.vWebUrl = model.data[@"webviewurl"];
                [self loadRequest];
                
                self.vShareBlogUrl = model.data[@"shareurl"];

                //進入該頁面后，當密碼不為空時，存到本地字典中
                NSDictionary *dic = [BKSaveData getDictionary:BlogPw_KEY];
                NSMutableDictionary *addPawDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [addPawDic setObject:pw forKey:BlogKey(self.tid)];
                [BKSaveData setDictionary:addPawDic key:BlogPw_KEY];
            }
        }else if (model.status == 0){
            [bself.view showHUDTitleView:model.message image:nil];
        }else{
            [bself.view showHUDTitleView:@"密碼錯誤，請重新輸入" image:nil];
            //弹出密码输入框
            [self addAlertViewAction];
        }
    }];
    
}

- (void)tapRightBtn {
}


#pragma mark - WKNavigationDelegate

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.view showHUDActivityView:@"正在加載..." shade:NO];
//    NSLog(@"%s", __FUNCTION__);
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
//    NSLog(@"%s",  __FUNCTION__);
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.view removeHUDActivity];
    if ([self.vNavTitle isEqualToString:@"日誌"]) {
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'" completionHandler:nil];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //跳转做处理；
    if ([self.vNavTitle isEqualToString:@"日誌"]) {
        if (navigationAction.targetFrame == nil) {
            NSString *url = [[navigationAction.request URL] absoluteString];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else {
            // 允许跳转
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    } else {
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else {
            // 允许跳转
            decisionHandler(WKNavigationActionPolicyAllow);
        }
       
    }
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.view showHUDTitleView:error.localizedDescription image:nil];
//    NSLog(@"%s", __FUNCTION__);
}

- (void)addAlertViewAction
{
    CustomAlertController *customAlert = [[CustomAlertController alloc] init];
    customAlert.message(@"加密日誌，請輸入密碼").tfPlaceholders(@[@"請輸入密碼"]).confirmTitle(@"確定").cancelTitle(@"取消").controller(self).alertStyle(alert);
    [customAlert showTextField:^(UITextField *textField) {
        //密码设置非明文
        textField.secureTextEntry = YES;
    } confirmAction:^(UIAlertAction *action, NSArray<UITextField *> *textFields) {
        UITextField *textField = textFields.firstObject;
        if ([@"" isStringBlank:textField.text]) {
            [self.view showHUDTitleView:@"输入密码才能訪問" image:nil];
            [self addAlertViewAction];
        } else {
            //去验证密码是否正确
            [self beginVerifyPasswordAction:textField.text showActivity:@"正在驗證..."];
        }
    } cancelAction:^(UIAlertAction *action, NSArray<UITextField *> *textFields) {
        [self tapBackBtn];
    }];
}

#pragma mark -
+ (void)pushOpenWebViewControllerWithURL:(NSString *)url title:(NSString *)title withFromViewCotroller:(UIViewController *)from{
    WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webVC.vWebUrl = url;
    webVC.vNavTitle = title;
    @WeakObj(from);
    [fromWeak.navigationController pushViewController:webVC animated:YES];
}



@end
