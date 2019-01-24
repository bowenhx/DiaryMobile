//
//  LoginViewController.m
//  DiaryMobile
//
//  Created by ligb on 2019/1/9.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseNavigationViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, copy) NSString *from;

@end

@implementation LoginViewController

+ (BOOL)initWithLoginVC:(UIViewController *)viewController {
    if (LOGINSTATUS) {
        return NO;
    }
    return [self mInitLoginViewCollecter:viewController from:nil];
}

+ (BOOL)initWithLoginVC:(UIViewController *)viewController from:(NSString *)from{
    if (LOGINSTATUS) {
        return NO;
    }
    return [self mInitLoginViewCollecter:viewController from:from];
}

+ (BOOL)mInitLoginViewCollecter:(UIViewController *)viewController from:(NSString *)from {
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    if (from) loginVC.from = from;
    loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:loginVC];
    [viewController presentViewController:nav animated:YES completion:nil];
    return YES;
}

- (IBAction)didSelectRegisterAction:(UIButton *)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
    
    @WeakObj(self);
    registerVC.pushHomePageVC = ^(NSDictionary *info){
        selfWeak.userName.text = info[@"username"];
        selfWeak.password.text = info[@"password"];
    };
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [super backBtn];
    self.navigationItem.title = @"登錄";
    _loginBtn.layer.cornerRadius = 3;
    _loginBtn.layer.masksToBounds = YES;
    
    CALayer *line1 = [[CALayer alloc] init];
    line1.frame = CGRectMake(_userName.x, _userName.max_Y+1, kSCREEN_WIDTH - _userName.x - 40, 0.5);
    line1.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.view.layer addSublayer:line1];
    
    CALayer *line2 = [[CALayer alloc] init];
    line2.frame = CGRectMake(_password.x, _password.max_Y, kSCREEN_WIDTH - _password.x - 40, 0.5);
    line2.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.view.layer addSublayer:line2];
}

- (IBAction)goWithLoginAction:(id)sender {
    if ([@"" isStringBlank:_userName.text]) {
        [self.view showHUDTitleView:@"用戶名不能為空" image:nil];
        return;
    } else if ([@"" isStringBlank:_password.text]){
        [self.view showHUDTitleView:@"密碼不能為空" image:nil];
        return;
    }
    [self sendUserInfoAction];
}

- (void)sendUserInfoAction {
    NSString *uname = [BKTool stringByUrlEncoding:_userName.text];
    NSString *password = [BKTool stringByUrlEncoding:_password.text];
    [self.view showHUDActivityView:@"正在加載..." shade:YES];
    NSDictionary *parameter = @{@"username":uname,@"password":password,@"deviceID":@""};
    [BaseNetworking mHttpWithUrl:kLoginLogin parameter:parameter response:^(BKNetworkModel *model, NSString *netErr) {
        [self.view removeHUDActivity];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else{
            if (model.status == 1) {
                //保存用户对象
                User * user = [[User alloc] init];
                [user setValuesForKeysWithDictionary:model.data];
                [SaveUser mSaveUser:user];
                
                [self didTouchBackAction];
                
                
                //发送登录成功的通知
//                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
                
                //登录成功后，通知讨论区，刷新页面，根据账号来改变板块
//                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginWithRefreshForumNotification object:nil];
             
                NSString *message = model.message;
                [[CustomAlertController alertController].message(message).alertStyle(alert).confirmTitle(@"確定").controller(self) show:nil confirmAction:^(UIAlertAction *action) {
                     [self dismissViewControllerAnimated:YES completion:nil];
                } cancelAction:nil];
            } else {
                [self.view showHUDTitleView:model.message image:nil];
            }
        }
    }];
}

//登录成功后，保存用户信息
- (void)didTouchBackAction {
    //登录成功后进入页面
    if (_from && [_from isEqualToString:@"inPage"]) {
        [self tapBackBtn];
    } else {
       
    }
}

- (void)tapBackBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
