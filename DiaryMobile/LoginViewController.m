//
//  LoginViewController.m
//  DiaryMobile
//
//  Created by ligb on 2019/1/9.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseNavigationViewController.h"

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
    
    
}



- (void)tapBackBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
