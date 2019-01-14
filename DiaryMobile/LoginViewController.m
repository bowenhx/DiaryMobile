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
    
}

- (IBAction)goWithLoginAction:(id)sender {
    
    
}



- (void)tapBackBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
