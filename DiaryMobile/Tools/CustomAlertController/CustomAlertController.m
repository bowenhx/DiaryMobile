//
//  CustomAlertController.m
//  BKCustomAlertDemo
//
//  Created by ligb on 2017/11/15.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "CustomAlertController.h"

@interface UIWindow (Util)
//@brief  获取到当前可见的页面 @return 返回得到的当前页面
- (UIViewController *)visibleViewController;
@end

@implementation UIWindow (Util)

- (UIViewController *)visibleViewController {
    UIViewController *rootViewController = self.rootViewController;
    return [UIWindow getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

@end

@interface AlertViewParams: NSObject
@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, assign) UIAlertControllerStyle alertStyle;

@property (nonatomic, assign) UIAlertActionStyle confirmStyle;

@property (nonatomic, assign) UIAlertActionStyle cancelStyle;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *confirmTitle;

@property (nonatomic, copy) NSString *cancelTitle;

@property (nonatomic, copy) NSArray <NSString *> *tfPlaceholders;

@property (nonatomic, copy) NSArray <NSString *> *actions;

@property (nonatomic, assign) CGRect sourceRect;

@property (nonatomic, strong) UIView *sourceView;

@end

@interface CustomAlertController ()
@property (nonatomic, strong) AlertViewParams *params;
@end

@implementation CustomAlertController

+ (CustomAlertController *)alertController {
    return [[CustomAlertController alloc] init];
}

- (CustomAlertController *)init {
    if (self = [super init]) {
        _params = [AlertViewParams new];
    }
    return self;
}


- (CustomAlertController *(^)(NSString *))title {
    return ^(NSString *str) {
        self.params.title = str;
        return self;
    };
}


- (CustomAlertController *(^)(NSString *))message {
    return ^(NSString *str) {
        self.params.message = str;
        return self;
    };
}


- (CustomAlertController *(^)(NSString *))cancelTitle {
    return ^(NSString *str) {
        self.params.cancelTitle = str;
        return self;
    };
}


- (CustomAlertController *(^)(NSString *))confirmTitle {
    return ^(NSString *str) {
        self.params.confirmTitle = str;
        return self;
    };
}


- (CustomAlertController *(^)(NSArray <NSString *>*))actions {
    return ^(NSArray <NSString *> *actions) {
        self.params.actions = actions;
        return self;
    };
}


- (CustomAlertController *(^)(NSArray <NSString *>*))tfPlaceholders {
    return ^(NSArray <NSString *> *placeholders) {
        self.params.tfPlaceholders = placeholders;
        return self;
    };
}


- (CustomAlertController *(^)(UIViewController *))controller {
    return ^(UIViewController *ctr) {
        self.params.controller = ctr;
        return self;
    };
}


- (CustomAlertController *(^)(AlertStyle))alertStyle {
    return ^(AlertStyle style) {
        if (style == alert) {
            self.params.alertStyle = UIAlertControllerStyleAlert;
        } else {
            self.params.alertStyle = UIAlertControllerStyleActionSheet;
        }
        return self;
    };
}


- (CustomAlertController *(^)(AlertActionStyle))confirmStyle {
    return ^(AlertActionStyle style) {
        if (style == ActionStyleDefault) {
            self.params.confirmStyle = UIAlertActionStyleDefault;
        } else if (style == ActionStyleCancel) {
            self.params.confirmStyle = UIAlertActionStyleCancel;
        } else {
            self.params.confirmStyle = UIAlertActionStyleDestructive;
        }
        return self;
    };
}


- (CustomAlertController *(^)(AlertActionStyle))cancelStyle {
    return ^(AlertActionStyle style) {
        if (style == ActionStyleDefault) {
            self.params.cancelStyle = UIAlertActionStyleDefault;
        } else if (style == ActionStyleCancel) {
            self.params.cancelStyle = UIAlertActionStyleCancel;
        } else {
            self.params.cancelStyle = UIAlertActionStyleDestructive;
        }
        return self;
    };
}


- (CustomAlertController *(^)(CGRect))sourceRect {
    return ^(CGRect rect) {
        self.params.sourceRect = rect;
        return self;
    };
}


- (CustomAlertController *(^)(UIView *))sourceView {
    return ^(UIView *sourceView) {
        self.params.sourceView = sourceView;
        return self;
    };
}


- (CustomAlertController *)show:(void (^)(UIAlertAction *action, NSInteger index))defaultAction
                  confirmAction:(void (^)(UIAlertAction *action))confirmAction
                   cancelAction:(void (^)(UIAlertAction *action))cancelAction {
    return [self addAlertControllerAction:defaultAction textField:nil confirmAction:^(UIAlertAction *action, NSArray<UITextField *> *textFields) {
        if (confirmAction) {
            confirmAction(action);
        }
    } cancelAction:^(UIAlertAction *action, NSArray<UITextField *> *textFields) {
        if (cancelAction) {
            cancelAction(action);
        }
    }];
}


- (CustomAlertController *)showTextField:(void (^)(UITextField *))textFieldHandler
                           confirmAction:(void (^)(UIAlertAction *, NSArray<UITextField *> *))confirmAction
                            cancelAction:(void (^)(UIAlertAction *, NSArray<UITextField *> *))cancelAction {
    return [self addAlertControllerAction:nil textField:textFieldHandler confirmAction:confirmAction cancelAction:cancelAction];
}


- (CustomAlertController *)addAlertControllerAction:(void (^)(UIAlertAction *action, NSInteger index))defaultAction
                       textField:(void (^)(UITextField *textField))textFieldHandler
                   confirmAction:(void(^)(UIAlertAction *action, NSArray<UITextField *> *textFields))confirmAction
                    cancelAction:(void(^)(UIAlertAction *action, NSArray<UITextField *> *textFields))cancelAction {
    //if (!self.params.actions.count && !self.params.tfPlaceholders)  return nil;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.params.title message:self.params.message preferredStyle:self.params.alertStyle];
    
    if (self.params.actions.count) {
        [self.params.actions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (defaultAction) {
                    defaultAction(action, idx);
                }
            }];
            [alert addAction:action];
        }];
    }
    
    if (self.params.tfPlaceholders) {
        if (self.params.alertStyle == UIAlertControllerStyleAlert) {
            [self.params.tfPlaceholders enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = obj;
                    textField.tag = idx;
                    if (textFieldHandler) {
                        textFieldHandler(textField);
                    }
                }];
            }];
        } else {
            NSLog(@"'Text fields can only be added to an alert controller of style UIAlertControllerStyleAlert'");
        }
    }
    
    if (self.params.cancelTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:self.params.cancelTitle style:self.params.cancelStyle handler:^(UIAlertAction * _Nonnull action) {
            if (cancelAction) {
                cancelAction(action, alert.textFields);
            }
        }]];
    }
    
    if (self.params.confirmTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:self.params.confirmTitle style:self.params.confirmStyle handler:^(UIAlertAction * _Nonnull action) {
            if (confirmAction) {
                confirmAction(action, alert.textFields);
            }
        }]];
    }
    
    if (self.params.sourceView) {
        alert.popoverPresentationController.sourceView = self.params.sourceView;
        alert.popoverPresentationController.sourceRect = self.params.sourceRect;
    }
    
    if (self.params.controller) {
        [self.params.controller presentViewController:alert animated:true completion:nil];
    } else {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window.visibleViewController presentViewController:alert animated:true completion:nil];
    }
    
    return self;
}



@end

@implementation AlertViewParams
@end


