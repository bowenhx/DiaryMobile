//
//  CustomAlertController.h
//  BKCustomAlertDemo
//
//  Created by ligb on 2017/11/15.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//样式-- 默认sheet
typedef NS_ENUM(NSInteger, AlertStyle) {
    sheet = 0,
    alert
};

//按钮样式
typedef NS_ENUM(NSInteger, AlertActionStyle) {
    ActionStyleDefault = 0,
    ActionStyleCancel,
    ActionStyleDestructive
};

@interface CustomAlertController : NSObject
//Returns the default singleton instance.
@property (class, readonly, strong) CustomAlertController *alertController;

@property (nonatomic, readonly) CustomAlertController *(^title)(NSString *title);
@property (nonatomic, readonly) CustomAlertController *(^message)(NSString *message);
@property (nonatomic, readonly) CustomAlertController *(^confirmTitle)(NSString *confirmTitle);
@property (nonatomic, readonly) CustomAlertController *(^cancelTitle)(NSString *cancelTitle);
@property (nonatomic, readonly) CustomAlertController *(^actions)(NSArray <NSString *> *actions);
@property (nonatomic, readonly) CustomAlertController *(^tfPlaceholders)(NSArray <NSString *> *tfPlaceholders);//alert 上指定输入框
@property (nonatomic, readonly) CustomAlertController *(^alertStyle)(AlertStyle);//样式，默认sheet
@property (nonatomic, readonly) CustomAlertController *(^confirmStyle)(AlertActionStyle);//确定按钮样式
@property (nonatomic, readonly) CustomAlertController *(^cancelStyle)(AlertActionStyle);//取消按钮样式
@property (nonatomic, readonly) CustomAlertController *(^controller)(UIViewController *controller);//使用指定controller来present，默认rootVC
@property (nonatomic, readonly) CustomAlertController *(^sourceRect)(CGRect);//用于ipad中指定弹出位置
@property (nonatomic, readonly) CustomAlertController *(^sourceView)(UIView *sourceView);//用于ipad中指定弹出的源视图

/**
 UIAlertController //链式语法 按需构建AlertController

 @param defaultAction 其他按钮回调，默认nil
 @param confirmAction 确定按钮回调，默认nil
 @param cancelAction 取消按钮回调，默认nil
 @return CustomAlertController实例
 
 用法案例：
     CustomAlertController *customAlert = [[CustomAlertController alloc] init];

 //默认action Sheet
     customAlert.title(@"这是actionSheet").message(@"信息").actions(@[@"测试1",@"测试2",@"测试3"]).cancelTitle(@"cancel").controller(self);
     [customAlert show:^(UIAlertAction *action) {
          NSLog(@"action.title = %@",action.title);
     } confirmAction:^(UIAlertAction *action) {
         NSLog(@"确定");
     } cancelAction:^(UIAlertAction *action) {
          NSLog(@"取消");
     }];
 
 //alert view 1
     customAlert.title(@"这是alert").message(@"message").cancelTitle(@"取消").confirmTitle(@"确定").controller(self).alertStyle(alert);
     [customAlert show:nil confirmAction:^(UIAlertAction *action) {
     NSLog(@"action.title = %@",action.title);
     } cancelAction:nil];
 
 
 //alert view 2 简易版，按需定制
     customAlert.message(@"测试").confirmTitle(@"確定").alertStyle(alert).controller(self);
     [customAlert show:nil confirmAction:nil cancelAction:nil];
 */

- (CustomAlertController *)show:(void (^)(UIAlertAction *action, NSInteger index))defaultAction
                  confirmAction:(void (^)(UIAlertAction *action))confirmAction
                   cancelAction:(void (^)(UIAlertAction *action))cancelAction;


/**
 alert 上面指定输入框，例如账号，密码

 @param textFieldHandler textField添加完成后回调，这里可以自由修改配置信息
 @param confirmAction 确定按钮回调，默认nil
 @param cancelAction 取消按钮回调，默认nil
 @return CustomAlertController实例
 
 使用案例：
 
 CustomAlertController *customAlert = [[CustomAlertController alloc] init];
 
 customAlert.title(@"这是一个TextField").message(@"描述信息").tfPlaceholders(@[@"请输入用户名",@"请输入密码"]).cancelTitle(@"取消").confirmTitle(@"确定").controller(self).alertStyle(alert);
 [customAlert showTextField:^(UITextField *textField) {
    if (textField.tag == 1) {
        textField.secureTextEntry = YES;
     }
    NSLog(@"textField.text = %@",textField.text);
 } confirmAction:^(UIAlertAction *action, NSArray<UITextField *> *textFields) {
     for (UITextField *textField in textFields) {
        NSLog(@"* *  textField.text = %@",textField.text);
     }
 } cancelAction:^(UIAlertAction *action, NSArray<UITextField *> *textFields) {
 
 }];
 */
- (CustomAlertController *)showTextField:(void (^)(UITextField *textField))textFieldHandler
                           confirmAction:(void(^)(UIAlertAction *action, NSArray<UITextField *> *textFields))confirmAction
                            cancelAction:(void(^)(UIAlertAction *action, NSArray<UITextField *> *textFields))cancelAction;

@end
